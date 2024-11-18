import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/foundation.dart";
import "package:intl/intl.dart";

class Profile {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser({
    required String nombreCompleto,
    required String apodo,
    required String correo,
    required DateTime fechaNacimiento,
  }) async {
    try {
      await _firestore.collection('users').add({
        'Nombre completo': nombreCompleto,
        'Apodo': apodo,
        'Correo': correo,
        'Fecha de nacimiento':
            Timestamp.fromDate(fechaNacimiento), // Conversión a Timestamp
      });
      print('Usuario creado correctamente');
    } catch (e) {
      print('Error al crear el perfil: $e');
    }
  }

  Future<void> addHistoricalDataToFirestore(
      String field, String historicalKey, String dato1, String dato2) async {
    try {
      String correo = initializeEmail();
      var collection = FirebaseFirestore.instance
          .collection('users'); // Instancia de Firestore
      var querySnapshot =
          await collection.where('Correo', isEqualTo: correo).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Si existe un documento con el correo proporcionado
        var document =
            querySnapshot.docs.first; // Primer documento que coincide

        // Obtener la fecha y hora actual en formato deseado
        String currentDateTime =
            DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

        // Crear un nuevo histórico con los datos
        Map<String, dynamic> newHistorical = {
          'dato1': dato1,
          'dato2': dato2,
          'fecha': currentDateTime,
        };

        // Leer el documento actual para obtener el campo existente
        var docSnapshot = await collection.doc(document.id).get();
        Map<String, dynamic> data = docSnapshot.data() ?? {};

        // Obtener el mapa existente o inicializar uno vacío si no existe
        Map<String, dynamic> existingMap =
            data[field] as Map<String, dynamic>? ?? {};

        // Obtener la lista de históricos existentes bajo la clave especificada o inicializar una lista vacía si no existe
        List<dynamic> existingHistoriesDynamic =
            existingMap[historicalKey] as List<dynamic>? ?? [];

        // Convertir la lista dinámica a una lista de mapas
        List<Map<String, dynamic>> existingHistories = existingHistoriesDynamic
            .map((e) => e as Map<String, dynamic>)
            .toList();

        // Agregar el nuevo histórico a la lista existente
        existingHistories.add(newHistorical);

        // Actualizar el mapa con la lista de históricos modificada
        existingMap[historicalKey] = existingHistories;

        // Actualizar el documento con el mapa modificado
        await collection.doc(document.id).update({
          field:
              existingMap, // Actualizamos el campo con el mapa que ahora incluye el nuevo histórico
        });

        print('Datos históricos añadidos exitosamente');
      } else {
        print('No se encontró un usuario con el correo proporcionado');
      }
    } catch (e) {
      print('Error al actualizar el campo $field: $e');
    }
  }

  /*
  Future<String?> getApodoByCorreo(String correo) async {
    try {
      var collection = _firestore.collection('users');
      var querySnapshot = await collection.where('Correo', isEqualTo: correo).get();
      if (querySnapshot.docs.isNotEmpty) {
        var document = querySnapshot.docs.first;
        var apodo = document.get('Apodo');

        return apodo as String?;
      } else {
        print('No se encontró un usuario con el correo proporcionado');
        return null;
      }
    } catch (e) {
      print('Error al obtener el apodo: $e');
      return null;
    }
  }*/

  Future<String?> getDataByCorreo(String correo, String data) async {
    try {
      var collection = _firestore.collection('users');
      var querySnapshot =
          await collection.where('Correo', isEqualTo: correo).get();
      if (querySnapshot.docs.isNotEmpty) {
        var document = querySnapshot.docs.first;
        var aux = document.get(data);

        return aux as String?;
      } else {
        print('No se encontró un usuario con el correo proporcionado');
        return null;
      }
    } catch (e) {
      print('Error al obtener $data : $e');
      return null;
    }
  }

  // Método para obtener la fecha de nacimiento por correo
  Future<DateTime?> getFechaNacimientoByCorreo(String email) async {
    try {
      var collection = _firestore.collection('users');
      var querySnapshot =
          await collection.where('Correo', isEqualTo: email).get();
      if (querySnapshot.docs.isNotEmpty) {
        var document = querySnapshot.docs.first;
        var fechaDeNacimientoData = document.get('Fecha de nacimiento');

        // Depurar para ver qué se está obteniendo
        print("Dato de 'Fecha de nacimiento': $fechaDeNacimientoData");

        // Verificar si es un Timestamp
        if (fechaDeNacimientoData is Timestamp) {
          return fechaDeNacimientoData.toDate(); // Convertir a DateTime
        } else {
          print(
              "El campo 'Fecha de nacimiento' no es un Timestamp o está vacío.");
          return null;
        }
      }
    } catch (e) {
      print("Error al obtener la fecha de nacimiento: $e");
      return null; // Retornar null en caso de error
    }
    return null;
  }

  Future<Map<String, dynamic>?> getTestByCorreo(String email) async {
    try {
      var collection = _firestore.collection('users');
      var querySnapshot =
          await collection.where('Correo', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        var document = querySnapshot.docs.first;
        var testData = document.get('test'); // Obtener el campo 'test'

        // Depurar para ver qué se está obteniendo
        print("Dato de 'test': $testData");

        // Verificar si es un Map
        if (testData is Map<String, dynamic>) {
          return testData; // Retornar el mapa de tests
        } else {
          print("El campo 'test' no es un mapa o está vacío.");
          return null;
        }
      }
    } catch (e) {
      print("Error al obtener el test: $e");
      return null; // Retornar null en caso de error
    }
    return null;
  }

  String initializeEmail() {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.email ?? '';
  }

  // Método para actualizar los datos del usuario en Firestore usando una consulta
  Future<void> updateData(String email, Map<String, dynamic> data) async {
    try {
      // Obtén la colección de usuarios
      var collection = _firestore.collection('users');

      // Realiza una consulta para obtener el documento que coincide con el correo electrónico
      var querySnapshot =
          await collection.where('Correo', isEqualTo: email).get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception(
            'No se encontró el usuario con el correo proporcionado');
      }

      // Supongamos que solo hay un documento que coincide
      var document = querySnapshot.docs.first;

      // Actualiza los datos en Firestore
      await document.reference.update(data);

      print('Datos actualizados con éxito');
    } catch (e) {
      print('Error al actualizar los datos: $e');
      rethrow; // Opcional: relanzar la excepción para manejarla en la interfaz de usuario
    }
  }
}
