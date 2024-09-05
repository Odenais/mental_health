import 'package:flutter/material.dart';
import 'package:mental_health/pages/profile/update.dart';
import 'package:mental_health/services/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../widgets/menu.dart';

class ProfileShowPage extends StatefulWidget {
  @override
  _ProfileShowPageState createState() => _ProfileShowPageState();
}

class _ProfileShowPageState extends State<ProfileShowPage> {
  final Profile _profile = Profile();
  final _formKey = GlobalKey<FormState>();

  String? _apodo;
  String? _nombre_completo;
  String? _fecha_de_nacimiento;
  String? _email;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    String email = await _profile.initializeEmail();
    try {
      String? apodo = await _profile.getDataByCorreo(email, "Apodo");
      String? nombre_completo =
          await _profile.getDataByCorreo(email, "Nombre completo");

      // Llamada al nuevo método para obtener la fecha de nacimiento
      DateTime? fechaDeNacimiento =
          await _profile.getFechaNacimientoByCorreo(email);

      // Formatear la fecha si no es null
      String? fechaDeNacimientoFormatted;
      if (fechaDeNacimiento != null) {
        fechaDeNacimientoFormatted =
            "${fechaDeNacimiento.day}/${fechaDeNacimiento.month}/${fechaDeNacimiento.year}";
      } else {
        fechaDeNacimientoFormatted = "Fecha no disponible"; // Valor por defecto
      }

      // Actualizar el estado con los datos obtenidos
      setState(() {
        _apodo = apodo;
        _nombre_completo = nombre_completo;
        _fecha_de_nacimiento = fechaDeNacimientoFormatted;
        _email = email;
      });
    } catch (e) {
      print("Error al obtener los datos del perfil: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Perfil'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        //automaticallyImplyLeading: false,
      ),
      drawer: SidebarMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _email == null
            ? Center(
                child:
                    CircularProgressIndicator()) // Muestra un loader mientras carga
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nombre completo: $_nombre_completo',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Apodo: $_apodo',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Correo: $_email',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Fecha de Nacimiento: $_fecha_de_nacimiento',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Navegar a la pantalla de actualización
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdateProfilePage()),
                      );
                    },
                    child: Text('Actualizar datos'),
                  ),
                ],
              ),
      ),
    );
  }
}
