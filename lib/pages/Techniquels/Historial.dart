import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mental_health/services/profile.dart';

class TestHistoryPage extends StatefulWidget {
  @override
  _TestHistoryPageState createState() => _TestHistoryPageState();
}

class _TestHistoryPageState extends State<TestHistoryPage> {
  List<Map<String, dynamic>> _testHistory = [];
  Profile _profile = Profile();
  String? _email;

  @override
  void initState() {
    super.initState();
    _fetchTestHistory();
  }

  Future<void> _fetchTestHistory() async {
    try {
      _email = _profile.initializeEmail();
      _profile.getTestByCorreo(_email!);
      setState(() {
        print(_email);
        print(_testHistory);
      });
    } catch (e) {
      print("Error fetching test history: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3F4660),
        title: Text("Historial de Tests"),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _profile.getTestByCorreo(_email!), // Llamada al método para obtener los datos
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error al obtener datos", style: TextStyle(color: Colors.white)));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("No hay historial disponible", style: TextStyle(color: Colors.white)));
          } else {
            var testData = snapshot.data!;
            var historial = testData['historial'] as List<dynamic>?; // Obtener la lista de historial

            if (historial == null || historial.isEmpty) {
              return Center(child: Text("No hay datos de historial disponibles", style: TextStyle(color: Colors.white)));
            }

            return ListView.builder(
              itemCount: historial.length,
              itemBuilder: (context, index) {
                var historialItem = historial[index];

                // Verifica si cada item dentro de la lista es un Map
                if (historialItem is Map<String, dynamic>) {
                  return ListTile(
                    title: Text("Historial ${index + 1}", style: TextStyle(color: Colors.white)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Nombre de test: ${historialItem['dato1']}", style: TextStyle(color: Colors.white)),
                        Text("Resultado: ${historialItem['dato2']}", style: TextStyle(color: Colors.white)),
                        Text("Fecha: ${historialItem['fecha']}", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  );
                } else {
                  return ListTile(
                    title: Text("Historial ${index + 1}", style: TextStyle(color: Colors.white)),
                    subtitle: Text("Dato no disponible o formato incorrecto", style: TextStyle(color: Colors.white)),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }

}

// Página de detalles del historial
class HistoryDetailPage extends StatelessWidget {
  final Map<String, dynamic> historyItem;

  HistoryDetailPage({required this.historyItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3F4660),
        title: Text("Detalles del Test"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Detalles del Test",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text("Fecha: ${historyItem['fecha']}"),
            Text("Nombre del test: ${historyItem['dato1']}"),
            Text("Resultado: ${historyItem['dato2']}"),
            // Muestra más detalles según los datos almacenados
          ],
        ),
      ),
    );
  }
}
