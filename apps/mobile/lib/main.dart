import 'package:flutter/material.dart';

void main() => runApp(const ShaqoAiApp());

const _bg = Color(0xFF070B18),
    _surface = Color(0xFF111A31),
    _cyan = Color(0xFF22D3EE),
    _violet = Color(0xFFA78BFA),
    _green = Color(0xFF4ADE80),
    _muted = Color(0xFF9EACC5);

class ShaqoAiApp extends StatelessWidget {
  const ShaqoAiApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ShaqoAI',
      theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: _bg,
          colorScheme:
              const ColorScheme.dark(primary: _cyan, secondary: _violet),
          appBarTheme: const AppBarTheme(
              backgroundColor: _bg, surfaceTintColor: Colors.transparent),
          bottomSheetTheme:
              const BottomSheetThemeData(backgroundColor: _surface)),
      home: const Shell());
}

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int i = 0;
  final pages = const [
    DashboardScreen(),
    AgentsHubScreen(),
    FinanceLedgerScreen(),
    CalendarScreen()
  ];
  @override
  Widget build(BuildContext c) => Scaffold(
      appBar: AppBar(
          titleSpacing: 20,
          title: Row(children: [
            const Brand(),
            const SizedBox(width: 10),
            const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ShaqoAI',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                  Text('INTELLIGENT WORKSPACE',
                      style: TextStyle(
                          fontSize: 9, color: _muted, letterSpacing: 1))
                ])
          ]),
          actions: [
            IconButton(
                onPressed: () => Navigator.push(
                    c, MaterialPageRoute(builder: (_) => const AlertsScreen())),
                icon:
                    const Badge(child: Icon(Icons.notifications_none_rounded))),
            IconButton(
                onPressed: () => Navigator.push(c,
                    MaterialPageRoute(builder: (_) => const ProfileScreen())),
                icon: const CircleAvatar(
                    radius: 14,
                    backgroundColor: Color(0xFF263A63),
                    child: Text('JM',
                        style: TextStyle(fontSize: 10, color: _cyan))))
          ]),
      body: SafeArea(top: false, child: pages[i]),
      bottomNavigationBar: NavigationBar(
          selectedIndex: i,
          onDestinationSelected: (v) => setState(() => i = v),
          backgroundColor: const Color(0xFF0C1326),
          indicatorColor: _cyan.withValues(alpha: .16),
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.grid_view_rounded), label: 'Dashboard'),
            NavigationDestination(
                icon: Icon(Icons.hub_outlined), label: 'Agents'),
            NavigationDestination(
                icon: Icon(Icons.account_balance_wallet_outlined),
                label: 'Finance'),
            NavigationDestination(
                icon: Icon(Icons.calendar_month_outlined), label: 'Calendar')
          ]));
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext c) =>
      ListView(padding: const EdgeInsets.all(20), children: [
        Glass(
            child: Row(children: [
          const Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Pill('ALL SYSTEMS OPERATIONAL'),
                SizedBox(height: 12),
                Text('Good morning, James.',
                    style:
                        TextStyle(fontWeight: FontWeight.w800, fontSize: 25)),
                SizedBox(height: 6),
                Text(
                    'Your AI workforce completed 128 tasks while you were away.',
                    style: TextStyle(color: _muted, height: 1.4))
              ])),
          IconButton.filledTonal(
              onPressed: () => showApproval(c),
              icon: const Icon(Icons.verified_user_outlined))
        ])),
        const SizedBox(height: 20),
        const MetricGrid(),
        const SizedBox(height: 22),
        const TitleRow('Workflow volume', 'Last 7 days'),
        const VolumeChart(),
        const SizedBox(height: 20),
        const TitleRow('Autonomous action feed', 'View all'),
        const Feed(),
        const SizedBox(height: 22),
        const TitleRow('Your active workforce', ''),
        const AgentRail()
      ]);
}

class MetricGrid extends StatelessWidget {
  const MetricGrid({super.key});
  @override
  Widget build(BuildContext c) => GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: MediaQuery.sizeOf(c).width > 650 ? 4 : 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.18,
          children: const [
            Metric(
                '1,284', 'Tasks completed', Icons.bolt_rounded, _cyan, '+18%'),
            Metric('KES 420K', 'Value protected', Icons.trending_up_rounded,
                _green, '+12%'),
            Metric('7', 'Active agents', Icons.hub_rounded, _violet, 'Live'),
            Metric('2', 'Approvals waiting', Icons.security_rounded,
                Color(0xFFFBBF24), 'Review')
          ]);
}

class Metric extends StatelessWidget {
  final String v, l, t;
  final IconData icon;
  final Color color;
  const Metric(this.v, this.l, this.icon, this.color, this.t, {super.key});
  @override
  Widget build(BuildContext c) => Glass(
      padding: const EdgeInsets.all(11),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Icon(icon, color: color, size: 16),
          Text(t,
              style: TextStyle(
                  color: color, fontSize: 9, fontWeight: FontWeight.w800))
        ]),
        const Spacer(),
        Text(v,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        Text(l, style: const TextStyle(fontSize: 10, color: _muted))
      ]));
}

class VolumeChart extends StatelessWidget {
  const VolumeChart({super.key});
  @override
  Widget build(BuildContext c) => Glass(
      child: SizedBox(
          height: 176,
          child: CustomPaint(
              painter: _Chart(),
              child: const Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('Mon',
                                style: TextStyle(fontSize: 10, color: _muted)),
                            Text('Tue',
                                style: TextStyle(fontSize: 10, color: _muted)),
                            Text('Wed',
                                style: TextStyle(fontSize: 10, color: _muted)),
                            Text('Thu',
                                style: TextStyle(fontSize: 10, color: _muted)),
                            Text('Fri',
                                style: TextStyle(fontSize: 10, color: _muted)),
                            Text('Sat',
                                style: TextStyle(fontSize: 10, color: _muted)),
                            Text('Sun',
                                style: TextStyle(fontSize: 10, color: _muted))
                          ]))))));
}

class Feed extends StatelessWidget {
  const Feed({super.key});
  @override
  Widget build(BuildContext c) => Glass(
      padding: EdgeInsets.zero,
      child: const Column(children: [
        Event('09:47', 'Sales Agent', 'Follow-up scheduled in HubSpot', _cyan),
        Divider(height: 1),
        Event('09:45', 'Executive Agent', 'Calendar updated for 3pm review',
            _violet),
        Divider(height: 1),
        Event('09:44', 'Finance Agent', 'M-Pesa payment matched to invoice',
            _green),
        Divider(height: 1),
        Event('09:42', 'Support Agent', 'Customer request classified',
            Color(0xFFFBBF24))
      ]));
}

class Event extends StatelessWidget {
  final String time, agent, text;
  final Color color;
  const Event(this.time, this.agent, this.text, this.color, {super.key});
  @override
  Widget build(BuildContext c) => Padding(
      padding: const EdgeInsets.all(13),
      child: Row(children: [
        Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: color.withValues(alpha: .5), blurRadius: 9)
                ])),
        const SizedBox(width: 11),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('$time · $agent',
              style: const TextStyle(fontSize: 11, color: _muted)),
          const SizedBox(height: 2),
          Text(text,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))
        ]))
      ]));
}

class AgentRail extends StatelessWidget {
  const AgentRail({super.key});
  @override
  Widget build(BuildContext c) {
    final a = [
      ('Executive', Icons.account_tree_outlined, _violet),
      ('Sales', Icons.auto_graph_rounded, _cyan),
      ('Finance', Icons.account_balance_wallet_outlined, _green),
      ('Support', Icons.support_agent_rounded, const Color(0xFFFBBF24))
    ];
    return SizedBox(
        height: 122,
        child: ListView(scrollDirection: Axis.horizontal, children: [
          for (final x in a)
            Padding(
                padding: const EdgeInsets.only(right: 12),
                child: SizedBox(
                    width: 135,
                    child: Glass(
                        child: InkWell(
                            onTap: () => Navigator.push(
                                c,
                                MaterialPageRoute(
                                    builder: (_) => AgentChatScreen(
                                        agent: x.$1, color: x.$3))),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                      backgroundColor: x.$3.withValues(alpha: .16),
                                      child: Icon(x.$2, color: x.$3)),
                                  const SizedBox(height: 8),
                                  Text('${x.$1} Agent',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12)),
                                  const Text('Working now',
                                      style: TextStyle(
                                          color: _muted, fontSize: 10))
                                ])))))
        ]));
  }
}

class AgentsHubScreen extends StatelessWidget {
  const AgentsHubScreen({super.key});
  @override
  Widget build(BuildContext c) => DefaultTabController(
      length: 2,
      child: Column(children: [
        const Padding(
            padding: EdgeInsets.fromLTRB(20, 14, 20, 0),
            child: TabBar(tabs: [
              Tab(text: 'My Active Agents'),
              Tab(text: 'Agent Marketplace')
            ])),
        Expanded(child: TabBarView(children: [_Active(), _Market()]))
      ]));
}

class _Active extends StatelessWidget {
  @override
  Widget build(BuildContext c) {
    final agents = [
      (
        'Executive Agent',
        'Orchestrates priorities and team syncs',
        Icons.account_tree_rounded,
        _violet
      ),
      (
        'Sales Agent',
        'Qualifies leads and schedules follow-up',
        Icons.auto_graph_rounded,
        _cyan
      ),
      (
        'Finance Agent',
        'Matches payments and flags exceptions',
        Icons.account_balance_wallet_rounded,
        _green
      ),
      (
        'Support Agent',
        'Resolves conversations across channels',
        Icons.support_agent_rounded,
        const Color(0xFFFBBF24)
      )
    ];
    return ListView(padding: const EdgeInsets.all(20), children: [
      const Pill('7 AGENTS ACTIVE'),
      const SizedBox(height: 15),
      for (final a in agents)
        Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Glass(
                child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                        backgroundColor: a.$4.withValues(alpha: .16),
                        child: Icon(a.$3, color: a.$4)),
                    title: Text(a.$1,
                        style: const TextStyle(fontWeight: FontWeight.w800)),
                    subtitle: Text(a.$2,
                        style: const TextStyle(fontSize: 11, color: _muted)),
                    trailing: IconButton(
                        icon: const Icon(Icons.chat_bubble_outline),
                        onPressed: () => Navigator.push(
                            c,
                            MaterialPageRoute(
                                builder: (_) => AgentChatScreen(
                                    agent: a.$1, color: a.$4)))))))
    ]);
  }
}

class _Market extends StatelessWidget {
  @override
  Widget build(BuildContext c) {
    final a = [
      ('Research Analyst', 'Market intelligence & reports'),
      ('Content Strategist', 'Campaigns & publishing'),
      ('Operations Manager', 'SOPs & efficiency')
    ];
    return ListView(padding: const EdgeInsets.all(20), children: [
      const Text('Expand your workforce',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
      const SizedBox(height: 5),
      const Text('Deploy specialized agents in minutes.',
          style: TextStyle(color: _muted)),
      const SizedBox(height: 20),
      for (final x in a)
        Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Glass(
                child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(
                        backgroundColor: Color(0x1922D3EE),
                        child: Icon(Icons.smart_toy_outlined, color: _cyan)),
                    title: Text(x.$1,
                        style: const TextStyle(fontWeight: FontWeight.w800)),
                    subtitle: Text(x.$2,
                        style: const TextStyle(fontSize: 11, color: _muted)),
                    trailing: FilledButton.tonal(
                        onPressed: () {}, child: const Text('Deploy')))))
    ]);
  }
}

class FinanceLedgerScreen extends StatefulWidget {
  const FinanceLedgerScreen({super.key});
  @override
  State<FinanceLedgerScreen> createState() => _FinanceState();
}

class _FinanceState extends State<FinanceLedgerScreen> {
  String filter = 'All';
  @override
  Widget build(BuildContext c) {
    final rows = [
      (
        'M-Pesa payment',
        'INV-1042 · Kenya Office Supplies',
        'KES 15,000',
        'Approved',
        _green
      ),
      (
        'Supplier payout',
        'INV-1057 · Logistics partner',
        'KES 84,500',
        'Review',
        const Color(0xFFFBBF24)
      ),
      (
        'Client payment',
        'MPESA · Matched automatically',
        'KES 32,000',
        'Approved',
        _green
      ),
      (
        'Refund request',
        'Customer WhatsApp escalation',
        'KES 8,400',
        'Review',
        const Color(0xFFFBBF24)
      )
    ];
    final visible =
        filter == 'All' ? rows : rows.where((r) => r.$4 == filter).toList();
    return ListView(padding: const EdgeInsets.all(20), children: [
      Glass(
          child: const Row(children: [
        Icon(Icons.account_balance_wallet_rounded, color: _cyan),
        SizedBox(width: 12),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('M-Pesa Operations',
              style: TextStyle(fontWeight: FontWeight.w800)),
          Text('KES 420,000 processed this month',
              style: TextStyle(color: _muted, fontSize: 11))
        ])),
        Text('Live',
            style: TextStyle(
                color: _green, fontWeight: FontWeight.w800, fontSize: 11))
      ])),
      const SizedBox(height: 20),
      Wrap(
          spacing: 8,
          children: ['All', 'Approved', 'Review']
              .map((x) => ChoiceChip(
                  label: Text(x),
                  selected: filter == x,
                  onSelected: (_) => setState(() => filter = x)))
              .toList()),
      const SizedBox(height: 18),
      const TitleRow('M-Pesa ledger', ''),
      ...visible.map((r) => Padding(
          padding: const EdgeInsets.only(top: 10),
          child: InkWell(
              onTap: () {
                if (r.$4 == 'Review') showApproval(c);
              },
              child: Glass(
                  child: Row(children: [
                CircleAvatar(
                    backgroundColor: r.$5.withValues(alpha: .14),
                    child: Icon(Icons.payments_outlined, color: r.$5)),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(r.$1,
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      Text(r.$2,
                          style: const TextStyle(color: _muted, fontSize: 10))
                    ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text(r.$3,
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                  Text(r.$4,
                      style: TextStyle(
                          color: r.$5,
                          fontSize: 10,
                          fontWeight: FontWeight.w700))
                ])
              ]))))),
      const SizedBox(height: 22),
      const TitleRow('WhatsApp pipeline', ''),
      Glass(
          child: const Column(children: [
        Event('09:47', 'Sales Agent', 'Lead follow-up sent', _cyan),
        Divider(),
        Event('09:39', 'Support Agent', 'Payment question resolved', _green),
        Divider(),
        Event(
            '09:28', 'Finance Agent', 'Receipt delivered to customer', _violet)
      ]))
    ]);
  }
}

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});
  @override
  Widget build(BuildContext c) =>
      ListView(padding: const EdgeInsets.all(20), children: [
        Glass(
            child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Text('Thursday, 20 August',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
              SizedBox(height: 5),
              Text('3 agent tasks and 2 scheduled syncs',
                  style: TextStyle(color: _muted)),
              SizedBox(height: 17),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Day('M', '18'),
                Day('T', '19'),
                Day('W', '20'),
                Day('T', '21', active: true),
                Day('F', '22'),
                Day('S', '23'),
                Day('S', '24')
              ])
            ])),
        const SizedBox(height: 22),
        const TitleRow('Today’s schedule', ''),
        const Schedule('09:30', 'Executive briefing',
            'Executive Agent · Daily priorities', _violet),
        const Schedule('11:00', 'Lead qualification sync',
            'Sales Agent · HubSpot pipeline', _cyan),
        const Schedule('15:00', 'Finance approval review',
            'Finance Agent · 2 actions waiting', Color(0xFFFBBF24)),
        const Schedule('16:30', 'Customer service digest',
            'Support Agent · WhatsApp & email', _green),
        const SizedBox(height: 20),
        const TitleRow('Scheduled automations', ''),
        Glass(
            child: const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.sync_rounded, color: _cyan),
                title: Text('Google Calendar sync'),
                subtitle: Text('Every 15 minutes · Last synced 2 min ago',
                    style: TextStyle(fontSize: 11, color: _muted)),
                trailing: Icon(Icons.check_circle, color: _green)))
      ]);
}

class Day extends StatelessWidget {
  final String d, n;
  final bool active;
  const Day(this.d, this.n, {this.active = false, super.key});
  @override
  Widget build(BuildContext c) => Column(children: [
        Text(d, style: const TextStyle(fontSize: 10, color: _muted)),
        const SizedBox(height: 7),
        CircleAvatar(
            radius: 16,
            backgroundColor: active ? _cyan : Colors.transparent,
            child: Text(n,
                style: TextStyle(
                    fontSize: 11,
                    color: active ? _bg : Colors.white,
                    fontWeight: FontWeight.w800)))
      ]);
}

class Schedule extends StatelessWidget {
  final String time, title, detail;
  final Color color;
  const Schedule(this.time, this.title, this.detail, this.color, {super.key});
  @override
  Widget build(BuildContext c) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
            width: 45,
            child: Text(time,
                style: const TextStyle(color: _muted, fontSize: 11))),
        Container(width: 3, height: 59, color: color),
        const SizedBox(width: 12),
        Expanded(
            child: Glass(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(detail,
                          style: const TextStyle(fontSize: 10, color: _muted))
                    ])))
      ]));
}

class AgentChatScreen extends StatelessWidget {
  final String agent;
  final Color color;
  const AgentChatScreen({required this.agent, required this.color, super.key});
  @override
  Widget build(BuildContext c) => DefaultTabController(
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
            Chat(agent: agent),
            const Padding(padding: EdgeInsets.all(20), child: Feed()),
            ListView(padding: const EdgeInsets.all(20), children: [
              const TitleRow('Agent permissions', ''),
              Glass(
                  child: const Column(children: [
                ListTile(
                    leading: Icon(Icons.check_circle_outline, color: _green),
                    title: Text('Read business data'),
                    subtitle: Text('CRM, calendar, and selected documents')),
                Divider(),
                ListTile(
                    leading: Icon(Icons.verified_user_outlined,
                        color: Color(0xFFFBBF24)),
                    title: Text('Human approval required'),
                    subtitle: Text('Payments and external commitments'))
              ]))
            ])
          ])));
}

class Chat extends StatelessWidget {
  final String agent;
  const Chat({required this.agent, super.key});
  @override
  Widget build(BuildContext c) => Column(children: [
        Expanded(
            child: ListView(padding: const EdgeInsets.all(20), children: [
          const Align(
              alignment: Alignment.centerLeft,
              child: Bubble(
                  'I’ve reviewed your priority queue and identified 3 actions that need attention.',
                  true)),
          const SizedBox(height: 12),
          const Align(
              alignment: Alignment.centerRight,
              child: Bubble('Show me the highest value item.', false)),
          const SizedBox(height: 12),
          const Align(
              alignment: Alignment.centerLeft,
              child: Bubble(
                  'A KES 84,500 supplier payout is waiting for human approval. I have verified the invoice match.',
                  true))
        ])),
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
                            fillColor: _surface,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none))),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_upward_rounded))
                ])))
      ]);
}

class Bubble extends StatelessWidget {
  final String text;
  final bool agent;
  const Bubble(this.text, this.agent, {super.key});
  @override
  Widget build(BuildContext c) => Container(
      constraints: const BoxConstraints(maxWidth: 310),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
          color: agent ? _surface : _cyan.withValues(alpha: .18),
          borderRadius: BorderRadius.circular(15)),
      child: Text(text, style: const TextStyle(fontSize: 13, height: 1.4)));
}

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});
  @override
  Widget build(BuildContext c) => Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: const Padding(padding: EdgeInsets.all(20), child: Feed()));
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext c) => Scaffold(
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
            child: Text('Workspace owner', style: TextStyle(color: _muted))),
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
        ]))
      ]));
}

void showApproval(BuildContext c) => showModalBottomSheet(
    context: c, isScrollControlled: true, builder: (_) => const Approval());

class Approval extends StatelessWidget {
  const Approval({super.key});
  @override
  Widget build(BuildContext c) => Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
            width: 38,
            height: 4,
            decoration: BoxDecoration(
                color: _muted.withValues(alpha: .45),
                borderRadius: BorderRadius.circular(10))),
        const SizedBox(height: 22),
        const Row(children: [
          CircleAvatar(
              backgroundColor: Color(0x33FBBF24),
              child: Icon(Icons.shield_outlined, color: Color(0xFFFBBF24))),
          SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('Human approval required',
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                Text('Finance Agent prepared this action',
                    style: TextStyle(color: _muted, fontSize: 11))
              ]))
        ]),
        const SizedBox(height: 22),
        Glass(
            child: const Column(children: [
          ListTile(
              title: Text('Recipient'),
              trailing: Text('Logistics Partner Ltd.')),
          Divider(),
          ListTile(
              title: Text('Amount'),
              trailing: Text('KES 84,500',
                  style: TextStyle(fontWeight: FontWeight.w800))),
          Divider(),
          ListTile(
              title: Text('Reason'),
              subtitle: Text('Supplier payout · INV-1057'))
        ])),
        const SizedBox(height: 18),
        const Text(
            'The Finance Agent verified the invoice, recipient, and transaction history. This payout will not proceed until you make a decision.',
            style: TextStyle(color: _muted, fontSize: 12, height: 1.45)),
        const SizedBox(height: 22),
        Row(children: [
          Expanded(
              child: OutlinedButton(
                  onPressed: () => Navigator.pop(c),
                  child: const Text('Reject'))),
          const SizedBox(width: 12),
          Expanded(
              child: FilledButton(
                  onPressed: () => Navigator.pop(c),
                  style: FilledButton.styleFrom(
                      backgroundColor: _green, foregroundColor: _bg),
                  child: const Text('Approve payout')))
        ])
      ]));
}

class Glass extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const Glass(
      {required this.child,
      this.padding = const EdgeInsets.all(16),
      super.key});
  @override
  Widget build(BuildContext c) => Container(
      padding: padding,
      decoration: BoxDecoration(
          color: _surface.withValues(alpha: .86),
          border: Border.all(color: Colors.white.withValues(alpha: .08)),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: .18),
                blurRadius: 25,
                offset: const Offset(0, 10))
          ]),
      child: child);
}

class TitleRow extends StatelessWidget {
  final String title, action;
  const TitleRow(this.title, this.action, {super.key});
  @override
  Widget build(BuildContext c) => Row(children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        const Spacer(),
        Text(action, style: const TextStyle(fontSize: 10, color: _muted))
      ]);
}

class Pill extends StatelessWidget {
  final String text;
  const Pill(this.text, {super.key});
  @override
  Widget build(BuildContext c) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
          color: _green.withValues(alpha: .1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _green.withValues(alpha: .24))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.circle, color: _green, size: 7),
        const SizedBox(width: 5),
        Text(text,
            style: const TextStyle(
                color: _green,
                fontWeight: FontWeight.w800,
                fontSize: 9,
                letterSpacing: .7))
      ]));
}

class Brand extends StatelessWidget {
  const Brand({super.key});
  @override
  Widget build(BuildContext c) => Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(colors: [_cyan, _violet]),
          boxShadow: [
            BoxShadow(color: _cyan.withValues(alpha: .35), blurRadius: 14)
          ]),
      child: const Icon(Icons.hub_rounded, color: _bg, size: 19));
}

class _Chart extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final grid = Paint()..color = Colors.white.withValues(alpha: .06);
    for (var i = 1; i < 4; i++) {
      c.drawLine(
          Offset(0, s.height * i / 4), Offset(s.width, s.height * i / 4), grid);
    }
    final p = Path()
      ..moveTo(0, s.height * .7)
      ..cubicTo(s.width * .12, s.height * .58, s.width * .17, s.height * .28,
          s.width * .28, s.height * .48)
      ..cubicTo(s.width * .4, s.height * .75, s.width * .44, s.height * .21,
          s.width * .57, s.height * .39)
      ..cubicTo(s.width * .7, s.height * .58, s.width * .8, s.height * .2,
          s.width, s.height * .12);
    final fill = Path.from(p)
      ..lineTo(s.width, s.height)
      ..lineTo(0, s.height)
      ..close();
    c.drawPath(
        fill,
        Paint()
          ..shader = const LinearGradient(
                  colors: [Color(0x3322D3EE), Color(0x006366F1)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)
              .createShader(Offset.zero & s));
    c.drawPath(
        p,
        Paint()
          ..shader = const LinearGradient(colors: [_cyan, _violet])
              .createShader(Offset.zero & s)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round);
  }

  @override
  bool shouldRepaint(_Chart old) => false;
}

