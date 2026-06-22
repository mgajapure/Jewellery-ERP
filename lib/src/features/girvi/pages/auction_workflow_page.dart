import 'package:flutter/material.dart';

import '../../../core/navigation/app_navigation.dart';
import '../theme/girvi_colors.dart';
import 'girvi_details_page.dart';

/// SCR-031 Auction Workflow
///
/// Manages defaulted loans through statutory notice, auction scheduling,
/// sale recording, surplus calculation, and contract closure.
class AuctionWorkflowPage extends StatefulWidget {
  const AuctionWorkflowPage({super.key});

  static const routeName = 'auction-workflow';

  @override
  State<AuctionWorkflowPage> createState() => _AuctionWorkflowPageState();
}

class _AuctionWorkflowPageState extends State<AuctionWorkflowPage> {
  final TextEditingController _saleAmountController = TextEditingController();
  final TextEditingController _buyerNameController = TextEditingController();
  final TextEditingController _buyerMobileController = TextEditingController();

  final double _outstanding = 100917.81;
  final double _penalty = 4500.0;
  final String _girviId = 'GRV-2026-000042';

  int _currentStep = 0;

  final List<Map<String, dynamic>> _steps = const [
    {
      'titleMr': 'सूचना तयार करा',
      'titleEn': 'Generate Notice',
      'icon': Icons.description_outlined,
    },
    {
      'titleMr': 'कर्जदाराला सूचित करा',
      'titleEn': 'Notify Borrower',
      'icon': Icons.notification_add_outlined,
    },
    {
      'titleMr': 'वितरण ट्रॅक करा',
      'titleEn': 'Track Delivery',
      'icon': Icons.local_shipping_outlined,
    },
    {
      'titleMr': 'कायदेशीर कालावधी पूर्ण करा',
      'titleEn': 'Wait Statutory Period',
      'icon': Icons.timer_outlined,
    },
    {
      'titleMr': 'लिलाव नियोजित करा',
      'titleEn': 'Schedule Auction',
      'icon': Icons.event_outlined,
    },
    {
      'titleMr': 'विक्री नोंदवा',
      'titleEn': 'Record Sale',
      'icon': Icons.gavel_outlined,
    },
  ];

  double get _saleAmount {
    return double.tryParse(_saleAmountController.text) ?? 0;
  }

  double get _surplus {
    return _saleAmount - (_outstanding + _penalty);
  }

  bool get _canCompleteAuction {
    return _currentStep >= 5 &&
        _saleAmount > 0 &&
        _buyerNameController.text.isNotEmpty;
  }

  @override
  void dispose() {
    _saleAmountController.dispose();
    _buyerNameController.dispose();
    _buyerMobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GirviColors.screenBg,
      appBar: AppBar(
        backgroundColor: GirviColors.navy,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => AppNavigation.popOrGoNamed(
            context,
            GirviDetailsPage.routeName,
            pathParameters: {'id': _girviId},
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'लिलाव कार्यपद्धती',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              'Auction Workflow',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeaderCard(
                      girviId: _girviId,
                      outstanding: _outstanding,
                      penalty: _penalty,
                    ),
                    const SizedBox(height: 20),
                    _SectionTitle(
                      titleMr: 'लिलाव पायऱ्या',
                      titleEn: 'Auction Steps',
                    ),
                    const SizedBox(height: 12),
                    ..._steps.asMap().entries.map((entry) {
                      final index = entry.key;
                      final step = entry.value;
                      return _StepTile(
                        index: index,
                        titleMr: step['titleMr'] as String,
                        titleEn: step['titleEn'] as String,
                        icon: step['icon'] as IconData,
                        isActive: index == _currentStep,
                        isCompleted: index < _currentStep,
                        onTap: () {
                          setState(() => _currentStep = index + 1);
                        },
                      );
                    }),
                    const SizedBox(height: 24),
                    _SaleForm(
                      saleAmountController: _saleAmountController,
                      buyerNameController: _buyerNameController,
                      buyerMobileController: _buyerMobileController,
                      onChanged: () => setState(() {}),
                    ),
                    const SizedBox(height: 20),
                    _SurplusCard(
                      saleAmount: _saleAmount,
                      outstanding: _outstanding,
                      penalty: _penalty,
                      surplus: _surplus,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GirviColors.red,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: GirviColors.line,
                    disabledForegroundColor: GirviColors.muted,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _canCompleteAuction
                      ? () {
                          // TODO: close contract and refund surplus.
                          AppNavigation.popOrGoNamed(
                            context,
                            GirviDetailsPage.routeName,
                            pathParameters: {'id': _girviId},
                          );
                        }
                      : null,
                  icon: const Icon(Icons.gavel_outlined, size: 20),
                  label: const Text(
                    'लिलाव पूर्ण करा / Complete Auction',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
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
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.girviId,
    required this.outstanding,
    required this.penalty,
  });

  final String girviId;
  final double outstanding;
  final double penalty;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: GirviColors.navy,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            girviId,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: GirviColors.gold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _HeaderItem(
                  label: 'Outstanding',
                  value: '₹ ${outstanding.toStringAsFixed(2)}',
                ),
              ),
              Expanded(
                child: _HeaderItem(
                  label: 'Penalty',
                  value: '₹ ${penalty.toStringAsFixed(2)}',
                  valueColor: GirviColors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'पूर्वअटी: मुदतीपूर्व & १४ दिवसांची सूचना पाठवली / Preconditions: Overdue & 14-day notice sent',
            style: TextStyle(
              fontSize: 11,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderItem extends StatelessWidget {
  const _HeaderItem({
    required this.label,
    required this.value,
    this.valueColor = Colors.white,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.titleMr, required this.titleEn});

  final String titleMr;
  final String titleEn;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleMr,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: GirviColors.ink,
          ),
        ),
        Text(
          titleEn,
          style: const TextStyle(
            fontSize: 12,
            color: GirviColors.muted,
          ),
        ),
      ],
    );
  }
}

class _StepTile extends StatelessWidget {
  const _StepTile({
    required this.index,
    required this.titleMr,
    required this.titleEn,
    required this.icon,
    required this.isActive,
    required this.isCompleted,
    required this.onTap,
  });

  final int index;
  final String titleMr;
  final String titleEn;
  final IconData icon;
  final bool isActive;
  final bool isCompleted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Color circleColor;
    IconData trailingIcon;
    if (isCompleted) {
      circleColor = GirviColors.green;
      trailingIcon = Icons.check;
    } else if (isActive) {
      circleColor = GirviColors.gold;
      trailingIcon = Icons.chevron_right;
    } else {
      circleColor = GirviColors.line;
      trailingIcon = Icons.lock_outline;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: isActive ? onTap : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : GirviColors.screenBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive ? GirviColors.gold : GirviColors.line,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: circleColor.withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isCompleted
                      ? Icon(trailingIcon, size: 18, color: GirviColors.green)
                      : Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isActive
                                ? GirviColors.gold
                                : GirviColors.muted,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titleMr,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isActive ? GirviColors.ink : GirviColors.muted,
                      ),
                    ),
                    Text(
                      titleEn,
                      style: TextStyle(
                        fontSize: 11,
                        color: isActive
                            ? GirviColors.muted
                            : GirviColors.muted.withAlpha(150),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                trailingIcon,
                size: 18,
                color: isActive ? GirviColors.gold : GirviColors.muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SaleForm extends StatelessWidget {
  const _SaleForm({
    required this.saleAmountController,
    required this.buyerNameController,
    required this.buyerMobileController,
    required this.onChanged,
  });

  final TextEditingController saleAmountController;
  final TextEditingController buyerNameController;
  final TextEditingController buyerMobileController;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GirviColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'विक्री तपशील / Sale Details',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: GirviColors.ink,
            ),
          ),
          const SizedBox(height: 12),
          _InputField(
            labelMr: 'विक्री रक्कम',
            labelEn: 'Sale Amount',
            controller: saleAmountController,
            prefix: '₹',
            keyboardType: TextInputType.number,
            onChanged: (_) => onChanged(),
          ),
          const SizedBox(height: 12),
          _InputField(
            labelMr: 'खरेदीदाराचे नाव',
            labelEn: 'Buyer Name',
            controller: buyerNameController,
            onChanged: (_) => onChanged(),
          ),
          const SizedBox(height: 12),
          _InputField(
            labelMr: 'खरेदीदाराचा मोबाईल',
            labelEn: 'Buyer Mobile',
            controller: buyerMobileController,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.labelMr,
    required this.labelEn,
    required this.controller,
    this.prefix,
    this.keyboardType,
    this.onChanged,
  });

  final String labelMr;
  final String labelEn;
  final TextEditingController controller;
  final String? prefix;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: GirviColors.screenBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GirviColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$labelMr / $labelEn',
            style: const TextStyle(
              fontSize: 11,
              color: GirviColors.muted,
            ),
          ),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            onChanged: onChanged,
            decoration: InputDecoration(
              prefixText: prefix,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _SurplusCard extends StatelessWidget {
  const _SurplusCard({
    required this.saleAmount,
    required this.outstanding,
    required this.penalty,
    required this.surplus,
  });

  final double saleAmount;
  final double outstanding;
  final double penalty;
  final double surplus;

  @override
  Widget build(BuildContext context) {
    final isSurplus = surplus >= 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSurplus
            ? GirviColors.green.withAlpha(10)
            : GirviColors.red.withAlpha(10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSurplus
              ? GirviColors.green.withAlpha(40)
              : GirviColors.red.withAlpha(40),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isSurplus ? 'अधिक रक्कम / Surplus' : 'तूट रक्कम / Shortfall',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSurplus ? GirviColors.green : GirviColors.red,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '₹ ${surplus.abs().toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isSurplus ? GirviColors.green : GirviColors.red,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sale ₹${saleAmount.toStringAsFixed(2)} - Outstanding ₹${outstanding.toStringAsFixed(2)} - Penalty ₹${penalty.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 12,
              color: GirviColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}
