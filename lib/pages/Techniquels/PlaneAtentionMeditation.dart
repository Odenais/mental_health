import 'package:flutter/material.dart';
import '../../widgets/menu.dart';

class planeAtentionMeditation extends StatefulWidget {
  @override
  _planeAtentionMeditation createState() => _planeAtentionMeditation();
}

class _planeAtentionMeditation extends State<planeAtentionMeditation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3F4660),
        foregroundColor: Colors.white,
        title: Text("Meditación de atención plena"),
      ),
      drawer: SidebarMenu(),
      body: Container(
        //height: MediaQuery.of(context).size.height*0.7,
        decoration: BoxDecoration(
          color: Color(0xFF3F4660),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xFF3F4660),
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Dedica unos minutos al día para sentarte en silencio y concentrarte en tu respiración, los sonidos a tu alrededor, o las sensaciones corporales. Observa tus pensamientos sin juzgarlos y regresa tu atención al presente cada vez que te distraigas.",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: Center(),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
