import 'package:flutter/material.dart';

class PercivedStressScalePage extends StatefulWidget {
  @override
  _PercivedStressScalePageState createState() => _PercivedStressScalePageState();
}

class _PercivedStressScalePageState extends State<PercivedStressScalePage> {
  int _currentQuestionIndex = 0;

  final List<String> _questions = [
    "En el último mes, ¿con qué frecuencia ha estado afectado por algo que ha ocurrido inesperadamente?",
    "En el último mes, ¿con qué frecuencia se ha sentido incapaz de controlar las cosas importantes en su vida?",
    "En el último mes, ¿con qué frecuencia se ha sentido nervioso o estresado?",
    "En el último mes, ¿con qué frecuencia ha manejado con éxito los pequeños problemas irritantes de la vida?",
    "En el último mes, ¿con qué frecuencia ha afrontado efectivamente los cambios importantes en su vida?",
    "En el último mes, ¿con qué frecuencia ha estado seguro sobre su capacidad para manejar sus problemas personales?",
    "En el último mes, ¿con qué frecuencia ha sentido que las cosas le van bien?",
    "En el último mes, ¿con qué frecuencia ha sentido que no podía afrontar todas las cosas que tenía que hacer?",
    "En el último mes, ¿con qué frecuencia ha podido controlar las dificultades de su vida?",
    "En el último mes, ¿con qué frecuencia se ha sentido que tenía todo bajo control?",
    "En el último mes, ¿con qué frecuencia ha estado enfadado porque las cosas que le han ocurrido estaban fuera de su control?",
    "En el último mes, ¿con qué frecuencia ha pensado sobre las cosas que le quedan por hacer?",
    "En el último mes, ¿con qué frecuencia ha podido controlar la forma de pasar el tiempo?",
    "En el último mes, ¿con qué frecuencia ha sentido que las dificultades se acumulan tanto que no puede superarlas?",
  ];

  final List<String> _options = ["Nunca", "Casi nunca", "De vez en cuando", "A menudo", "Muy a menudo"];

  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CompletedPage()),
        );
      }
    });
  }

  void _previousQuestion() {
    setState(() {
      if (_currentQuestionIndex > 0) {
        _currentQuestionIndex--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test de Estrés"),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushNamed(context, '/home'); // Navegar a la página de inicio
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Pregunta ${_currentQuestionIndex + 1} de ${_questions.length}",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    _questions[_currentQuestionIndex],
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 20),
                  for (int i = 0; i < _options.length; i++)
                    ElevatedButton(
                      onPressed: _nextQuestion,
                      child: Text(_options[i]),
                    ),
                ],
              ),
            ),
          ),
          if (_currentQuestionIndex > 0)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _previousQuestion,
                child: Text("<- Regresar a la pregunta anterior <-"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CompletedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Completado"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "¡Has completado el test!",
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Volver al inicio"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home'); // Navegar a la página de inicio
              },
              child: Text("Ir a /home"),
            ),
          ],
        ),
      ),
    );
  }
}
