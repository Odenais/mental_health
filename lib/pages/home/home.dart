import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mental_health/services/profile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Profile db = Profile();
  String? _apodo;

  @override
  void initState() {
    super.initState();
    fetchAndSetApodo();
  }

  Future<void> fetchAndSetApodo() async {
    final User? user = FirebaseAuth.instance.currentUser;

    try {
      String? email = user?.email; // Asegúrate de que `user` no sea null
      if (email != null) {
        String? apodo = await db.getApodoByCorreo(email);
        print('El apodo es: $apodo');
        setState(() {
          _apodo = apodo;
        });
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
