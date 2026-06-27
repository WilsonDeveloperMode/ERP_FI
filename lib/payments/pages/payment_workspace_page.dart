import 'package:flutter/material.dart';

import 'package:erp_fi/erp_shell/widgets/erp_top_header.dart';
import '../widgets/payment_panel.dart';

class PaymentWorkspacePage extends StatelessWidget {
  const PaymentWorkspacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ErpTopHeader(
            title: 'Payment',
            emphasis: 'Progress',
            actionLabel: 'Record Payment',
          ),
          SizedBox(height: 20),
          PaymentPanel(),
        ],
      ),
    );
  }
}
