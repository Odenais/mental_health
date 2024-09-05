import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  StateMachineController? _stateMachineController;
  SMIBool? _dayInput;

  @override
  void initState() {
    super.initState();
  }

  void _updateStateBasedOnTime() {
    final now = DateTime.now();
    final hour = now.hour;

    // Set dayInput based on the hour
    if (hour > 7) {
      _dayInput?.change(true);
    } else{
      _dayInput?.change(false);
    }
  }

  void _onRiveInit(Artboard artboard) {
    try {
      final controller = StateMachineController.fromArtboard(artboard, 'Button_Animation');
      if (controller != null) {
        artboard.addController(controller);
        _stateMachineController = controller;
        _dayInput = controller.findInput<bool>('Day') as SMIBool?;
        _updateStateBasedOnTime();
      } else {
        print('StateMachineController no inicializado');
      }
    } catch (e) {
      print('Error al inicializar Rive: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.white,
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: RiveAnimation.asset(
                    'assets/menu_header.riv',
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    onInit: _onRiveInit,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text('Perfil'),
                  onTap: () {
                    Navigator.popAndPushNamed(context, '/profileShow');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.chat),
                  title: Text('Chat Bot'),
                  onTap: () {
                    Navigator.popAndPushNamed(context, '/chat');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.list),
                  title: Text('Lista de tests'),
                  onTap: () {
                    Navigator.popAndPushNamed(context, '/listTests');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.list_alt),
                  title: Text('Lista de técnicas'),
                  onTap: () {
                    Navigator.popAndPushNamed(context, '/listTechniquels');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Cerrar Sesión'),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.popAndPushNamed(context, '/login');
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
