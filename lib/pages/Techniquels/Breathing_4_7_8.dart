import 'package:flutter/material.dart';
import 'dart:async';

import 'package:mental_health/widgets/menu.dart';

class Breathing_4_7_8 extends StatefulWidget {
  @override
  _Breathing_4_7_8 createState() => _Breathing_4_7_8();
}

class _Breathing_4_7_8 extends State<Breathing_4_7_8> {
  bool buttonPress = false;

  String _text = "Inhala";
  Timer? _timer;
  int _start = 0;
  int aux = 0;

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        _start++;
      });

      if (_start > 4 && aux == 1) {
        _stopTimer();
        aux = 2;
        _text = "Mantener";
        _start = 0;
        _startTimer();
      } else if (_start > 7 && aux == 2) {
        _stopTimer();
        aux = 3;
        _text = "Exhala";
        _start = 0;
        _startTimer();
      } else if (_start > 8 && aux == 3) {
        _stopTimer();
        aux = 1;
        _start = 0;
        _text = "Inhala";
        buttonPress = false;
      } else {
        _text = _start.toString();
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
    _stopTimer();
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
        backgroundColor: Color(0xFF3F4660),
        foregroundColor: Colors.white,
        title: Text("Respiración 4 7 8"),
      ),
      drawer: SidebarMenu(),
      body: Container(
        //height: MediaQuery.of(context).size.height*0.7,
        decoration: BoxDecoration(),
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
                          "Siéntate o acuéstate en una posición cómoda.",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Inhala por la nariz durante 4 segundos, mantén la respiración durante 7 segundos y exhala lentamente por la boca durante 8 segundos. Repite este ciclo de 4 a 8 veces.",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                            child: Center(
                          child: Text(
                            "$_text",
                            style: TextStyle(
                              fontSize: 70,
                              color: Colors.white,
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!buttonPress) {
                          _text = "Inhala";
                          aux = 1;
                          _startTimer();
                        }

                        buttonPress = true;
                      },
                      child: Text(
                        'COMENZAR',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
