import 'package:flutter/material.dart';

class TestListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tests"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Percived Stress Scale (PSS)"),
            subtitle: Text("Mide tu nivel de estrés percibido en el último mes."),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PercivedStressScaleDetailsPage()),
              );
            },
          ),
          // Puedes agregar más tests aquí
        ],
      ),
    );
  }
}

class PercivedStressScaleDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Percived Stress Scale (PSS)"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Descripción",
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "El Percived Stress Scale (PSS) es un test que evalúa tu percepción del estrés en situaciones cotidianas durante el último mes. Se compone de 14 preguntas que examinan la frecuencia con la que te has sentido sobrepasado, nervioso o en control de tu vida.",
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20),
            Text(
              "Resultados",
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Los resultados del test se basan en la suma de las puntuaciones de las 14 preguntas. Cada opción va de 0 (Nunca) a 4 (Muy a menudo), por lo que la puntuación máxima posible es de 56. Aquí te explicamos cómo interpretar tu resultado:",
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 10),
            Text(
              "• 0-13: Bajo nivel de estrés\n"
                  "• 14-26: Nivel moderado de estrés\n"
                  "• 27-40: Alto nivel de estrés\n"
                  "• 41-56: Estrés severo",
              style: TextStyle(fontSize: 16.0, color: Colors.black87),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popAndPushNamed(context, '/percivedStressScale');
                },
                child: Text("Iniciar Test"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}