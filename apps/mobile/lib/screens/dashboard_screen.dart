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
  Widget build(BuildContext context) => GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: MediaQuery.sizeOf(context).width > 650 ? 4 : 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.18,
        children: const [
          _Metric(
              '1,284', 'Tasks completed', Icons.bolt_rounded, appCyan, '+18%'),
          _Metric('KES 420K', 'Value protected', Icons.trending_up_rounded,
              appGreen, '+12%'),
          _Metric('7', 'Active agents', Icons.hub_rounded, appViolet, 'Live'),
          _Metric('2', 'Approvals waiting', Icons.security_rounded, appAmber,
              'Review'),
        ],
      );
}

class _Metric extends StatelessWidget {
  const _Metric(this.value, this.label, this.icon, this.color, this.trend);
  final String value, label, trend;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Glass(
        padding: const EdgeInsets.all(11),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Icon(icon, color: color, size: 16),
            Text(trend,
                style: TextStyle(
                    color: color, fontSize: 9, fontWeight: FontWeight.w800)),
          ]),
          const Spacer(),
          Text(value,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          Text(label, style: const TextStyle(fontSize: 10, color: appMuted)),
        ]),
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
