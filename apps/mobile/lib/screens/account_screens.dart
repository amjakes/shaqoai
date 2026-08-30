import 'package:flutter/material.dart';

import '../app/colors.dart';
import '../widgets/ui.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: const Padding(padding: EdgeInsets.all(20), child: ActivityFeed()));
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Workspace profile')),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        const Center(
            child: CircleAvatar(
                radius: 36,
                backgroundColor: Color(0xFF253861),
                child: Text('JM', style: TextStyle(fontSize: 20)))),
        const SizedBox(height: 12),
        const Center(
            child: Text('James Murila',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800))),
        const Center(
            child: Text('Workspace owner', style: TextStyle(color: appMuted))),
        const SizedBox(height: 26),
        Glass(
            child: const Column(children: [
          ListTile(
              leading: Icon(Icons.business_outlined),
              title: Text('ShaqoAI Workspace'),
              trailing: Icon(Icons.chevron_right)),
          Divider(),
          ListTile(
              leading: Icon(Icons.security_outlined),
              title: Text('Security & approvals'),
              trailing: Icon(Icons.chevron_right)),
          Divider(),
          ListTile(
              leading: Icon(Icons.tune_rounded),
              title: Text('Agent preferences'),
              trailing: Icon(Icons.chevron_right))
        ])),
      ]));
}
