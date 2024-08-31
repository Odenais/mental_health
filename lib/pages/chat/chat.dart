import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mental_health/config.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../services/profile.dart';


class ChatbotPage extends StatefulWidget {
  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final stt.SpeechToText speech = stt.SpeechToText();
  late FlutterTts _flutterTts;
  final Profile _profile = Profile();

  bool loading = false;
  bool isListening = false;
  double confidence = 1.0;
  List<Map<String, String>> messages = [];

  @override
  void initState() {
    super.initState();
    _flutterTts = FlutterTts();
  }

  @override
  void dispose() {
    textController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Future<void> _speakText(String text) async {
    // Eliminar todos los asteriscos del texto
    String cleanText = text.replaceAll(RegExp(r'\*'), '');

    // Reproduce el texto limpio usando el motor de texto a voz
    await _flutterTts.speak(cleanText);
  }

  /*Future<void> initSpeech() async {
    bool available = await speech.initialize();
    if (available) {
      showSnackBar('Reconocimiento de voz inicializado.');
    } else {
      showSnackBar('Fallo en la inicialización del reconocimiento de voz.');
    }
  }*/

  /*void toggleListening() {
    if (isListening) {
      stopListening();
    } else {
      startListening();
    }
  }*/

  void startListening() async {
    if (!isListening) {
      bool available = await speech.initialize(
        onStatus: (status) {
          print('onStatus: $status');
          switch (status) {
            case 'initialized':
              showSnackBar('Reconocimiento de voz inicializado correctamente.');
              break;
            case 'listening':
              showSnackBar('Reconocimiento de voz está escuchando.');
              break;
            case 'notListening':
              showSnackBar('Reconocimiento de voz no está escuchando.');
              break;
            case 'done':
              showSnackBar('Reconocimiento de voz ha terminado.');
              handleSubmitted(textController.text);
              setState(() => isListening = false);
              speech.stop();
              break;
            default:
              print('Estado desconocido: $status');
          }
        },
        onError: (error) {
          print('onError: ${error.errorMsg}'); // Mensaje de error general
        },
      );
      if (available) {
        setState(() => isListening = true);
        speech.listen(
          onResult: (val) =>
              setState(() {
                textController.text = val.recognizedWords;
                if (val.hasConfidenceRating && val.confidence > 0) {
                  confidence = val.confidence;
                }
              }),
        );
      }
    }
  }


  Future<void> generateContent(String query) async {
    setState(() {
      loading = true;
    });

    final apiKey = Config.apiKey;
    if (apiKey.isEmpty) {
      addMessage('System', 'API key is not set.');
      return;
    }

    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    final content = [Content.text(query)];

    try {
      final response = await model.generateContent(content);
      String botResponse = response.text ?? 'No response text.';

      // Agregar el mensaje del usuario y del bot al chat

      addMessage('Bot', botResponse);

      // Llamar al método para que lea el texto del bot
      await _speakText(botResponse);

    } catch (e) {
      addMessage('User', query); // Mostrar la consulta completa en caso de error
      addMessage('Bot', 'Error: ${e.toString()}');
    } finally {
      textController.clear();
      scrollToEnd();
      setState(() {
        loading = false;
      });
    }
  }


  void addMessage(String role, String text) {
    setState(() {
      messages.add({'role': role, 'text': text});
    });
  }


  void scrollToEnd() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }

  Widget buildMessage(Map<String, String> message) {
    final isUser = message['role'] == 'User';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
        decoration: BoxDecoration(
          color: isUser ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: RichText(
          text: TextSpan(
            children: _formatMessage(message['text'] ?? ''),
            style: TextStyle(
              color: isUser ? Colors.white : Colors.black87,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }

  List<TextSpan> _formatMessage(String message) {
    List<TextSpan> spans = [];
    RegExp regExp = RegExp(r"\*(\s\*\*(.*?)\*\*)|\*\*(.*?)\*\*|\*(.*?)\n?");
    int lastMatchEnd = 0;

    for (var match in regExp.allMatches(message)) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(text: message.substring(lastMatchEnd, match.start)));
      }

      if (match.group(2) != null) {
        // Para viñetas con negritas: * **texto**
        spans.add(TextSpan(
          text: "• ${match.group(2)}",
          style: TextStyle(fontWeight: FontWeight.bold),
        ));
      } else if (match.group(3) != null) {
        // Solo texto en negritas: **texto**
        spans.add(TextSpan(
          text: match.group(3),
          style: TextStyle(fontWeight: FontWeight.bold),
        ));
      } else if (match.group(4) != null) {
        // Solo viñetas sin negritas: * texto
        spans.add(TextSpan(
          text: "*",
          style: TextStyle(fontWeight: FontWeight.bold),
        ));
      }

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < message.length) {
      spans.add(TextSpan(text: message.substring(lastMatchEnd)));
    }

    return spans;
  }

  Future<void> handleSubmitted(String text) async {
    String? apodo = await getApodo();
    String msgapodo = "(Mi nombre es $apodo)";

    // Agregar el mensaje original del usuario a la interfaz
    addMessage('User', text);

    // Preparar la consulta para el modelo, agregando "Mi nombre es..."
    String query = text + msgapodo;

    print(query); // Mostrar la consulta completa en la consola para depuración

    if (query.trim().isNotEmpty) {
      generateContent(query); // Enviar la consulta al modelo
    }
  }


  Future<String?> getApodo() async{
    String correo = await _profile.initializeEmail();
    return _profile.getDataByCorreo(correo, "Apodo");
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatbot'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                FirebaseAuth.instance.signOut();
                Navigator.popAndPushNamed(context, '/login');
              } else if(value == 'home'){
                Navigator.popAndPushNamed(context, '/home');
              } else if(value == 'profile'){
                Navigator.popAndPushNamed(context, '/profileShow');
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'home',
                  child: Text('Inicio'),
                ),
                PopupMenuItem<String>(
                  value: 'profile',
                  child: Text('Perfil'),
                ),
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Cerrar Sesión'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return buildMessage(messages[index]);
                  },
                ),
              ),
              if (loading)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Escribe un mensaje',
                        ),
                        maxLines: null,
                        onSubmitted: handleSubmitted,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.send,
                      ),
                    ),
                    SizedBox(width: 8.0),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        handleSubmitted(textController.text);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 80.0,
            left: MediaQuery.of(context).size.width / 2 - 40,
            child: GestureDetector(
              onTap: startListening, // Ahora alterna entre escuchar y detener
              child: AvatarGlow(
                startDelay: Duration(milliseconds: 1000),
                glowColor: Colors.blueAccent.withOpacity(0.3),
                animate: isListening,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.blueAccent, Colors.lightBlueAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Icon(
                    isListening ? Icons.mic : Icons.mic_none,
                    size: 48.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

