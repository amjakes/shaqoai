import 'package:flutter/material.dart';

import '../app/colors.dart';

class Glass extends StatelessWidget {
  const Glass(
      {required this.child,
      this.padding = const EdgeInsets.all(16),
      super.key});
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Container(
        padding: padding,
        decoration: BoxDecoration(
          color: appSurface.withValues(alpha: .86),
          border: Border.all(color: Colors.white.withValues(alpha: .08)),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: .18),
                blurRadius: 25,
                offset: const Offset(0, 10))
          ],
        ),
        child: child,
      );
}

class TitleRow extends StatelessWidget {
  const TitleRow(this.title, this.action, {super.key});
  final String title;
  final String action;

  @override
  Widget build(BuildContext context) => Row(children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        const Spacer(),
        Text(action, style: const TextStyle(fontSize: 10, color: appMuted)),
      ]);
}

class StatusPill extends StatelessWidget {
  const StatusPill(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: appGreen.withValues(alpha: .1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: appGreen.withValues(alpha: .24)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.circle, color: appGreen, size: 7),
          const SizedBox(width: 5),
          Text(text,
              style: const TextStyle(
                  color: appGreen,
                  fontWeight: FontWeight.w800,
                  fontSize: 9,
                  letterSpacing: .7)),
        ]),
      );
}

class WorkspaceLogo extends StatelessWidget {
  const WorkspaceLogo({super.key, this.size = 36});
  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: size,
        height: size,
        child: ClipRect(
          child: Align(
            alignment: Alignment.topCenter,
            heightFactor: .76,
            child: Image.asset('assets/images/shaqoai-logo.png',
                fit: BoxFit.contain),
          ),
        ),
      );
}

class ActivityEvent extends StatelessWidget {
  const ActivityEvent(this.time, this.agent, this.text, this.color,
      {super.key});
  final String time;
  final String agent;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
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
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('$time · $agent',
                    style: const TextStyle(fontSize: 11, color: appMuted)),
                const SizedBox(height: 2),
                Text(text,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600)),
              ])),
        ]),
      );
}

class ActivityFeed extends StatelessWidget {
  const ActivityFeed({super.key});

  @override
  Widget build(BuildContext context) => Glass(
        padding: EdgeInsets.zero,
        child: const Column(children: [
          ActivityEvent('09:47', 'Sales Agent',
              'Follow-up scheduled in HubSpot', appCyan),
          Divider(height: 1),
          ActivityEvent('09:45', 'Executive Agent',
              'Calendar updated for 3pm review', appViolet),
          Divider(height: 1),
          ActivityEvent('09:44', 'Finance Agent',
              'M-Pesa payment matched to invoice', appGreen),
          Divider(height: 1),
          ActivityEvent('09:42', 'Support Agent', 'Customer request classified',
              appAmber),
        ]),
      );
}
