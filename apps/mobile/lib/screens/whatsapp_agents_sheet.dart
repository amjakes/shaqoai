import 'package:flutter/material.dart';

import '../app/colors.dart';
import '../data/agent_catalog.dart';
import '../models/agent_profile.dart';
import 'agent_chat_screen.dart';

const _whatsAppGreen = Color(0xFF25D366);

void showWhatsAppAgents(BuildContext context) => showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: false,
      backgroundColor: appBackground,
      builder: (_) => const _WhatsAppAgentsSheet(),
    );

class _WhatsAppAgentsSheet extends StatefulWidget {
  const _WhatsAppAgentsSheet();

  @override
  State<_WhatsAppAgentsSheet> createState() => _WhatsAppAgentsSheetState();
}

class _WhatsAppAgentsSheetState extends State<_WhatsAppAgentsSheet> {
  String query = '';
  bool showNotice = true;

  @override
  Widget build(BuildContext context) {
    final agents = agentCatalog
        .where((agent) => '${agent.name} ${agent.title}'
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();
    return Material(
      color: appBackground,
      child: SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: Column(children: [
            _Header(onClose: () => Navigator.pop(context)),
            _SearchBar(onChanged: (value) => setState(() => query = value)),
            const _FilterRow(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  if (showNotice) _NotificationBanner(
                      onDismiss: () => setState(() => showNotice = false)),
                  const _ArchivedRow(),
                  for (final agent in agents) _WhatsAppAgentTile(agent: agent),
                  if (agents.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 48),
                      child: Center(
                        child: Text('No conversations found',
                            style: TextStyle(color: appMuted)),
                      ),
                    ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onClose});
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 12, 10),
        child: Row(children: [
          const Text('WhatsApp',
              style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800)),
          const Spacer(),
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.more_vert_rounded)),
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
                color: _whatsAppGreen, shape: BoxShape.circle),
            child: const Icon(Icons.add_rounded, color: appBackground, size: 28),
          ),
          const SizedBox(width: 4),
          IconButton(onPressed: onClose, icon: const Icon(Icons.close_rounded)),
        ]),
      );
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onChanged});
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: 'Search or start a new chat',
            hintStyle: const TextStyle(color: Color(0xFFB7B2AC)),
            prefixIcon: const Icon(Icons.search_rounded, color: appMuted),
            filled: true,
            fillColor: const Color(0xFF2B2D2F),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
                borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      );
}

class _FilterRow extends StatelessWidget {
  const _FilterRow();

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: const Row(children: [
          _FilterPill('All', selected: true),
          SizedBox(width: 8),
          _FilterPill('Favourites'),
          SizedBox(width: 8),
          _FilterPill('Unread 25'),
          SizedBox(width: 8),
          _FilterPill('Groups'),
          SizedBox(width: 8),
          _AddFilterButton(),
        ]),
      );
}

class _FilterPill extends StatelessWidget {
  const _FilterPill(this.text, {this.selected = false});
  final String text;
  final bool selected;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF103B2B) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
              color: selected ? const Color(0xFF176B49) : Colors.white24),
        ),
        child: Text(text,
            style: TextStyle(
                color: selected ? const Color(0xFFA8F2CE) : appMuted,
                fontWeight: FontWeight.w700)),
      );
}

class _AddFilterButton extends StatelessWidget {
  const _AddFilterButton();
  @override
  Widget build(BuildContext context) => const CircleAvatar(
      radius: 20,
      backgroundColor: Colors.transparent,
      child: Icon(Icons.add_rounded, color: appMuted));
}

class _NotificationBanner extends StatelessWidget {
  const _NotificationBanner({required this.onDismiss});
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.fromLTRB(18, 15, 10, 15),
        decoration: BoxDecoration(
            color: const Color(0xFF073B2B), borderRadius: BorderRadius.circular(22)),
        child: Row(children: [
          const Icon(Icons.notifications_off_outlined,
              color: _whatsAppGreen, size: 31),
          const SizedBox(width: 16),
          const Expanded(
              child: Text.rich(TextSpan(children: [
            TextSpan(
                text: 'Message notifications are off. ',
                style: TextStyle(fontWeight: FontWeight.w700)),
            TextSpan(
                text: 'Turn on',
                style: TextStyle(
                    color: _whatsAppGreen, fontWeight: FontWeight.w800)),
          ]))),
          IconButton(onPressed: onDismiss, icon: const Icon(Icons.close_rounded)),
        ]),
      );
}

class _ArchivedRow extends StatelessWidget {
  const _ArchivedRow();
  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.fromLTRB(12, 8, 10, 16),
        child: Row(children: [
          Icon(Icons.archive_outlined, color: appMuted),
          SizedBox(width: 26),
          Expanded(
              child: Text('Archived',
                  style: TextStyle(fontSize: 17, color: appMuted))),
          Text('8', style: TextStyle(color: appMuted)),
        ]),
      );
}

class _WhatsAppAgentTile extends StatelessWidget {
  const _WhatsAppAgentTile({required this.agent});
  final AgentProfile agent;

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AgentChatScreen(
                      agent: '${agent.name} · WhatsApp', color: appGreen)));
        },
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: _whatsAppGreen.withValues(alpha: .16),
          child: Icon(agent.icon, color: _whatsAppGreen, size: 27),
        ),
        title: Text(agent.name,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
        subtitle: Text('${agent.title} · Works 24/7',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: appMuted, fontSize: 12)),
        trailing: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('Now', style: TextStyle(color: _whatsAppGreen, fontSize: 11)),
          SizedBox(height: 5),
          CircleAvatar(
              radius: 10,
              backgroundColor: _whatsAppGreen,
              child: Text('1',
                  style: TextStyle(color: appBackground, fontSize: 10))),
        ]),
      );
}
