import 'package:flutter/material.dart';
import 'package:mental_health/pages/home/customDrawer.dart';

import 'package:rive/rive.dart' as rive;

class SidebarMenu extends StatelessWidget {
  late rive.StateMachineController? stateMachineController;

  rive.SMIInput<bool>? clickChange;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: CustomDrawer()
    );
  }
}
