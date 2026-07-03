import 'package:flutter/material.dart';

import '../models/erp_menu_item.dart';
import '../models/erp_record_models.dart';

const erpMenuItems = <ErpMenuItem>[
  ErpMenuItem(
    id: 'dashboard',
    label: 'Dashboard',
    icon: Icons.dashboard_outlined,
  ),
  ErpMenuItem(
    id: 'customer',
    label: 'Customer',
    icon: Icons.people_outline_rounded,
  ),
  ErpMenuItem(
    id: 'contract',
    label: 'Contract',
    icon: Icons.description_outlined,
  ),
  ErpMenuItem(
    id: 'payment',
    label: 'Payment',
    icon: Icons.credit_card_outlined,
  ),
  ErpMenuItem(
    id: 'commission',
    label: 'Commission',
    icon: Icons.percent_rounded,
  ),
  ErpMenuItem(
    id: 'materials',
    label: 'Materials',
    icon: Icons.inventory_2_outlined,
  ),
  ErpMenuItem(
    id: 'inventory',
    label: 'Inventory',
    icon: Icons.warehouse_outlined,
  ),
  ErpMenuItem(
    id: 'purchase_order',
    label: 'Purchase Order',
    icon: Icons.shopping_cart_checkout_outlined,
  ),
  ErpMenuItem(
    id: 'logistics',
    label: 'Logistics',
    icon: Icons.local_shipping_outlined,
  ),
  ErpMenuItem(id: 'reports', label: 'Reports', icon: Icons.bar_chart_rounded),
  ErpMenuItem(id: 'settings', label: 'Settings', icon: Icons.settings_outlined),
];

const dashboardSummaryCards = <SummaryCardData>[
  SummaryCardData('Total Contracts', '120'),
  SummaryCardData('Active Contracts', '43'),
  SummaryCardData('Total Revenue', 'Rp 5.2B'),
  SummaryCardData('Pending Payments', '8'),
];

const contractRows = <ContractRow>[
  ContractRow(
    contractNo: 'FI-2026-001',
    customer: 'PT Nirwana Kharisma',
    project: 'Luxury Apartment',
    value: 'Rp 1,250,000,000',
    status: 'Active',
  ),
  ContractRow(
    contractNo: 'FI-2026-002',
    customer: 'PT Sentosa Abadi',
    project: 'Office Interior',
    value: 'Rp 800,000,000',
    status: 'Pending',
  ),
  ContractRow(
    contractNo: 'FI-2026-003',
    customer: 'PT Mega Karya',
    project: 'Villa Project',
    value: 'Rp 700,000,000',
    status: 'Active',
  ),
  ContractRow(
    contractNo: 'FI-2026-004',
    customer: 'PT Jaya Makmur',
    project: 'Showroom Interior',
    value: 'Rp 450,000,000',
    status: 'Active',
  ),
  ContractRow(
    contractNo: 'FI-2026-005',
    customer: 'PT Golden Land',
    project: 'Model Unit',
    value: 'Rp 960,000,000',
    status: 'Completed',
  ),
];

const paymentRows = <PaymentRow>[
  PaymentRow('Stage 1', '01 May 2026', 'Rp 750,000,000', 'Paid'),
  PaymentRow('Stage 2', '01 Jun 2026', 'Rp 375,000,000', 'Paid'),
  PaymentRow('Stage 3', '01 Jul 2026', 'Rp 375,000,000', 'Pending'),
];

const customerRows = <CustomerRow>[];

const contractDetailEntries = <KeyValueEntry>[
  KeyValueEntry('Contract No.', 'FI-2026-001'),
  KeyValueEntry('Status', 'Active'),
  KeyValueEntry('Customer', 'PT Nirwana Kharisma'),
  KeyValueEntry('Project / Title', 'Luxury Apartment'),
  KeyValueEntry('Effective Date', '01 May 2026'),
  KeyValueEntry('End Date', '01 May 2027'),
  KeyValueEntry('Contract Value', 'Rp 1,250,000,000'),
  KeyValueEntry('Contract File', 'contract_fi_2026_001.pdf'),
];
