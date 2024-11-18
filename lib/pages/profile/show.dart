import 'package:flutter/material.dart';
import 'package:mental_health/pages/profile/update.dart';
import 'package:mental_health/services/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../widgets/menu.dart';

class ProfileShowPage extends StatefulWidget {
  const ProfileShowPage({super.key});

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
    String email = _profile.initializeEmail();
    try {
      String? apodo = await _profile.getDataByCorreo(email, "Apodo");
      String? nombreCompleto =
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
        _nombre_completo = nombreCompleto;
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
        title: const Text('Perfil'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        //automaticallyImplyLeading: false,
      ),
      drawer: SidebarMenu(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _email == null
              ? const Center(
                  child:
                      CircularProgressIndicator()) // Muestra un loader mientras carga
              : Column(
                  ///mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(),
                    Stack(
                      children: [
                        Container(
                          child: Icon(
                            Icons.account_circle,
                            size: MediaQuery.of(context).size.width * 0.6,
                            color: Colors.white,
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.width *
                              0.45, // Ajusta la posición vertical
                          left: MediaQuery.of(context).size.width *
                              0.40, // Ajusta la posición horizontal
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape:
                                  const CircleBorder(), // Define la forma circular
                              padding: const EdgeInsets.all(
                                  5), // Espacio alrededor del botón
                            ),
                            onPressed: () {
                              // Navegar a la pantalla de actualización
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UpdateProfilePage()),
                              );
                            },
                            child: const Icon(
                              Icons.edit_document, // Ícono superpuesto
                              size: 50, // Tamaño del ícono
                              color: Colors.lightGreen, // Color del ícono
                            ),
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            '$_nombre_completo',
                            style: const TextStyle(
                                fontSize: 25, color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Apodo: $_apodo',
                            style: const TextStyle(
                                fontSize: 19, color: Colors.white70),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(13),
                                child: Icon(
                                  Icons.email,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '$_email',
                                style: const TextStyle(
                                    fontSize: 21, color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(13),
                                child: Icon(
                                  Icons.date_range_outlined,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Fecha de Nacimiento: \n $_fecha_de_nacimiento',
                                style: const TextStyle(
                                    fontSize: 21, color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    /*ElevatedButton(
                    onPressed: () {
                      // Navegar a la pantalla de actualización
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdateProfilePage()),
                      );
                    },
                    child: Text('Actualizar datos'),
                  ),*/
                  ],
                ),
        ),
      ),
    );
  }
}
