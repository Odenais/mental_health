import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mental_health/services/profile.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Profile _profile = Profile();
  String? _apodo;

  //voz
  late FlutterTts _flutterTts;

  @override
  void initState() {
    super.initState();
    // Inicializar el sintetizador de voz
    _flutterTts = FlutterTts();
    // Obtener el apodo y luego hablar el mensaje de bienvenida
    fetchAndSetApodo();
  }

  Future<void> _speakWelcomeMessage() async {
    // Listas de saludos para diferentes momentos del día
    List<String> morningGreetings = [
      "¡Buenos días $_apodo! ¡Espero que tengas un día maravilloso!️",
      "¡Hola $_apodo! ¡Que tu mañana esté llena de energía positiva!",
      "¡Buenos días $_apodo! ¡Que comiences el día con una sonrisa!",
    ];

    List<String> afternoonGreetings = [
      "¡Buenas tardes $_apodo! ¡Espero que estés teniendo un gran día! ",
      "¡Hola $_apodo! ¡Que tu tarde sea tan brillante como tú!",
      "¡Buenas tardes $_apodo! ¡Listo para seguir adelante con tu día?",
    ];

    List<String> eveningGreetings = [
      "¡Buenas noches $_apodo! ¡Espero que hayas tenido un buen día!",
      "¡Hola $_apodo! ¡Que tengas una noche tranquila y relajante!",
      "¡Buenas noches $_apodo! ¡Es hora de descansar y recargar energías!",
    ];

    List<String> lateNightGreetings = [
      "Hola $_apodo, sé que es tarde, pero espero que encuentres un poco de calma esta noche. 🌜",
      "Buenas noches $_apodo, espero que encuentres paz y tranquilidad para descansar bien. 🌙",
      "Hola $_apodo, aunque sea tarde, recuerda que siempre hay un nuevo amanecer por venir. 🌌",
      "Buenas noches $_apodo, espero que encuentres serenidad y tranquilidad para dormir mejor. 💤",
    ];

    // Obtén la hora actual
    DateTime now = DateTime.now();
    int hour = now.hour;

    // Selecciona una lista de saludos basada en la hora del día
    List<String> greetings;
    if (hour >= 5 && hour < 12) {
      greetings = morningGreetings;
    } else if (hour >= 12 && hour < 18) {
      greetings = afternoonGreetings;
    } else if (hour >= 18 && hour < 23) {
      greetings = eveningGreetings;
    } else {
      greetings = lateNightGreetings;
    }

    // Selecciona un saludo aleatorio
    final random = Random();
    String greeting = greetings[random.nextInt(greetings.length)];

    // Verifica si el apodo no es nulo antes de hablar
    if (_apodo != null) {
      await _flutterTts.speak(greeting);
    } else {
      // Si el apodo es nulo, usa un saludo genérico
      await _flutterTts.speak(greeting.replaceAll("$_apodo", "a nuestra aplicación"));
    }
  }

  Future<void> fetchAndSetApodo() async {
    final User? user = FirebaseAuth.instance.currentUser;

    try {
      String? email = user?.email; // Asegúrate de que `user` no sea null
      if (email != null) {
        String? apodo = await _profile.getDataByCorreo(email, "Apodo");
        print('El apodo es: $apodo');
        setState(() {
          _apodo = apodo;
        });
        // Llama a _speakWelcomeMessage después de obtener el apodo
        _speakWelcomeMessage();
      } else {
        print('El correo electrónico es nulo');
      }
    } catch (e) {
      print('Error al obtener el apodo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser; // Obtener usuario autenticado

    return Scaffold(
      appBar: AppBar(
        title: Text('${_apodo ?? 'Usuario'}'),
        automaticallyImplyLeading: false, // Elimina el botón de regresar
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                FirebaseAuth.instance.signOut();
                Navigator.popAndPushNamed(context, '/login');
              } else if (value == 'chat') {
                Navigator.popAndPushNamed(context, '/chat');
              } else if (value == 'profile'){
                Navigator.popAndPushNamed(context, '/profileShow');
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'profile',
                  child: Text('Perfil'),
                ),
                PopupMenuItem<String>(
                  value: 'chat',
                  child: Text('Chatbot'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Bienvenido, ${user?.email ?? 'Usuario'}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.popAndPushNamed(context, '/login');
              },
              child: Text('Cerrar Sesión'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 18),
                backgroundColor: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
