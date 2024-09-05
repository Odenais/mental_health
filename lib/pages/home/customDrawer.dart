import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rive/rive.dart' as rive;

class CustomDrawer extends StatelessWidget {
  static late rive.StateMachineController? stateMachineController;
  static rive.SMIInput<bool>? clickChange;

  static void click(value){
    clickChange?.change(value);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Contenido principal de la pantalla
        Container(
          color: Colors.white,
        ),
        // Drawer personalizado que llega hasta la barra de estado
        Positioned(
          top: 0, // Llega hasta la barra de estado
          left: 0,
          right: 0,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8, // Ajusta el ancho
            height: MediaQuery.of(context)
                .size
                .height, // Ocupa todo el alto disponible
            color: Colors.white,
            child: Column(
              children: [
                // Header con la animación Rive
                SizedBox(
                  height: 200, // Altura del header
                  child: rive.RiveAnimation.asset(
                    'assets/menu_header.riv',
                    stateMachines: const ["Button Animation"],
                    fit: BoxFit.cover, // Ocupa todo el espacio
                    alignment: Alignment.center,
                    onInit: (artBoard) {
                      stateMachineController =
                          rive.StateMachineController.fromArtboard(
                            artBoard,
                            "Button Animation",
                          );
                      if (stateMachineController == null) return;
                      artBoard.addController(stateMachineController!);

                      clickChange = stateMachineController?.findInput("Click");
                    },
                  ),
                ),
                // Opciones del menú
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
