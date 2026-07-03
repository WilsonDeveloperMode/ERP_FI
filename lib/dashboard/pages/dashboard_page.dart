import 'dart:async';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:erp_fi/contracts/pages/contract_workspace_page.dart';
import 'package:erp_fi/customers/pages/customer_page.dart';
import 'package:erp_fi/erp_shell/data/erp_sample_data.dart';
import 'package:erp_fi/erp_shell/pages/placeholder_workspace_page.dart';
import 'package:erp_fi/erp_shell/widgets/erp_sidebar.dart';
import 'package:erp_fi/payments/pages/payment_workspace_page.dart';
import 'package:erp_fi/theme/app_colors.dart';
import 'dashboard_overview_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  final GlobalKey _profileMenuKey = GlobalKey();
  late final Connectivity _connectivity;
  late final ImagePicker _imagePicker;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isOnline = true;
  Uint8List? _profileImageBytes;

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _imagePicker = ImagePicker();
    _initializeConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      results,
    ) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isOnline = results.any((result) => result != ConnectivityResult.none);
      });
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedItem = erpMenuItems[_selectedIndex];
    final showCenteredSectionTitle = selectedItem.id == 'customer';

    return Scaffold(
      backgroundColor: AppColors.canvas,
      drawer: Drawer(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        child: ErpSidebar(
          selectedIndex: _selectedIndex,
          items: erpMenuItems,
          onSelect: _selectIndex,
        ),
      ),
      appBar: AppBar(
        centerTitle: showCenteredSectionTitle,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: showCenteredSectionTitle
            ? Text(
                selectedItem.label,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.white),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Francis Interior ERP',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.white),
                  ),
                  Text(
                    selectedItem.label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.72),
                    ),
                  ),
                ],
              ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          _ConnectionStatusChip(isOnline: _isOnline),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              key: _profileMenuKey,
              borderRadius: BorderRadius.circular(999),
              onTap: _openProfileActions,
              child: _ProfileAvatar(
                imageBytes: _profileImageBytes,
                radius: 16,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.heroTop, AppColors.canvas],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: _buildBody(selectedItem.id),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(String sectionId) {
    return switch (sectionId) {
      'dashboard' => const DashboardOverviewPage(),
      'customer' => const CustomerPage(),
      'contract' => const ContractWorkspacePage(),
      'payment' => const PaymentWorkspacePage(),
      'commission' => const PlaceholderWorkspacePage(
        title: 'Commission Management',
        description:
            'Assign staff commission percentages, connect them to contracts, and track payout completion.',
      ),
      'materials' => const PlaceholderWorkspacePage(
        title: 'Material Management',
        description:
            'Define project material requirements before procurement or stock usage.',
      ),
      'inventory' => const PlaceholderWorkspacePage(
        title: 'Inventory Management',
        description:
            'Check warehouse stock, reserve materials, and monitor stock movement by project.',
      ),
      'purchase_order' => const PlaceholderWorkspacePage(
        title: 'Purchase Order Management',
        description:
            'Create supplier purchase orders when required materials are unavailable in stock.',
      ),
      'logistics' => const PlaceholderWorkspacePage(
        title: 'Logistics & Delivery',
        description:
            'Plan delivery schedules, installation dates, and final project handover.',
      ),
      'reports' => const PlaceholderWorkspacePage(
        title: 'Reports & Monitoring',
        description:
            'View project health, payment performance, revenue movement, and completion tracking.',
      ),
      _ => const PlaceholderWorkspacePage(
        title: 'Settings',
        description:
            'Configure system preferences, account roles, and workflow defaults.',
      ),
    };
  }

  void _selectIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _initializeConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    if (!mounted) {
      return;
    }

    setState(() {
      _isOnline = results.any((result) => result != ConnectivityResult.none);
    });
  }

  Future<void> _openProfileActions() async {
    final renderBox =
        _profileMenuKey.currentContext?.findRenderObject() as RenderBox?;
    final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox?;

    if (renderBox == null || overlay == null) {
      return;
    }

    final center = renderBox.localToGlobal(
      renderBox.size.center(Offset.zero),
      ancestor: overlay,
    );
    const anchorSize = 12.0;
    final anchorRect = Rect.fromCenter(
      center: center,
      width: anchorSize,
      height: anchorSize,
    );
    const cardWidth = 320.0;
    final left = (anchorRect.center.dx - cardWidth).clamp(
      16.0,
      overlay.size.width - cardWidth - 16.0,
    );
    final top = anchorRect.bottom + 14;

    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Account actions',
      barrierColor: Colors.black.withValues(alpha: 0.18),
      transitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.of(dialogContext).pop(),
                ),
              ),
              Positioned(
                left: left,
                top: top,
                width: cardWidth,
                child: _ProfileActionCard(
                  imageBytes: _profileImageBytes,
                  onEditPhoto: _pickProfileImage,
                  onClose: () => Navigator.of(dialogContext).pop(),
                ),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.96, end: 1).animate(curved),
            alignment: Alignment.topRight,
            child: child,
          ),
        );
      },
    );
  }

  Future<void> _pickProfileImage() async {
    final file = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      imageQuality: 85,
    );

    if (file == null || !mounted) {
      return;
    }

    final bytes = await file.readAsBytes();
    if (!mounted) {
      return;
    }

    setState(() {
      _profileImageBytes = bytes;
    });
  }
}

class _ConnectionStatusChip extends StatelessWidget {
  const _ConnectionStatusChip({required this.isOnline});

  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final color = isOnline ? const Color(0xFF9FD3A8) : const Color(0xFFE1A4A4);
    final label = isOnline ? 'Online' : 'Offline';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({
    required this.imageBytes,
    required this.radius,
  });

  final Uint8List? imageBytes;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primary,
      backgroundImage: imageBytes != null ? MemoryImage(imageBytes!) : null,
      child: imageBytes == null
          ? Icon(
              Icons.person_rounded,
              size: radius,
              color: Colors.white,
            )
          : null,
    );
  }
}

class _ProfileActionCard extends StatelessWidget {
  const _ProfileActionCard({
    required this.imageBytes,
    required this.onEditPhoto,
    required this.onClose,
  });

  final Uint8List? imageBytes;
  final VoidCallback onEditPhoto;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 28,
            offset: Offset(0, 16),
          ),
        ],
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  _ProfileAvatar(imageBytes: imageBytes, radius: 26),
                  Positioned(
                    right: -6,
                    bottom: -6,
                    child: InkWell(
                      onTap: onEditPhoto,
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: AppColors.ink,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.add_a_photo_outlined,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.ink,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage your account actions here.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _ProfileActionButton(
                label: 'My Profile',
                icon: Icons.badge_outlined,
                onTap: onClose,
              ),
              _ProfileActionButton(
                label: 'Settings',
                icon: Icons.tune_rounded,
                onTap: onClose,
              ),
              _ProfileActionButton(
                label: 'Support',
                icon: Icons.help_outline_rounded,
                onTap: onClose,
              ),
              _ProfileActionButton(
                label: 'Sign Out',
                icon: Icons.logout_rounded,
                onTap: onClose,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileActionButton extends StatelessWidget {
  const _ProfileActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          foregroundColor: AppColors.ink,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
