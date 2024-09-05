
import 'package:flutter/material.dart';

import '../../widgets/menu.dart';


class TechniquelsListPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Técnicas de relajación"),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushNamed(
                  context, '/home'); // Navegar a la página de inicio
            },
          ),
        ],
      ),
      drawer: SidebarMenu(),
      body: ListView(
        children: [
          ListTile(
            title: Text("Respiración 4-7-8"),
            subtitle: Text("Esta técnica es efectiva para reducir el estrés, la ansiedad y promover el sueño."),
            onTap: () {
              
              Navigator.popAndPushNamed(context, '/breathing_4_7_8');
            },
          ),
          ListTile(
            title: Text("Meditación de atención plena"),
            subtitle: Text("Mejora la concentración, reduce el estrés y la ansiedad, y aumenta el bienestar general."),
            onTap: () {
              
              Navigator.popAndPushNamed(context, '/planeAtentionMeditation');
            },
          ),
        ],
      ),
    );
  }
}





