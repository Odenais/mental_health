import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mental_health/pages/Techniquels/Breathing_4_7_8.dart';
import 'package:mental_health/pages/Techniquels/Historial.dart';
import 'package:mental_health/pages/Techniquels/PlaneAtentionMeditation.dart';
import 'package:mental_health/pages/Techniquels/TechniquelsList.dart';
import 'package:mental_health/pages/chat/chat.dart';
import 'package:mental_health/pages/home/home.dart';
import 'package:mental_health/pages/login/login.dart';
import 'package:mental_health/pages/profile/show.dart';
import 'package:mental_health/pages/signup/signup.dart';
import 'package:mental_health/pages/signup/signup_profile.dart';
import 'package:mental_health/pages/tests/list.dart';
import 'package:mental_health/pages/tests/percivedStressScale.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Aplicación',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Color(0xFF3F4660),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.grey[800], fontSize: 16),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue.shade50,
          elevation: 0,
        ),
      ),
      home: SplashScreen(),
      routes: {
        '/signup': (context) => SignupPage(),
        '/signupProfile': (context) => SignupProfilePage(),
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/chat': (context) => ChatbotPage(),
        '/profileShow': (context) => ProfileShowPage(),
        '/listTests': (context) => TestListPage(),
        '/percivedStressScale': (context) => PercivedStressScalePage(),
        '/listTechniquels': (context) => TechniquelsListPage(),
        '/breathing_4_7_8': (context) => Breathing_4_7_8(),
        '/planeAtentionMeditation': (context) => planeAtentionMeditation(),
        '/historial': (context) => TestHistoryPage(),
      },
    );
  }
}

// AuthWrapper que verifica el estado de autenticación del usuario
class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    // Verificamos si el usuario está autenticado
    setState(() {
      _user = FirebaseAuth.instance.currentUser;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SplashScreen(); // Mostrar la pantalla de splash mientras carga
    }

    // Si no hay usuario autenticado, mostrar la página de login
    if (_user == null) {
      return LoginPage();
    } else {
      // Si hay un usuario autenticado, mostrar la página de inicio
      return HomePage();
    }
  }
}

// Splash Screen
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 3), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => AuthWrapper()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
              'assets/pixelcut-export-removebg-preview.png'), // Imagen de la splash screen
          SizedBox(
              height: 20), // Espacio entre la imagen y el indicador de carga
          CircularProgressIndicator(), // Indicador de carga
        ],
      )),
    );
  }
}
