import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mental_health/services/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdateProfilePage extends StatefulWidget {
  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final Profile _profile = Profile();
  final _formKey = GlobalKey<FormState>();

  String? _apodo;
  String? _nombreCompleto;
  DateTime? _fechaDeNacimiento;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    String email = await _profile.initializeEmail();
    try {
      String? apodo = await _profile.getDataByCorreo(email, "Apodo");
      String? nombreCompleto =
          await _profile.getDataByCorreo(email, "Nombre completo");

      // Llamada al nuevo método para obtener la fecha de nacimiento
      DateTime? fechaDeNacimiento =
          await _profile.getFechaNacimientoByCorreo(email);

      // Actualizar el estado con los datos obtenidos
      setState(() {
        _apodo = apodo;
        _nombreCompleto = nombreCompleto;
        _fechaDeNacimiento = fechaDeNacimiento;
      });
    } catch (e) {
      print("Error al obtener los datos del perfil: $e");
    }
  }

  Future<void> updateProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      String email = await _profile.initializeEmail();

      try {
        await _profile.updateData(email, {
          "Apodo": _apodo,
          "Nombre completo": _nombreCompleto,
          "Fecha de nacimiento": Timestamp.fromDate(_fechaDeNacimiento!),
        });

        // Muestra un mensaje de éxito y navega de regreso a la pantalla anterior
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Datos actualizados con éxito')),
        );
        Navigator.popAndPushNamed(context, '/profileShow');
      } catch (e) {
        print("Error al actualizar los datos: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar los datos')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Actualizar Perfil'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _apodo == null
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                              shape: CircleBorder(), // Define la forma circular
                              padding: EdgeInsets.all(
                                  5), // Espacio alrededor del botón
                            ),
                            onPressed: () {
                              // Navegar a la pantalla de actualización
                              updateProfile;
                            },
                            child: Icon(
                              Icons.update, // Ícono superpuesto
                              size: 50, // Tamaño del ícono
                              color: Colors.lightGreen, // Color del ícono
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(13),
                          child: Icon(
                            Icons.account_box_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: TextFormField(
                            initialValue: _nombreCompleto,
                            decoration: InputDecoration(
                              labelText: 'Nombre Completo',
                            ),
                            onSaved: (value) => _nombreCompleto = value,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Este campo es obligatorio'
                                : null,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(13),
                          child: Icon(
                            Icons.account_box_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: TextFormField(
                            initialValue: _apodo,
                            decoration: InputDecoration(labelText: 'Apodo'),
                            onSaved: (value) => _apodo = value,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Este campo es obligatorio'
                                : null,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(13),
                          child: Icon(
                            Icons.date_range_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: TextFormField(
                            initialValue: _fechaDeNacimiento != null
                                ? "${_fechaDeNacimiento!.day}/${_fechaDeNacimiento!.month}/${_fechaDeNacimiento!.year}"
                                : '',
                            decoration: InputDecoration(
                                labelText: 'Fecha de Nacimiento'),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate:
                                    _fechaDeNacimiento ?? DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );

                              if (pickedDate != null &&
                                  pickedDate != _fechaDeNacimiento) {
                                setState(() {
                                  _fechaDeNacimiento = pickedDate;
                                });
                              }
                            },
                            validator: (value) => _fechaDeNacimiento == null
                                ? 'Este campo es obligatorio'
                                : null,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 24),
                    /*ElevatedButton(
                      onPressed: updateProfile,
                      child: Text('Actualizar Datos'),
                    ),*/
                  ],
                ),
              ),
      ),
    );
  }
}
