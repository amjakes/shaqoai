import 'package:flutter/material.dart';

import '../app/colors.dart';
import '../widgets/ui.dart';

class AgentChatScreen extends StatelessWidget {
  const AgentChatScreen({required this.agent, required this.color, super.key});
  final String agent;
  final Color color;

  @override
  Widget build(BuildContext context) => DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            title: Text(agent,
                style: const TextStyle(fontWeight: FontWeight.w800)),
            bottom: const TabBar(tabs: [
              Tab(text: 'Chat'),
              Tab(text: 'Activity'),
              Tab(text: 'Context')
            ])),
        body: TabBarView(children: [
          _Chat(agent: agent),
          const Padding(padding: EdgeInsets.all(20), child: ActivityFeed()),
          ListView(padding: const EdgeInsets.all(20), children: [
            const TitleRow('Agent permissions', ''),
            Glass(
                child: const Column(children: [
              ListTile(
                  leading: Icon(Icons.check_circle_outline, color: appGreen),
                  title: Text('Read business data'),
                  subtitle: Text('CRM, calendar, and selected documents')),
              Divider(),
              ListTile(
                  leading: Icon(Icons.verified_user_outlined, color: appAmber),
                  title: Text('Human approval required'),
                  subtitle: Text('Payments and external commitments'))
            ]))
          ])
        ]),
      ));
}

class _Chat extends StatelessWidget {
  const _Chat({required this.agent});
  final String agent;
  @override
  Widget build(BuildContext context) => Column(children: [
        const Expanded(child: _Conversation()),
        SafeArea(
            top: false,
            child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(children: [
                  Expanded(
                    child: TextField(
                        decoration: InputDecoration(
                            hintText: 'Message $agent',
                            filled: true,
                            fillColor: appSurface,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none))),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_upward_rounded))
                ]))),
      ]);
}

class _Conversation extends StatelessWidget {
  const _Conversation();
  @override
  Widget build(BuildContext context) =>
      ListView(padding: const EdgeInsets.all(20), children: const [
        Align(
            alignment: Alignment.centerLeft,
            child: _Bubble(
                'I’ve reviewed your priority queue and identified 3 actions that need attention.',
                true)),
        SizedBox(height: 12),
        Align(
            alignment: Alignment.centerRight,
            child: _Bubble('Show me the highest value item.', false)),
        SizedBox(height: 12),
        Align(
            alignment: Alignment.centerLeft,
            child: _Bubble(
                'A KES 84,500 supplier payout is waiting for human approval. I have verified the invoice match.',
                true)),
      ]);
}

class _Bubble extends StatelessWidget {
  const _Bubble(this.text, this.agent);
  final String text;
  final bool agent;
  @override
  Widget build(BuildContext context) => Container(
      constraints: const BoxConstraints(maxWidth: 310),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
          color: agent ? appSurface : appCyan.withValues(alpha: .18),
          borderRadius: BorderRadius.circular(15)),
      child: Text(text, style: const TextStyle(fontSize: 13, height: 1.4)));
}
