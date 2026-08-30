import 'package:flutter/material.dart';

import '../app/colors.dart';
import '../widgets/ui.dart';
import 'account_screens.dart';
import 'agents_hub_screen.dart';
import 'calendar_screen.dart';
import 'dashboard_screen.dart';
import 'finance_ledger_screen.dart';
import 'whatsapp_agents_sheet.dart';

class WorkspaceShell extends StatefulWidget {
  const WorkspaceShell({super.key});

  @override
  State<WorkspaceShell> createState() => _WorkspaceShellState();
}

class _WorkspaceShellState extends State<WorkspaceShell> {
  int index = 0;
  String query = '';

  @override
  Widget build(BuildContext context) {
    final pages = [
      const DashboardScreen(),
      AgentsHubScreen(searchQuery: query),
      const FinanceLedgerScreen(),
      const CalendarScreen(),
    ];
    return Scaffold(
      appBar: _WorkspaceHeader(
        onSearch: (value) => setState(() => query = value),
        onOpenAlerts: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const AlertsScreen())),
        onOpenProfile: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
      ),
      body: SafeArea(top: false, child: pages[index]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showWhatsAppAgents(context),
        backgroundColor: const Color(0xFF25D366),
        foregroundColor: appBackground,
        icon: const Icon(Icons.chat_rounded),
        label:
            const Text('Chats', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        backgroundColor: const Color(0xFF0C1326),
        indicatorColor: appCyan.withValues(alpha: .16),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.grid_view_rounded), label: 'Dashboard'),
          NavigationDestination(
              icon: Icon(Icons.hub_outlined), label: 'Agents'),
          NavigationDestination(
              icon: Icon(Icons.account_balance_wallet_outlined),
              label: 'Finance'),
          NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined), label: 'Calendar'),
        ],
      ),
    );
  }
}

class _WorkspaceHeader extends StatelessWidget implements PreferredSizeWidget {
  const _WorkspaceHeader(
      {required this.onSearch,
      required this.onOpenAlerts,
      required this.onOpenProfile});
  final ValueChanged<String> onSearch;
  final VoidCallback onOpenAlerts;
  final VoidCallback onOpenProfile;

  @override
  Size get preferredSize => const Size.fromHeight(68);

  @override
  Widget build(BuildContext context) => AppBar(
        titleSpacing: 14,
        title: LayoutBuilder(builder: (context, constraints) {
          final showWordmark = constraints.maxWidth > 420;
          return Row(children: [
            const WorkspaceLogo(),
            if (showWordmark) ...[
              const SizedBox(width: 8),
              const Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Text('ShaqoAI',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800)),
                    Text('INTELLIGENT WORKSPACE',
                        style: TextStyle(
                            fontSize: 8, color: appMuted, letterSpacing: 1)),
                  ])),
            ] else
              const SizedBox(width: 8),
            Expanded(child: _SearchField(onChanged: onSearch)),
            IconButton(
                onPressed: onOpenAlerts,
                icon:
                    const Badge(child: Icon(Icons.notifications_none_rounded))),
            IconButton(
              onPressed: onOpenProfile,
              icon: const CircleAvatar(
                  radius: 14,
                  backgroundColor: Color(0xFF263A63),
                  child: Text('JM',
                      style: TextStyle(fontSize: 10, color: appCyan))),
            ),
          ]);
        }),
      );
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.onChanged});
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 39,
        child: TextField(
          onChanged: onChanged,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Search agents',
            hintStyle: const TextStyle(fontSize: 12, color: appMuted),
            prefixIcon:
                const Icon(Icons.search_rounded, color: appMuted, size: 19),
            contentPadding: EdgeInsets.zero,
            filled: true,
            fillColor: appSurface.withValues(alpha: .9),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    BorderSide(color: Colors.white.withValues(alpha: .08))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: appCyan)),
          ),
        ),
      );
}
