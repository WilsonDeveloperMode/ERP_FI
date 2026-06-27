import 'package:flutter/material.dart';

import 'package:erp_fi/auth/pages/login_page.dart';
import 'package:erp_fi/theme/app_theme.dart';

class FrancisInteriorApp extends StatelessWidget {
  const FrancisInteriorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Francis Interior ERP',
      theme: buildAppTheme(),
      home: const LoginPage(),
    );
  }
}
