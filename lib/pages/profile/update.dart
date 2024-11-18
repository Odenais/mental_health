import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mental_health/services/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

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
    String email = _profile.initializeEmail();
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
      String email = _profile.initializeEmail();

      try {
        await _profile.updateData(email, {
          "Apodo": _apodo,
          "Nombre completo": _nombreCompleto,
          "Fecha de nacimiento": Timestamp.fromDate(_fechaDeNacimiento!),
        });

        // Muestra un mensaje de éxito y navega de regreso a la pantalla anterior
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datos actualizados con éxito')),
        );
        Navigator.popAndPushNamed(context, '/profileShow');
      } catch (e) {
        print("Error al actualizar los datos: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al actualizar los datos')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text('Actualizar Perfil'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        // Para evitar overflow y hacer que el contenido sea desplazable
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _apodo == null
              ? const Center(child: CircularProgressIndicator())
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
                            top: MediaQuery.of(context).size.width * 0.45,
                            left: MediaQuery.of(context).size.width * 0.40,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(5),
                              ),
                              onPressed: updateProfile,
                              child: const Icon(
                                Icons.update,
                                size: 50,
                                color: Colors.lightGreen,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(13),
                            child: Icon(
                              Icons.account_box_outlined,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: TextFormField(
                                initialValue: _nombreCompleto,
                                decoration: const InputDecoration(
                                  labelText: 'Nombre Completo',
                                  labelStyle: TextStyle(
                                      color: Colors
                                          .white), // Cambiar el color del label
                                ),
                                style: const TextStyle(
                                    color: Colors
                                        .white), // Cambiar el color del texto
                                onSaved: (value) => _nombreCompleto = value,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Este campo es obligatorio'
                                        : null,
                              )),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(13),
                            child: Icon(
                              Icons.account_box_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: TextFormField(
                              initialValue: _apodo,
                              decoration: const InputDecoration(
                                labelText: 'Apodo',
                                labelStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                              onSaved: (value) => _apodo = value,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Este campo es obligatorio'
                                      : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(13),
                            child: Icon(
                              Icons.date_range_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: TextFormField(
                              initialValue: _fechaDeNacimiento != null
                                  ? "${_fechaDeNacimiento!.day}/${_fechaDeNacimiento!.month}/${_fechaDeNacimiento!.year}"
                                  : '',
                              decoration: const InputDecoration(
                                labelText: 'Fecha de Nacimiento',
                                labelStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
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
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
