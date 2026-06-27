import 'package:flutter/material.dart';

import '../../../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../../../shared/widgets/aura_circle.dart';
import '../../../../theme/app_colors.dart';
import '../widgets/brand_panel.dart';
import '../widgets/login_card.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;
  bool _rememberMe = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = 'admin';
    _passwordController.text = 'admin';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 960;
    final loginCard = LoginCard(
      emailController: _emailController,
      passwordController: _passwordController,
      obscurePassword: _obscurePassword,
      rememberMe: _rememberMe,
      onTogglePassword: _togglePasswordVisibility,
      onRememberMeChanged: _updateRememberMe,
      onLogin: _handleLogin,
    );

    final layoutChild = isCompact
        ? Column(
            children: [
              const BrandPanel(),
              const SizedBox(height: 18),
              loginCard,
            ],
          )
        : Row(
            children: [
              const Expanded(flex: 6, child: BrandPanel()),
              const SizedBox(width: 18),
              Expanded(flex: 5, child: loginCard),
            ],
          );

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.heroTop, AppColors.canvas, AppColors.glaze],
          ),
        ),
        child: Stack(
          children: [
            const Positioned(
              top: -80,
              right: -40,
              child: AuraCircle(
                size: 260,
                colors: [Color(0x33FFFFFF), Color(0x10B19174)],
              ),
            ),
            const Positioned(
              bottom: -90,
              left: -50,
              child: AuraCircle(
                size: 220,
                colors: [Color(0x44B19174), Color(0x00B19174)],
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1180),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color(0xCCFFFDFC),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: AppColors.border, width: 1.2),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 30,
                            offset: Offset(0, 16),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: layoutChild,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _updateRememberMe(bool? value) {
    setState(() {
      _rememberMe = value ?? false;
    });
  }

  void _handleLogin() {
    final username = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (username == 'admin' && password == 'admin') {
      Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => const DashboardPage()));
      return;
    }

    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.danger,
        content: Text(
          'Use admin as username and admin as password.',
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
