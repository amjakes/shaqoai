import 'package:flutter/material.dart';

import '../app/colors.dart';
import '../widgets/ui.dart';

void showApproval(BuildContext context) => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => const ApprovalSheet());

class ApprovalSheet extends StatelessWidget {
  const ApprovalSheet({super.key});
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
            width: 38,
            height: 4,
            decoration: BoxDecoration(
                color: appMuted.withValues(alpha: .45),
                borderRadius: BorderRadius.circular(10))),
        const SizedBox(height: 22),
        const Row(children: [
          CircleAvatar(
              backgroundColor: Color(0x33FBBF24),
              child: Icon(Icons.shield_outlined, color: appAmber)),
          SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('Human approval required',
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                Text('Finance Agent prepared this action',
                    style: TextStyle(color: appMuted, fontSize: 11))
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
            style: TextStyle(color: appMuted, fontSize: 12, height: 1.45)),
        const SizedBox(height: 22),
        Row(children: [
          Expanded(
              child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Reject'))),
          const SizedBox(width: 12),
          Expanded(
              child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  style: FilledButton.styleFrom(
                      backgroundColor: appGreen,
                      foregroundColor: appBackground),
                  child: const Text('Approve payout')))
        ]),
      ]));
}
