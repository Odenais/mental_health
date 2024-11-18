import 'package:flutter/material.dart';

import '../../widgets/menu.dart';

class TestListPage extends StatelessWidget {
  const TestListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3F4660),
        foregroundColor: Colors.white,
        title: const Text("Lista de Tests"),
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
                  Icons.text_snippet_outlined,
                  color: Colors.black87,
                  size: 40,
                ),
                textColor: Colors.black87,
                title: const Text(
                  "Percived Stress Scale (PSS)",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                    "Mide tu nivel de estrés percibido en el último mes."),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PercivedStressScaleDetailsPage()),
                  );
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
                  Icons.sentiment_dissatisfied,
                  color: Colors.black87,
                  size: 40,
                ),
                textColor: Colors.black87,
                title: const Text(
                  "Maslach Burnout Inventory (MBI)",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text("Evalúa el nivel de burnout académico."),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BurnoutInventoryDetailsPage()),
                  );
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
                  Icons.sentiment_very_dissatisfied_sharp,
                  color: Colors.black87,
                  size: 40,
                ),
                textColor: Colors.black87,
                title: const Text(
                  "Test de Ansiedad Generalizada (GAD-7)",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                subtitle:
                    const Text("Evalúa los síntomas de ansiedad generalizada."),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AnxietyTestDetailsPage()),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PercivedStressScaleDetailsPage extends StatelessWidget {
  const PercivedStressScaleDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3F4660),
        foregroundColor: Colors.white,
        title: const Text("Percived Stress Scale (PSS)"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Descripción",
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "El Percived Stress Scale (PSS) es un test que evalúa tu percepción del estrés en situaciones cotidianas durante el último mes. Se compone de 14 preguntas que examinan la frecuencia con la que te has sentido sobrepasado, nervioso o en control de tu vida.",
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Resultados",
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Los resultados del test se basan en la suma de las puntuaciones de las 14 preguntas. Cada opción va de 0 (Nunca) a 4 (Muy a menudo), por lo que la puntuación máxima posible es de 56. Aquí te explicamos cómo interpretar tu resultado:",
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                  SizedBox(height: 30),
                  Center(
                    //width: MediaQuery.of(context).size.width,
                    child: Text(
                      "• 0-13: Bajo nivel de estrés\n"
                      "• 14-26: Nivel moderado de estrés\n"
                      "• 27-40: Alto nivel de estrés\n"
                      "• 41-56: Estrés severo",
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ElevatedButton(
                      style: const ButtonStyle(),
                      onPressed: () {
                        Navigator.popAndPushNamed(
                            context, '/percivedStressScale');
                      },
                      child: const Text("Iniciar Test"),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BurnoutInventoryDetailsPage extends StatelessWidget {
  const BurnoutInventoryDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3F4660),
        foregroundColor: Colors.white,
        title: const Text("Maslach Burnout Inventory (MBI)"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Descripción",
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text(
              "El Maslach Burnout Inventory es un test que evalúa el nivel de agotamiento emocional, despersonalización y baja realización personal, comúnmente asociado al burnout académico.",
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              "Resultados",
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text(
              "Los resultados del test se interpretan según tres dimensiones: agotamiento emocional, despersonalización y realización personal. Cada dimensión tiene su propia escala de puntuación.",
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  //Navigator.popAndPushNamed(context, '/burnoutInventory');
                },
                child: const Text("Iniciar Test"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnxietyTestDetailsPage extends StatelessWidget {
  const AnxietyTestDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3F4660),
        foregroundColor: Colors.white,
        title: const Text("Test de Ansiedad Generalizada (GAD-7)"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Descripción",
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text(
              "El Test de Ansiedad Generalizada (GAD-7) es una prueba breve que mide los síntomas de ansiedad. Contiene 7 preguntas que exploran los sentimientos de nerviosismo, preocupación excesiva y problemas para relajarse.",
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              "Resultados",
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text(
              "Los resultados del test se interpretan según la suma de las puntuaciones de las 7 preguntas. Aquí te explicamos cómo interpretar tu resultado:",
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text(
              "• 0-4: Ansiedad mínima\n"
              "• 5-9: Ansiedad leve\n"
              "• 10-14: Ansiedad moderada\n"
              "• 15-21: Ansiedad severa",
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  //Navigator.popAndPushNamed(context, '/anxietyTest');
                },
                child: const Text("Iniciar Test"),
              ),
            ),
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
