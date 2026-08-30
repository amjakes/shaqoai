import 'package:flutter/material.dart';

import '../app/colors.dart';
import '../data/agent_catalog.dart';
import '../models/agent_profile.dart';
import '../widgets/ui.dart';
import 'agent_chat_screen.dart';

class AgentsHubScreen extends StatelessWidget {
  const AgentsHubScreen({required this.searchQuery, super.key});
  final String searchQuery;

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 2,
        child: Column(children: [
          const Padding(
              padding: EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: TabBar(tabs: [
                Tab(text: 'My Active Agents'),
                Tab(text: 'Agent Marketplace')
              ])),
          Expanded(
              child: TabBarView(children: [
            _ActiveAgents(searchQuery: searchQuery),
            _AgentMarketplace(searchQuery: searchQuery)
          ])),
        ]),
      );
}

class _ActiveAgents extends StatelessWidget {
  const _ActiveAgents({required this.searchQuery});
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    final activeAgents = agentCatalog
        .where((agent) => const {
              'Amara',
              'Sarah',
              'Kevin',
              'Zara',
              'Grace',
              'Daniel',
              'Halima'
            }.contains(agent.name))
        .where((agent) => _matches(agent, searchQuery))
        .toList();
    return ListView(padding: const EdgeInsets.all(20), children: [
      const StatusPill('7 AGENTS ACTIVE'),
      const SizedBox(height: 15),
      if (activeAgents.isEmpty) const _EmptySearchState(),
      for (final agent in activeAgents)
        _AgentListCard(agent: agent, active: true),
    ]);
  }
}

class _AgentMarketplace extends StatelessWidget {
  const _AgentMarketplace({required this.searchQuery});
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    final marketplace =
        agentCatalog.where((agent) => _matches(agent, searchQuery)).toList();
    return ListView(padding: const EdgeInsets.all(20), children: [
      const Text('Expand your workforce',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
      const SizedBox(height: 5),
      const Text('Hire specialized AI colleagues that work around the clock.',
          style: TextStyle(color: appMuted)),
      const SizedBox(height: 10),
      Text('${marketplace.length} specialists available',
          style: const TextStyle(
              fontSize: 11, color: appCyan, fontWeight: FontWeight.w700)),
      const SizedBox(height: 16),
      if (marketplace.isEmpty) const _EmptySearchState(),
      for (final agent in marketplace) _AgentListCard(agent: agent),
    ]);
  }
}

bool _matches(AgentProfile agent, String query) {
  final needle = query.trim().toLowerCase();
  return needle.isEmpty ||
      '${agent.name} ${agent.title} ${agent.category} ${agent.description} ${agent.capabilities.join(' ')}'
          .toLowerCase()
          .contains(needle);
}

class _AgentListCard extends StatelessWidget {
  const _AgentListCard({required this.agent, this.active = false});
  final AgentProfile agent;
  final bool active;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Glass(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CircleAvatar(
                backgroundColor: appCyan.withValues(alpha: .14),
                child: Icon(agent.icon, color: appCyan)),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(agent.displayName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 13)),
                  const SizedBox(height: 3),
                  Text(agent.category.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 9,
                          color: appViolet,
                          letterSpacing: .6,
                          fontWeight: FontWeight.w700)),
                ])),
            if (active) const Icon(Icons.circle, size: 9, color: appGreen),
          ]),
          const SizedBox(height: 11),
          Text(agent.description,
              style:
                  const TextStyle(fontSize: 11, color: appMuted, height: 1.35)),
          const SizedBox(height: 10),
          Wrap(
              spacing: 6,
              runSpacing: 6,
              children: agent.capabilities
                  .map((capability) => _CapabilityChip(capability))
                  .toList()),
          if (agent.note != null) ...[
            const SizedBox(height: 9),
            Text(agent.note!,
                style: const TextStyle(
                    fontSize: 10,
                    color: appAmber,
                    fontStyle: FontStyle.italic)),
          ],
          const SizedBox(height: 12),
          Row(children: [
            const Icon(Icons.schedule_rounded, color: appGreen, size: 14),
            const SizedBox(width: 5),
            const Text('Works 24/7',
                style: TextStyle(
                    fontSize: 10,
                    color: appGreen,
                    fontWeight: FontWeight.w700)),
            const Spacer(),
            if (active)
              TextButton.icon(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AgentChatScreen(
                              agent: agent.displayName, color: appCyan))),
                  icon: const Icon(Icons.chat_bubble_outline, size: 16),
                  label: const Text('Open'))
            else
              FilledButton.tonal(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              '${agent.name} has been added to your workforce.'))),
                  child: Text('Hire ${agent.name}')),
          ]),
        ])),
      );
}

class _CapabilityChip extends StatelessWidget {
  const _CapabilityChip(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .05),
            borderRadius: BorderRadius.circular(8)),
        child: Text(text, style: const TextStyle(fontSize: 9, color: appMuted)),
      );
}

class _EmptySearchState extends StatelessWidget {
  const _EmptySearchState();
  @override
  Widget build(BuildContext context) => const Padding(
      padding: EdgeInsets.only(top: 32),
      child: Center(
          child: Column(children: [
        Icon(Icons.search_off_rounded, color: appMuted, size: 34),
        SizedBox(height: 10),
        Text('No matching agents found', style: TextStyle(color: appMuted)),
      ])));
}
