import 'package:flutter/material.dart';

import '../app/colors.dart';
import '../widgets/ui.dart';
import 'agent_chat_screen.dart';
import 'approval_sheet.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      ListView(padding: const EdgeInsets.all(20), children: [
        Glass(
            child: Row(children: [
          const Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                StatusPill('ALL SYSTEMS OPERATIONAL'),
                SizedBox(height: 12),
                Text('Good morning, Jakes.',
                    style:
                        TextStyle(fontWeight: FontWeight.w800, fontSize: 25)),
                SizedBox(height: 6),
                Text(
                    'Your AI workforce completed 128 tasks while you were away.',
                    style: TextStyle(color: appMuted, height: 1.4)),
              ])),
          IconButton.filledTonal(
              onPressed: () => showApproval(context),
              icon: const Icon(Icons.verified_user_outlined)),
        ])),
        const SizedBox(height: 20),
        const MetricGrid(),
        const SizedBox(height: 22),
        const TitleRow('Workflow volume', 'Last 7 days'),
        const VolumeChart(),
        const SizedBox(height: 20),
        const TitleRow('Autonomous action feed', 'View all'),
        const ActivityFeed(),
        const SizedBox(height: 22),
        const TitleRow('Your active workforce', ''),
        const AgentRail(),
      ]);
}

class MetricGrid extends StatelessWidget {
  const MetricGrid({super.key});

  @override
  Widget build(BuildContext context) => Glass(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
        child: Column(children: [
          const Row(children: [
            Text('Metrics Overview',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            Spacer(),
            Text('View all',
                style: TextStyle(
                    color: appGreen, fontWeight: FontWeight.w700)),
            SizedBox(width: 3),
            Icon(Icons.chevron_right_rounded, color: appGreen),
          ]),
          const SizedBox(height: 22),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: const [
              SizedBox(
                  width: 132,
                  child: _Metric('1,284', 'Tasks completed',
                      Icons.bolt_rounded, appCyan, '+18%')),
              SizedBox(
                  width: 142,
                  child: _Metric('KES 420K', 'Value protected',
                      Icons.trending_up_rounded, appGreen, '+12%')),
              SizedBox(
                  width: 126,
                  child: _Metric('7', 'Active agents', Icons.hub_rounded,
                      appViolet, 'Live')),
              SizedBox(
                  width: 146,
                  child: _Metric('2', 'Approvals waiting',
                      Icons.security_rounded, appAmber, 'Review')),
            ]),
          ),
        ]),
      );
}

class _Metric extends StatelessWidget {
  const _Metric(this.value, this.label, this.icon, this.color, this.trend);
  final String value, label, trend;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 82,
            height: 82,
            child: Stack(clipBehavior: Clip.none, children: [
              Center(
                  child: Container(
                width: 74,
                height: 74,
                decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .1),
                    shape: BoxShape.circle),
                child: Icon(icon, color: Colors.white, size: 37),
              )),
              Positioned(
                top: 0,
                right: -2,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: appSurface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: color, width: 2),
                    boxShadow: [
                      BoxShadow(color: color.withValues(alpha: .2), blurRadius: 8)
                    ],
                  ),
                  child: Text(trend,
                      style: TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.w800)),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 11),
          Text(value,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 3),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.white)),
        ],
      );
}

class VolumeChart extends StatelessWidget {
  const VolumeChart({super.key});

  @override
  Widget build(BuildContext context) => Glass(
      child: SizedBox(
          height: 176,
          child: CustomPaint(
            painter: _VolumeChartPainter(),
            child: const Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('Mon',
                            style: TextStyle(fontSize: 10, color: appMuted)),
                        Text('Tue',
                            style: TextStyle(fontSize: 10, color: appMuted)),
                        Text('Wed',
                            style: TextStyle(fontSize: 10, color: appMuted)),
                        Text('Thu',
                            style: TextStyle(fontSize: 10, color: appMuted)),
                        Text('Fri',
                            style: TextStyle(fontSize: 10, color: appMuted)),
                        Text('Sat',
                            style: TextStyle(fontSize: 10, color: appMuted)),
                        Text('Sun',
                            style: TextStyle(fontSize: 10, color: appMuted)),
                      ]),
                )),
          )));
}

class AgentRail extends StatelessWidget {
  const AgentRail({super.key});
  @override
  Widget build(BuildContext context) {
    const agents = [
      ('Executive', Icons.account_tree_outlined, appViolet),
      ('Sales', Icons.auto_graph_rounded, appCyan),
      ('Finance', Icons.account_balance_wallet_outlined, appGreen),
      ('Support', Icons.support_agent_rounded, appAmber)
    ];
    return SizedBox(
        height: 122,
        child: ListView(scrollDirection: Axis.horizontal, children: [
          for (final agent in agents)
            Padding(
                padding: const EdgeInsets.only(right: 12),
                child: SizedBox(
                    width: 135,
                    child: Glass(
                        child: InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AgentChatScreen(
                                  agent: '${agent.$1} Agent',
                                  color: agent.$3))),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                                backgroundColor:
                                    agent.$3.withValues(alpha: .16),
                                child: Icon(agent.$2, color: agent.$3)),
                            const SizedBox(height: 8),
                            Text('${agent.$1} Agent',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 12)),
                            const Text('Working now',
                                style:
                                    TextStyle(color: appMuted, fontSize: 10)),
                          ]),
                    )))),
        ]));
  }
}

class _VolumeChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()..color = Colors.white.withValues(alpha: .06);
    for (var index = 1; index < 4; index++) {
      canvas.drawLine(Offset(0, size.height * index / 4),
          Offset(size.width, size.height * index / 4), grid);
    }
    final path = Path()
      ..moveTo(0, size.height * .7)
      ..cubicTo(size.width * .12, size.height * .58, size.width * .17,
          size.height * .28, size.width * .28, size.height * .48)
      ..cubicTo(size.width * .4, size.height * .75, size.width * .44,
          size.height * .21, size.width * .57, size.height * .39)
      ..cubicTo(size.width * .7, size.height * .58, size.width * .8,
          size.height * .2, size.width, size.height * .12);
    final fill = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
        fill,
        Paint()
          ..shader = const LinearGradient(
                  colors: [Color(0x3322D3EE), Color(0x006366F1)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)
              .createShader(Offset.zero & size));
    canvas.drawPath(
        path,
        Paint()
          ..shader = const LinearGradient(colors: [appCyan, appViolet])
              .createShader(Offset.zero & size)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
