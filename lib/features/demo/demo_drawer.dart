import 'package:cleaning_service_app/features/auth/screens/selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DemoDrawer extends StatelessWidget {
  const DemoDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Drawer Header',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            // onTap: () => Get.to(() => ChoosePlanSection()),
            leading: Icon(Icons.message),
            title: Text('Messages'),
          ),
          ListTile(
            onTap: () => Get.to(() => SelectionScreen(email: "test@mail.com")),
            leading: Icon(Icons.workspace_premium),
            title: Text('Choose Subscription'),
          ),

          ListTile(leading: Icon(Icons.account_circle), title: Text('Profile')),
          ListTile(leading: Icon(Icons.settings), title: Text('Settings')),
        ],
      ),
    );
  }
}
