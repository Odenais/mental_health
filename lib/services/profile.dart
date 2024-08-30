import "package:cloud_firestore/cloud_firestore.dart";

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
        'Fecha de nacimiento': Timestamp.fromDate(fechaNacimiento), // Conversión a Timestamp
      });
      print('Usuario creado correctamente');
    } catch (e) {
      print('Error al crear el perfil: $e');
    }
  }

  Future<String?> getApodoByCorreo(String correo) async {
    try {
      // Obtén una referencia a la colección 'users'
      var collection = _firestore.collection('users');

      // Realiza una consulta para encontrar el documento con el correo dado
      var querySnapshot = await collection.where('Correo', isEqualTo: correo).get();

      // Verifica si se encontraron documentos
      if (querySnapshot.docs.isNotEmpty) {
        // Obtén el primer documento de la consulta
        var document = querySnapshot.docs.first;

        // Obtén el campo 'Apodo' del documento
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
  }
}
