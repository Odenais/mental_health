import 'package:flutter/material.dart';
import 'package:mental_health/services/profile.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importa Firebase Auth

class SignupProfilePage extends StatefulWidget {
  const SignupProfilePage({super.key});

  @override
  _SignupProfilePageState createState() => _SignupProfilePageState();
}

class _SignupProfilePageState extends State<SignupProfilePage> {
  final Profile _profile = Profile();
  final _formKey = GlobalKey<FormState>();

  // Controladores de texto
  final TextEditingController _nombreCompletoController =
      TextEditingController();
  final TextEditingController _apodoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fechaNacimientoController =
      TextEditingController();

  DateTime? _fechaNacimiento;
  bool _isLoading = false;

  static const Color blueShape50 = Color(0xFFE3F2FD);

  @override
  void initState() {
    super.initState();
    _emailController.text = _profile.initializeEmail();
  }

  // Inicializa el correo electrónico del usuario autenticado
  /*void _initializeEmail() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _emailController.text = user.email ?? ''; // Asigna el correo electrónico al controlador
    }
  }*/

  // Función que se ejecuta al enviar el formulario
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _profile.createUser(
          nombreCompleto: _nombreCompletoController.text,
          apodo: _apodoController.text,
          correo: _emailController.text,
          fechaNacimiento: _fechaNacimiento!,
        );
        // Navegación o mensaje de éxito
        Navigator.popAndPushNamed(context, '/home');
      } catch (e) {
        print("Error al crear el usuario: $e");
        // Manejo de errores, como mostrar un mensaje al usuario
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // Liberar los controladores cuando se destruye el widget
    _nombreCompletoController.dispose();
    _apodoController.dispose();
    _emailController.dispose();
    _fechaNacimientoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Registro de perfil',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nombreCompletoController,
                  decoration: customInputDecoration(
                    labelText: 'Nombre Completo',
                    iconData: Icons.person,
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su nombre completo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _apodoController,
                  decoration: customInputDecoration(
                    labelText: 'Apodo',
                    iconData: Icons.personal_injury_outlined,
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su apodo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _fechaNacimiento = pickedDate;
                        _fechaNacimientoController.text =
                            DateFormat('dd/MM/yyyy').format(pickedDate);
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _fechaNacimientoController,
                      decoration: customInputDecoration(
                        labelText: 'Fecha de nacimiento',
                        iconData: Icons.calendar_month,
                      ),
                      validator: (value) {
                        if (_fechaNacimiento == null) {
                          return 'Por favor seleccione su fecha de nacimiento';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: customInputDecoration(
                    labelText: 'Correo Electrónico',
                    iconData: Icons.email,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  enabled: false, // Hacer el campo de solo lectura
                ),
                const SizedBox(height: 32),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(fontSize: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('Registrar'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration customInputDecoration({
    required String labelText,
    required IconData iconData,
    Color borderColor = Colors.transparent,
    Color fillColor = blueShape50,
    double borderRadius = 12.0,
  }) {
    return InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: fillColor,
      prefixIcon: Icon(iconData, color: Colors.blue.shade700),
    );
  }
}
