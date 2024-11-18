import 'package:flutter/material.dart';

import '../../widgets/menu.dart';

class TechniquelsListPage extends StatelessWidget {
  const TechniquelsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3F4660),
        foregroundColor: Colors.white,
        title: const Text("Lista de Técnicas de relajación"),
      ),
      drawer: SidebarMenu(),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            Container(
              decoration: CardDecoration.decoration,
              child: ListTile(
                leading: const Icon(
                  Icons.air,
                  color: Colors.black87,
                  size: 40,
                ),
                textColor: Colors.black87,
                title: const Text(
                  "Respiración 4-7-8",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                    "Esta técnica es efectiva para reducir el estrés, la ansiedad y promover el sueño."),
                onTap: () {
                  Navigator.popAndPushNamed(context, '/breathing_4_7_8');
                },
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              decoration: CardDecoration.decoration,
              child: ListTile(
                leading: const Icon(
                  Icons.connect_without_contact,
                  color: Colors.black87,
                  size: 40,
                ),
                textColor: Colors.black87,
                title: const Text(
                  "Meditación de atención plena",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                    "Mejora la concentración, reduce el estrés y la ansiedad, y aumenta el bienestar general."),
                onTap: () {
                  Navigator.popAndPushNamed(
                      context, '/planeAtentionMeditation');
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Clase para encapsular la decoración del Container
class CardDecoration {
  static BoxDecoration get decoration => BoxDecoration(
        color: Colors.white, // Fondo blanco
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey), // Borde gris
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Color de la sombra
            spreadRadius: 2, // Extensión de la sombra
            blurRadius: 10, // Radio de desenfoque de la sombra
            offset: const Offset(0, 4), // Desplazamiento de la sombra (x, y)
          ),
        ],
      );
}
