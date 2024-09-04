import 'dart:async';
import 'package:flutter/material.dart';

import '../../widgets/menu.dart';


class TechniquelsListPage extends StatelessWidget{
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

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
        ],
      ),
    );
  }
}



class Breathing_4_7_8 extends StatefulWidget {
  @override
  _Breathing_4_7_8 createState() => _Breathing_4_7_8();
}

class _Breathing_4_7_8 extends State<Breathing_4_7_8> {
  
  Timer? _timer;
  int _start = 0;

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        _start++;
      });
      if (_start >= 4) {
        _stopTimer();
      }
    });
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Container(
        //height: MediaQuery.of(context).size.height*0.7,
        decoration: BoxDecoration(
          color: Colors.deepPurple[200],
        ),
        child: Column(
          
          children: [
            Row(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height*0.7,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      children: [
                        Text("NOTA:"),
                        SizedBox(height: 10,),
                        Text("Siéntate o acuéstate en una posición cómoda."),
                        Text("Inhala por la nariz durante 4 segundos, mantén la respiración durante 7 segundos y exhala lentamente por la boca durante 8 segundos. Repite este ciclo de 4 a 8 veces."),
                        SizedBox(height: 10,),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.blue,
                  child: ElevatedButton(
                    onPressed: (){
                      _startTimer();
                    },
                    child: Text(
                      'Tiempo: $_start segundos',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                )
              ],
            )
            
          ],
        ),
      ),
    );
  }
}

