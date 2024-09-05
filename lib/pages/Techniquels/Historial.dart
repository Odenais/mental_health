import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mental_health/services/profile.dart';
import 'package:mental_health/widgets/menu.dart';

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
        foregroundColor: Colors.white,
        title: Text("Historial de Tests"),
      ),
      drawer: SidebarMenu(),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _profile.getTestByCorreo(_email!), // Llamada al método para obtener los datos
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error al obtener datos", style: TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("No hay historial disponible", style: TextStyle(color: Colors.grey)));
          } else {
            var testData = snapshot.data!;
            var historial = testData['historial'] as List<dynamic>?; // Obtener la lista de historial

            if (historial == null || historial.isEmpty) {
              return Center(child: Text("No hay datos de historial disponibles", style: TextStyle(color: Colors.grey)));
            }

            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: historial.length,
              itemBuilder: (context, index) {
                var historialItem = historial[index];

                // Verifica si cada item dentro de la lista es un Map
                if (historialItem is Map<String, dynamic>) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    child: ListTile(
                      leading: Icon(Icons.history, color: Colors.blueAccent),
                      title: Text(
                        "Test ${index + 1}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Text("Nombre del test: ${historialItem['dato1']}"),
                          Text("Resultado: ${historialItem['dato2']}"),
                          Text("Fecha: ${historialItem['fecha']}"),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HistoryDetailPage(historyItem: historialItem),
                          ),
                        );
                      },
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
        iconTheme: IconThemeData(color: Colors.white), // Color de la flecha de retorno
        title: Text("Detalles del Test", style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            width: 300, // Aquí defines el ancho del Card
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Detalles del Test",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text("Fecha: ${historyItem['fecha']}"),
                    Text("Nombre del test: ${historyItem['dato1']}"),
                    Text("Resultado: ${historyItem['dato2']}"),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
