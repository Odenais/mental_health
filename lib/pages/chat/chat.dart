import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mental_health/config.dart';
import 'package:mental_health/pages/chat/video.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../services/profile.dart';

import 'package:rive/rive.dart' as rive;

import '../../widgets/menu.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

enum TtsState { playing, stopped, paused, continued }

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

  TtsState ttsState = TtsState.stopped;

  bool get isPlaying => ttsState == TtsState.playing;

  bool get isStopped => ttsState == TtsState.stopped;

  bool get isPaused => ttsState == TtsState.paused;

  bool get isContinued => ttsState == TtsState.continued;

  @override
  void initState() {
    super.initState();
    initTts();
  }

  dynamic initTts() {
    _flutterTts = FlutterTts();

    _flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    _flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    _flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    _flutterTts.setPauseHandler(() {
      setState(() {
        print("Paused");
        ttsState = TtsState.paused;
      });
    });

    _flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    _flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
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
    setState(() => isSpeaking(false));
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
              reset(true);
              print("FIN DE EJECUCION");
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
          onResult: (val) => setState(() {
            textController.text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      isDownloading(true);
    }
  }

  Future<void> generateContent(String query) async {
    setState(() {
      loading = true;
    });

    const apiKey = Config.apiKey;
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
      List<String> phrases = [
        'pon música',
        'pon algo de música',
        'recomiéndame música',
        'pon musica',
        'pon algo de musica',
        'recomiéndame musica',
        'recomiendame musica',
        'recomiendame música',
      ];

      String? lastMessage = messages.isNotEmpty ? messages.last['text'] : null;
      bool containsPhrase = false;
      for (String phrase in phrases) {
        if (messages.isNotEmpty &&
            lastMessage!.toLowerCase().contains(phrase)) {
          containsPhrase = true;
          break; // Sale del bucle si se encuentra una coincidencia
        }
      }

      if (containsPhrase) {
        addMessage("Music", getRandomElement(obtenerListaAleatoria()));
      } else {
        addMessage('Bot', botResponse);
        await _speakText(botResponse);
      }

      // Verifica si el motor de texto a voz ya está hablando
      isChatting(false);
      isSpeaking(true);
      reset(true);
      // Llamar al método para que lea el texto del bot
    } catch (e) {
      addMessage(
          'User', query); // Mostrar la consulta completa en caso de error
      addMessage('Bot', 'Error: ${e.toString()}');
    } finally {
      isSpeaking(
          false); //Aqui tiene que estar en falso y hacerlo bucle hasta que termine de hablar. solo la primera vez, despues ni los puntos
      //Si le pongo false si salen los puntos en los demas
      isSpeaking(true);

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
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }

  Widget buildMessage(Map<String, String> message) {
    final isUser = message['role'] == 'User';

    // Verificar si el rol es 'Music', lo que indica que es un video
    final isVideo = message['role'] == 'Music';

    // Si es un video, muestra el YoutubePlayerComponent
    if (isVideo) {
      return Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: AudioPlayerComponent(query: message['text']!),
        ),
      );
    }
    scrollToEnd();
    // Si es un mensaje de texto, renderiza como antes
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
        decoration: BoxDecoration(
          color: isUser
              ? const Color.fromARGB(255, 170, 149, 208)
              : Colors.grey[300],
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
          style: const TextStyle(fontWeight: FontWeight.bold),
        ));
      } else if (match.group(3) != null) {
        // Solo texto en negritas: **texto**
        spans.add(TextSpan(
          text: match.group(3),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ));
      } else if (match.group(4) != null) {
        // Solo viñetas sin negritas: * texto
        spans.add(const TextSpan(
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

  Future<void> _stopSpeech() async {
    var result = await _flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  Future<String?> getApodo() async {
    String correo = _profile.initializeEmail();
    return _profile.getDataByCorreo(correo, "Apodo");
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // COMPORTAMIENTO DEL AVATAR

  rive.SMIInput<bool>? isSpeak;
  rive.SMIInput<bool>? isNoInternet;
  rive.SMIInput<bool>? isError;
  rive.SMIInput<bool>? isChat;
  rive.SMIInput<bool>? isReset;
  rive.SMINumber? download;

  late rive.StateMachineController? stateMachineController,
      stateMachineControllerBg;

  void isSpeaking(value) {
    if (stateMachineController != null) {
      isSpeak?.change(value);
    }
  }

  void isConnected(bool value) {
    if (stateMachineController != null) {
      isNoInternet?.change(value);
    }
  }

  void error(bool value) {
    if (stateMachineController != null) {
      isError?.change(value);
    }
  }

  void isChatting(bool value) {
    if (stateMachineController != null) {
      isChat?.change(value);
    }
  }

  void reset(bool value) {
    if (stateMachineController != null) {
      isReset?.change(value);
    }
  }

  var percent = 0;

  void isDownloading(value) {
    if (stateMachineController != null) {
      if (value) {
        percent += 10;
        download?.change(percent.toDouble());
      }
    }
  }

  List<List<String>> songs = [
    // Energía Alegre Positiva
    [
      "September – Earth, Wind & Fire",
      "Walking on Sunshine – Katrina and the Waves",
      "Good Vibrations – The Beach Boys",
      "Dancing in the Moonlight – Toploader",
      "I Feel Good – James Brown"
    ],

    // Optimismo y Felicidad Ligera
    [
      "Here Comes the Sun – The Beatles",
      "Happy – Pharrell Williams",
      "Lovely Day – Bill Withers",
      "You Make My Dreams – Hall & Oates",
      "I'm Yours – Jason Mraz"
    ],

    // Aventura, Sentimientos y Libertad
    [
      "Shut Up and Dance – WALK THE MOON",
      "On Top of the World – Imagine Dragons",
      "Send Me on My Way – Rusted Root",
      "Take on Me – a-ha",
      "Don’t Stop Me Now – Queen"
    ],

    // Motivación y Autoestima
    [
      "Uptown Funk – Mark Ronson ft. Bruno Mars",
      "I Will Survive – Gloria Gaynor",
      "I Gotta Feeling – The Black Eyed Peas",
      "Firework – Katy Perry",
      "Stronger – Kanye West"
    ],

    // Relajación y Buen Humor
    [
      "Three Little Birds – Bob Marley",
      "Riptide – Vance Joy",
      "Sunday Morning – Maroon 5",
      "Banana Pancakes – Jack Johnson",
      "Put Your Records On – Corinne Bailey Rae"
    ],
  ];

  List<String> obtenerListaAleatoria() {
    final random = Random();
    int index = random.nextInt(songs.length);
    return songs[index];
  }

  String getRandomElement(List<String> list) {
    final random = Random();
    int randomIndex = random.nextInt(list.length);
    return list[randomIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: CircleAvatar(
              radius: 25,
              backgroundColor: const Color.fromARGB(255, 125, 209, 193),
              child: IconButton(
                icon: const Icon(Icons.music_note),
                onPressed: () {
                  addMessage(
                      "Music", getRandomElement(obtenerListaAleatoria()));
                },
                color: Colors.white,
              ),
            ),
          )
        ],
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: SidebarMenu(),
      body: Container(
        decoration: const BoxDecoration(color: Colors.black),
        child: Stack(
          children: [
            Positioned.fill(
              child: SizedBox.expand(
                child: rive.RiveAnimation.asset(
                  'assets/background_effect.riv',
                  fit: BoxFit.cover,
                  stateMachines: const ["State Machine 1"],
                  onInit: (artBoard) {
                    stateMachineControllerBg =
                        rive.StateMachineController.fromArtboard(
                      artBoard,
                      "State Machine 1",
                    );
                    if (stateMachineControllerBg != null) {
                      artBoard.addController(stateMachineControllerBg!);
                    }
                  },
                ),
              ),
            ),
            Column(
              children: [
                const Padding(padding: EdgeInsets.only(top: 90)),
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: GestureDetector(
                      onTap: startListening,
                      child: rive.RiveAnimation.asset(
                        'assets/robocat.riv',
                        stateMachines: const ["State Machine"],
                        onInit: (artBoard) {
                          stateMachineController =
                              rive.StateMachineController.fromArtboard(
                            artBoard,
                            "State Machine",
                          );
                          if (stateMachineController != null) {
                            artBoard.addController(stateMachineController!);

                            isNoInternet = stateMachineController
                                ?.findInput("No Internet");
                            isError =
                                stateMachineController?.findInput("Error");
                            isChat = stateMachineController?.findInput("Chat");
                            isReset =
                                stateMachineController?.findInput("Reset");
                            download =
                                stateMachineController?.findSMI("Download");
                            isSpeak =
                                stateMachineController?.findInput("Speak");
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8.0),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return buildMessage(messages[index]);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          controller: textController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 170, 149, 208)),
                            ),
                            hintText: 'Escribe un mensaje',
                            hintStyle: const TextStyle(color: Colors.white),
                          ),
                          maxLines: null,
                          onSubmitted: handleSubmitted,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.send,
                          cursorColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            handleSubmitted(textController.text);
                            isChatting(true);
                            isSpeaking(true);
                          },
                          color: const Color.fromARGB(255, 97, 85, 133),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.redAccent,
                        child: IconButton(
                          icon: const Icon(Icons.stop),
                          onPressed: _stopSpeech,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
