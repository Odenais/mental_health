import 'package:flutter/material.dart';
import 'dart:async';

import 'package:mental_health/widgets/menu.dart';
import 'package:rive/rive.dart' as rive;
import 'package:rive/rive.dart';

class Breathing_4_7_8 extends StatefulWidget {
  const Breathing_4_7_8({super.key});

  @override
  _Breathing_4_7_8 createState() => _Breathing_4_7_8();
}

class _Breathing_4_7_8 extends State<Breathing_4_7_8> {
  bool buttonPress = false;
  String _text = "Inhala";
  Timer? _timer;
  int _start = 0;
  int aux = 0;

  StateMachineController? _stateMachineController;
  late rive.SMITrigger _incio;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _start++;
      });

      if (_start == 1 && aux == 1) {
        _text = "Inhala";
      }

      if (_start > 4 && aux == 1) {
        _stopTimer();
        aux = 2;
        _text = "Mantener";
        _start = 0;
        _startTimer();
      } else if (_start == 1 && aux == 2) {
        _text = "Mantén";
      } else if (_start > 7 && aux == 2) {
        _stopTimer();
        aux = 3;
        _text = "Exhala";
        _start = 0;
        _startTimer();
      } else if (_start == 1 && aux == 3) {
        _text = "Exhala";
      } else if (_start > 8 && aux == 3) {
        _stopTimer();
        aux = 1;
        _start = 0;
        _text = "Inhala";
        setState(() {
          buttonPress = false; // Rehabilita el botón al finalizar
        });
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

  void _onRiveInit(Artboard artboard) {
    try {
      final controller =
          StateMachineController.fromArtboard(artboard, 'State Machine 1');
      if (controller != null) {
        artboard.addController(controller);
        _stateMachineController = controller;
        _incio = (controller.findInput<bool>('Iniciar') as rive.SMITrigger?)!;
      } else {
        print('StateMachineController no inicializado');
      }
    } catch (e) {
      print('Error al inicializar Rive: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3F4660),
        foregroundColor: Colors.white,
        title: const Text("Respiración 4 7 8"),
      ),
      drawer: SidebarMenu(),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width,
                    color: const Color(0xFF3F4660),
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            "Siéntate o acuéstate en una posición cómoda.",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            "Inhala por la nariz durante 4 segundos, mantén la respiración durante 7 segundos y exhala lentamente por la boca durante 8 segundos. Repite este ciclo de 4 a 8 veces.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    _text,
                                    style: const TextStyle(
                                      fontSize: 70,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 300, // Establece el ancho deseado
                                    height: 300, // Establece la altura deseada
                                    child: rive.RiveAnimation.asset(
                                      'assets/breathe.riv',
                                      fit: BoxFit.contain,
                                      onInit: _onRiveInit,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: buttonPress
                          ? null // Deshabilita el botón si el ejercicio está en curso
                          : () {
                              setState(() {
                                buttonPress =
                                    true; // Deshabilita el botón al iniciar
                              });
                              _text = "Inhala";
                              aux = 1;
                              _startTimer();
                              _delayAnimationStart(); // Inicia la animación con retraso
                            },
                      child: const Text(
                        'COMENZAR',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _delayAnimationStart() {
    // Espera 1 segundo antes de iniciar la animación
    Future.delayed(const Duration(seconds: 2), () {
      _animate(); // Inicia la animación después del retraso
    });
  }

  void _animate() {
    _incio.fire();
  }
}
