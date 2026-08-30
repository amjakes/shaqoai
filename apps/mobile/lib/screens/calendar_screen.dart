import 'package:flutter/material.dart';

import '../app/colors.dart';
import '../widgets/ui.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      ListView(padding: const EdgeInsets.all(20), children: [
        Glass(
            child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Text('Thursday, 20 August',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
              SizedBox(height: 5),
              Text('3 agent tasks and 2 scheduled syncs',
                  style: TextStyle(color: appMuted)),
              SizedBox(height: 17),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                _Day('M', '18'),
                _Day('T', '19'),
                _Day('W', '20'),
                _Day('T', '21', active: true),
                _Day('F', '22'),
                _Day('S', '23'),
                _Day('S', '24')
              ])
            ])),
        const SizedBox(height: 22),
        const TitleRow('Today’s schedule', ''),
        const _Schedule('09:30', 'Executive briefing',
            'Executive Agent · Daily priorities', appViolet),
        const _Schedule('11:00', 'Lead qualification sync',
            'Sales Agent · HubSpot pipeline', appCyan),
        const _Schedule('15:00', 'Finance approval review',
            'Finance Agent · 2 actions waiting', appAmber),
        const _Schedule('16:30', 'Customer service digest',
            'Support Agent · WhatsApp & email', appGreen),
        const SizedBox(height: 20),
        const TitleRow('Scheduled automations', ''),
        Glass(
            child: const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.sync_rounded, color: appCyan),
                title: Text('Google Calendar sync'),
                subtitle: Text('Every 15 minutes · Last synced 2 min ago',
                    style: TextStyle(fontSize: 11, color: appMuted)),
                trailing: Icon(Icons.check_circle, color: appGreen))),
      ]);
}

class _Day extends StatelessWidget {
  const _Day(this.day, this.number, {this.active = false});
  final String day, number;
  final bool active;
  @override
  Widget build(BuildContext context) => Column(children: [
        Text(day, style: const TextStyle(fontSize: 10, color: appMuted)),
        const SizedBox(height: 7),
        CircleAvatar(
            radius: 16,
            backgroundColor: active ? appCyan : Colors.transparent,
            child: Text(number,
                style: TextStyle(
                    fontSize: 11,
                    color: active ? appBackground : Colors.white,
                    fontWeight: FontWeight.w800)))
      ]);
}

class _Schedule extends StatelessWidget {
  const _Schedule(this.time, this.title, this.detail, this.color);
  final String time, title, detail;
  final Color color;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
            width: 45,
            child: Text(time,
                style: const TextStyle(color: appMuted, fontSize: 11))),
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
                          style: const TextStyle(fontSize: 10, color: appMuted))
                    ])))
      ]));
}
