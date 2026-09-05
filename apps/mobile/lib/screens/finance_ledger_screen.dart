import 'package:flutter/material.dart';

import '../app/colors.dart';
import '../services/shaqoai_api.dart';
import '../widgets/ui.dart';
import 'approval_sheet.dart';

class FinanceLedgerScreen extends StatefulWidget {
  const FinanceLedgerScreen({super.key});
  @override
  State<FinanceLedgerScreen> createState() => _FinanceLedgerScreenState();
}

class _FinanceLedgerScreenState extends State<FinanceLedgerScreen> {
  String filter = 'All';
  late final Future<List<SupportConversation>> _supportConversations;

  @override
  void initState() {
    super.initState();
    _supportConversations = ShaqoAiApi().supportConversations();
  }
  @override
  Widget build(BuildContext context) {
    const rows = [
      (
        'M-Pesa payment',
        'INV-1042 · Kenya Office Supplies',
        'KES 15,000',
        'Approved',
        appGreen
      ),
      (
        'Supplier payout',
        'INV-1057 · Logistics partner',
        'KES 84,500',
        'Review',
        appAmber
      ),
      (
        'Client payment',
        'MPESA · Matched automatically',
        'KES 32,000',
        'Approved',
        appGreen
      ),
      (
        'Refund request',
        'Customer WhatsApp escalation',
        'KES 8,400',
        'Review',
        appAmber
      )
    ];
    final visible =
        filter == 'All' ? rows : rows.where((row) => row.$4 == filter).toList();
    return ListView(padding: const EdgeInsets.all(20), children: [
      Glass(
          child: const Row(children: [
        Icon(Icons.account_balance_wallet_rounded, color: appCyan),
        SizedBox(width: 12),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('M-Pesa Operations',
              style: TextStyle(fontWeight: FontWeight.w800)),
          Text('KES 420,000 processed this month',
              style: TextStyle(color: appMuted, fontSize: 11))
        ])),
        Text('Live',
            style: TextStyle(
                color: appGreen, fontWeight: FontWeight.w800, fontSize: 11))
      ])),
      const SizedBox(height: 20),
      Wrap(
          spacing: 8,
          children: ['All', 'Approved', 'Review']
              .map((item) => ChoiceChip(
                  label: Text(item),
                  selected: filter == item,
                  onSelected: (_) => setState(() => filter = item)))
              .toList()),
      const SizedBox(height: 18),
      const TitleRow('M-Pesa ledger', ''),
      for (final row in visible)
        Padding(
            padding: const EdgeInsets.only(top: 10),
            child: InkWell(
                onTap: () {
                  if (row.$4 == 'Review') showApproval(context);
                },
                child: Glass(
                    child: Row(children: [
                  CircleAvatar(
                      backgroundColor: row.$5.withValues(alpha: .14),
                      child: Icon(Icons.payments_outlined, color: row.$5)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(row.$1,
                            style:
                                const TextStyle(fontWeight: FontWeight.w700)),
                        Text(row.$2,
                            style:
                                const TextStyle(color: appMuted, fontSize: 10))
                      ])),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text(row.$3,
                        style: const TextStyle(fontWeight: FontWeight.w800)),
                    Text(row.$4,
                        style: TextStyle(
                            color: row.$5,
                            fontSize: 10,
                            fontWeight: FontWeight.w700))
                  ]),
                ])))),
      const SizedBox(height: 22),
      const TitleRow('WhatsApp pipeline', ''),
      FutureBuilder<List<SupportConversation>>(
          future: _supportConversations,
          builder: (context, snapshot) {
            if (snapshot.hasError) return const Glass(child: Text('Support conversations could not be loaded.'));
            if (!snapshot.hasData) return const Glass(child: Padding(padding: EdgeInsets.all(8), child: Center(child: CircularProgressIndicator())));
            if (snapshot.data!.isEmpty) return const Glass(child: Text('Connect your workspace session to view live WhatsApp conversations.'));
            return Glass(child: Column(children: [
              for (final item in snapshot.data!) ...[
                ActivityEvent('Live', item.sender, item.message, item.status == 'active' ? appGreen : appAmber),
                const Divider(),
              ],
            ]));
          }),
    ]);
  }
}
