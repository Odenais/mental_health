import 'package:flutter/material.dart';
import 'package:mental_health/pages/home/customDrawer.dart';

import 'package:rive/rive.dart' as rive;

class SidebarMenu extends StatelessWidget {
  late rive.StateMachineController? stateMachineController;

  rive.SMIInput<bool>? clickChange;
  @override
  Widget build(BuildContext context) {
    return Drawer(
<<<<<<< HEAD
      child: CustomDrawer()
=======
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF3F4660),
            ),
            child: Text(
              'Menú',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
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
            title: Text('Lista de test'),
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
>>>>>>> 3e65d57ca6205850707a1f03fa0e4d9e0e065e91
    );
  }
}
