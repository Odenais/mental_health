import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mental_health/config.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';

class ChatbotPage extends StatefulWidget {
  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final stt.SpeechToText speech = stt.SpeechToText();

  bool loading = false;
  bool isListening = false;
  double confidence = 1.0;
  List<Map<String, String>> messages = [];

  @override
  void initState() {
    super.initState();
    //initSpeech();
  }

  @override
  void dispose() {
    textController.dispose();
    scrollController.dispose();
    super.dispose();
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
              print('Reconocimiento de voz inicializado correctamente.');
              break;
            case 'listening':
              print('Reconocimiento de voz está escuchando.');
              break;
            case 'notListening':
              print('Reconocimiento de voz no está escuchando.');
              break;
            case 'done':
              print('Reconocimiento de voz ha terminado.');
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
      addMessage('User', query);
      addMessage('Bot', response.text ?? 'No response text.');
    } catch (e) {
      addMessage('User', query);
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
        child: Text(
          message['text'] ?? '',
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  void handleSubmitted(String text) {
    final query = text.trim();
    if (query.isNotEmpty) {
      generateContent(query);
    }
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

