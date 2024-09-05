import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SidebarMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
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
    );
  }
}
