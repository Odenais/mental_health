import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mental_health/services/profile.dart';
import 'package:mental_health/widgets/menu.dart';

class TestHistoryPage extends StatefulWidget {
  const TestHistoryPage({super.key});

  @override
  _TestHistoryPageState createState() => _TestHistoryPageState();
}

class _TestHistoryPageState extends State<TestHistoryPage> {
  final List<Map<String, dynamic>> _testHistory = [];
  final Profile _profile = Profile();
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
        backgroundColor: const Color(0xFF3F4660),
        foregroundColor: Colors.white,
        title: const Text("Historial de Tests"),
      ),
      drawer: SidebarMenu(),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _profile.getTestByCorreo(
            _email!), // Llamada al método para obtener los datos
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
                child: Text("Error al obtener datos",
                    style: TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
                child: Text("No hay historial disponible",
                    style: TextStyle(color: Colors.grey)));
          } else {
            var testData = snapshot.data!;
            var historial = testData['historial']
                as List<dynamic>?; // Obtener la lista de historial

            if (historial == null || historial.isEmpty) {
              return const Center(
                  child: Text("No hay datos de historial disponibles",
                      style: TextStyle(color: Colors.grey)));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: historial.length,
              itemBuilder: (context, index) {
                var historialItem = historial[index];

                // Verifica si cada item dentro de la lista es un Map
                if (historialItem is Map<String, dynamic>) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    child: ListTile(
                      leading:
                          const Icon(Icons.history, color: Colors.blueAccent),
                      title: Text(
                        "Test ${index + 1}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text("Nombre del test: ${historialItem['dato1']}"),
                          Text("Resultado: ${historialItem['dato2']}"),
                          Text("Fecha: ${historialItem['fecha']}"),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          color: Colors.grey),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                HistoryDetailPage(historyItem: historialItem),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return ListTile(
                    title: Text("Historial ${index + 1}",
                        style: const TextStyle(color: Colors.white)),
                    subtitle: const Text(
                        "Dato no disponible o formato incorrecto",
                        style: TextStyle(color: Colors.white)),
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

  const HistoryDetailPage({super.key, required this.historyItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3F4660),
        iconTheme: const IconThemeData(
            color: Colors.white), // Color de la flecha de retorno
        title: const Text(
          "Detalles del Test",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SizedBox(
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
                    const Text(
                      "Detalles del Test",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
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
