import 'package:flutter/material.dart';

import '../app/colors.dart';
import '../data/agent_catalog.dart';
import '../models/agent_profile.dart';
import '../widgets/ui.dart';
import 'agent_chat_screen.dart';

void showWhatsAppAgents(BuildContext context) => showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _WhatsAppAgentsSheet(),
    );

class _WhatsAppAgentsSheet extends StatelessWidget {
  const _WhatsAppAgentsSheet();

  @override
  Widget build(BuildContext context) => SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * .8,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
              child: Row(children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                      color: Color(0xFF25D366), shape: BoxShape.circle),
                  child: const Icon(Icons.chat_rounded, color: appBackground),
                ),
                const SizedBox(width: 12),
                const Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text('ShaqoAI on WhatsApp',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 17)),
                      Text('Choose an agent to start a conversation',
                          style: TextStyle(color: appMuted, fontSize: 11)),
                    ])),
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded)),
              ]),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: agentCatalog.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) => _WhatsAppAgentTile(
                    agent: agentCatalog[index]),
              ),
            ),
          ]),
        ),
      );
}

class _WhatsAppAgentTile extends StatelessWidget {
  const _WhatsAppAgentTile({required this.agent});
  final AgentProfile agent;

  @override
  Widget build(BuildContext context) => ListTile(
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AgentChatScreen(
                      agent: '${agent.name} · WhatsApp', color: appGreen)));
        },
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF25D366).withValues(alpha: .16),
          child: Icon(agent.icon, color: const Color(0xFF25D366)),
        ),
        title: Text(agent.name,
            style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(agent.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: appMuted, fontSize: 11)),
        trailing: const Icon(Icons.chevron_right_rounded, color: appMuted),
      );
}
