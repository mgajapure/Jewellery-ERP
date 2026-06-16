import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../theme/girvi_colors.dart';
import 'girvi_details_page.dart';

class CreateGirviWizardPage extends StatefulWidget {
  const CreateGirviWizardPage({super.key});

  static const routeName = 'create-girvi';

  @override
  State<CreateGirviWizardPage> createState() => _CreateGirviWizardPageState();
}

class _CreateGirviWizardPageState extends State<CreateGirviWizardPage> {
  int _currentStep = 0;

  final List<String> _stepLabels = const [
    'ग्राहक / Customer',
    'दागिने / Items',
    'फोटो / Photos',
    'मूल्य / Valuation',
    'कर्ज / Loan',
    'KFS',
    'वॉल्ट / Vault',
    'पुष्टी / Confirm',
  ];

  void _next() {
    if (_currentStep < _stepLabels.length - 1) {
      setState(() => _currentStep++);
    } else {
      context.goNamed(GirviDetailsPage.routeName);
    }
  }

  void _back() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GirviColors.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            _WizardHeader(
              titleMr: 'नवीन गिरवी',
              titleEn: 'New Girvi',
              stepLabel: _stepLabels[_currentStep],
              onBack: _back,
            ),
            _StepIndicator(
              currentStep: _currentStep,
              totalSteps: _stepLabels.length,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: IndexedStack(
                index: _currentStep,
                children: const [
                  _CustomerSelectionStep(),
                  _JewelleryEntryStep(),
                  _PhotoCaptureStep(),
                  _ValuationStep(),
                  _LoanTermsStep(),
                  _KfsPreviewStep(),
                  _VaultAssignmentStep(),
                  _SuccessStep(),
                ],
              ),
            ),
            _WizardFooter(
              isLastStep: _currentStep == _stepLabels.length - 1,
              onPrimary: _next,
              onSecondary: _back,
            ),
          ],
        ),
      ),
    );
  }
}

class _WizardHeader extends StatelessWidget {
  const _WizardHeader({
    required this.titleMr,
    required this.titleEn,
    required this.stepLabel,
    required this.onBack,
  });

  final String titleMr;
  final String titleEn;
  final String stepLabel;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 14, 18, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back, color: GirviColors.ink),
            tooltip: 'Back',
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  titleMr,
                  style: const TextStyle(
                    color: GirviColors.ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  '$titleEn • $stepLabel',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: GirviColors.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({
    required this.currentStep,
    required this.totalSteps,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(totalSteps, (index) {
          final isActive = index <= currentStep;
          final isCurrent = index == currentStep;
          return Expanded(
            child: Container(
              height: 5,
              margin: EdgeInsets.only(right: index < totalSteps - 1 ? 4 : 0),
              decoration: BoxDecoration(
                color: isActive ? GirviColors.navy : GirviColors.line,
                borderRadius: BorderRadius.circular(3),
              ),
              child: isCurrent
                  ? Container(
                      decoration: BoxDecoration(
                        color: GirviColors.gold,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    )
                  : null,
            ),
          );
        }),
      ),
    );
  }
}

class _WizardFooter extends StatelessWidget {
  const _WizardFooter({
    required this.isLastStep,
    required this.onPrimary,
    required this.onSecondary,
  });

  final bool isLastStep;
  final VoidCallback onPrimary;
  final VoidCallback onSecondary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: GirviColors.line)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onSecondary,
              style: OutlinedButton.styleFrom(
                foregroundColor: GirviColors.ink,
                side: const BorderSide(color: GirviColors.line),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'मागे / Back',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: onPrimary,
              style: ElevatedButton.styleFrom(
                backgroundColor: GirviColors.navy,
                foregroundColor: GirviColors.gold,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                isLastStep
                    ? 'गिरवी तयार करा / Create Girvi'
                    : 'पुढे / Continue',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomerSelectionStep extends StatelessWidget {
  const _CustomerSelectionStep();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      children: [
        const _SectionTitle(
          titleMr: 'ग्राहक निवडा',
          titleEn: 'Select Customer',
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: GirviColors.line),
          ),
          child: Row(
            children: const [
              Icon(Icons.search, color: GirviColors.muted),
              SizedBox(width: 12),
              Text(
                'नाव / मोबाईल / आयडी शोधा',
                style: TextStyle(
                  color: GirviColors.muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Icon(Icons.qr_code_scanner, color: GirviColors.muted),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: GirviColors.cream,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: GirviColors.gold.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: GirviColors.navy,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.qr_code_scanner,
                  color: GirviColors.gold,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'QR कोड स्कॅन करा',
                      style: TextStyle(
                        color: GirviColors.ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Scan Customer QR Code',
                      style: TextStyle(
                        color: GirviColors.muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: GirviColors.muted, size: 16),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const _SectionTitle(
          titleMr: 'अलीकडील ग्राहक',
          titleEn: 'Recent Customers',
        ),
        const SizedBox(height: 12),
        const _CustomerTile(
          name: 'सुरेश पाटील',
          nameEn: 'Suresh Patil',
          mobile: '+91 98765 43210',
          selected: true,
        ),
        const SizedBox(height: 10),
        const _CustomerTile(
          name: 'मीना जाधव',
          nameEn: 'Meena Jadhav',
          mobile: '+91 87654 32109',
        ),
        const SizedBox(height: 10),
        const _CustomerTile(
          name: 'अमोल देशमुख',
          nameEn: 'Amol Deshmukh',
          mobile: '+91 76543 21098',
        ),
      ],
    );
  }
}

class _CustomerTile extends StatelessWidget {
  const _CustomerTile({
    required this.name,
    required this.nameEn,
    required this.mobile,
    this.selected = false,
  });

  final String name;
  final String nameEn;
  final String mobile;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: selected ? GirviColors.navy : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected ? GirviColors.navy : GirviColors.line,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: selected
                  ? GirviColors.gold.withValues(alpha: 0.2)
                  : GirviColors.navy.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Icon(
              Icons.person,
              color: selected ? GirviColors.gold : GirviColors.navy,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: selected ? Colors.white : GirviColors.ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  nameEn,
                  style: TextStyle(
                    color: selected ? Colors.white70 : GirviColors.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  mobile,
                  style: TextStyle(
                    color: selected ? Colors.white70 : GirviColors.ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          if (selected)
            const Icon(Icons.check_circle, color: GirviColors.gold, size: 24),
        ],
      ),
    );
  }
}

class _JewelleryEntryStep extends StatefulWidget {
  const _JewelleryEntryStep();

  @override
  State<_JewelleryEntryStep> createState() => _JewelleryEntryStepState();
}

class _JewelleryEntryStepState extends State<_JewelleryEntryStep> {
  String _itemType = 'Chain';
  String _purity = '22K';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      children: [
        const _SectionTitle(
          titleMr: 'दागिन्याची माहिती',
          titleEn: 'Jewellery Details',
        ),
        const SizedBox(height: 12),
        _DropdownField(
          label: 'वस्तूचा प्रकार / Item Type',
          value: _itemType,
          items: const [
            'Ring',
            'Chain',
            'Necklace',
            'Mangalsutra',
            'Bangle',
            'Bracelet',
            'Pendant',
            'Coin',
            'Bar',
            'Custom',
          ],
          onChanged: (value) => setState(() => _itemType = value!),
        ),
        const SizedBox(height: 14),
        _AppTextField(
          label: 'वर्णन / Description',
          hint: 'उदा. 22K सोन्याची चेन',
          prefixIcon: Icons.description_outlined,
        ),
        const SizedBox(height: 14),
        Row(
          children: const [
            Expanded(
              child: _AppTextField(
                label: 'प्रमाण / Quantity',
                hint: '1',
                prefixIcon: Icons.numbers_outlined,
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _AppTextField(
                label: 'एकूण वजन (g) / Gross Wt',
                hint: '12.50',
                prefixIcon: Icons.scale_outlined,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: const [
            Expanded(
              child: _AppTextField(
                label: 'दगड वजन (g) / Stone Wt',
                hint: '0.00',
                prefixIcon: Icons.diamond_outlined,
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _AppTextField(
                label: 'निव्वळ वजन (g) / Net Wt',
                hint: '12.50',
                prefixIcon: Icons.scale_outlined,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _DropdownField(
          label: 'शुद्धता / Purity',
          value: _purity,
          items: const ['18K', '20K', '22K', '24K'],
          onChanged: (value) => setState(() => _purity = value!),
        ),
      ],
    );
  }
}

class _PhotoCaptureStep extends StatelessWidget {
  const _PhotoCaptureStep();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      children: [
        const _SectionTitle(
          titleMr: 'वस्तूंचे फोटो',
          titleEn: 'Item Photos',
        ),
        const SizedBox(height: 8),
        const Text(
          'किमान 1 फोटो आवश्यक / Minimum 1 photo required',
          style: TextStyle(
            color: GirviColors.muted,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _PhotoPlaceholder(
              icon: Icons.add_a_photo_outlined,
              label: 'समोर / Front',
            ),
            _PhotoPlaceholder(
              icon: Icons.add_a_photo_outlined,
              label: 'मागे / Back',
            ),
            _PhotoPlaceholder(
              icon: Icons.add_a_photo_outlined,
              label: 'वजन / Weight',
            ),
          ],
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: GirviColors.cream,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: GirviColors.gold.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: const [
              Icon(Icons.info_outline, color: GirviColors.gold),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'प्रत्येक वस्तूसाठी किमान 1 फोटो काढा. फोटो 400 KB पेक्षा कमी असावेत.',
                  style: TextStyle(
                    color: GirviColors.ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GirviColors.line),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: GirviColors.navy, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: GirviColors.muted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ValuationStep extends StatelessWidget {
  const _ValuationStep();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      children: [
        const _SectionTitle(
          titleMr: 'मूल्यांकन आणि LTV',
          titleEn: 'Valuation & LTV',
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: GirviColors.navy,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'आजचा सोन्याचा दर / Gold Rate Today',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: const [
                  Text(
                    '₹71,850',
                    style: TextStyle(
                      color: GirviColors.gold,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'प्रति 10 ग्रॅम / 10g',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'स्रोत: MCX',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: GirviColors.line),
          ),
          child: Column(
            children: const [
              _ValuationRow(label: 'Fine Gold Weight', value: '11.46 g'),
              _ValuationRow(label: 'Gross Valuation', value: '₹82,300'),
              _ValuationRow(label: 'Max Loan (75% LTV)', value: '₹61,725'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _AppTextField(
          label: 'कर्ज रक्कम / Loan Amount',
          hint: 'Enter amount within LTV limit',
          prefixIcon: Icons.currency_rupee,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: GirviColors.green.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: GirviColors.green.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: const [
              Icon(Icons.check_circle, color: GirviColors.green, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'LTV 78.5% — RBI मर्यादेत आहे / Within RBI limit',
                  style: TextStyle(
                    color: GirviColors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ValuationRow extends StatelessWidget {
  const _ValuationRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: GirviColors.muted,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: GirviColors.ink,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoanTermsStep extends StatefulWidget {
  const _LoanTermsStep();

  @override
  State<_LoanTermsStep> createState() => _LoanTermsStepState();
}

class _LoanTermsStepState extends State<_LoanTermsStep> {
  String _interestType = 'Simple';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      children: [
        const _SectionTitle(
          titleMr: 'कर्जाचे अटी',
          titleEn: 'Loan Terms',
        ),
        const SizedBox(height: 12),
        _AppTextField(
          label: 'कर्ज रक्कम / Loan Amount',
          hint: '₹75,000',
          prefixIcon: Icons.currency_rupee,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 14),
        _DropdownField(
          label: 'व्याज प्रकार / Interest Type',
          value: _interestType,
          items: const ['Simple', 'Katmiti', 'Daily'],
          onChanged: (value) => setState(() => _interestType = value!),
        ),
        const SizedBox(height: 14),
        _AppTextField(
          label: 'व्याज दर (%) / Interest Rate',
          hint: '18',
          prefixIcon: Icons.percent,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 14),
        Row(
          children: const [
            Expanded(
              child: _AppTextField(
                label: 'सुरवात तारीख / Start Date',
                hint: '14 Jun 2026',
                prefixIcon: Icons.calendar_today_outlined,
                readOnly: true,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _AppTextField(
                label: 'देय तारीख / Due Date',
                hint: '15 Jul 2026',
                prefixIcon: Icons.event_outlined,
                readOnly: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _AppTextField(
          label: 'दंड व्याज दर (%) / Penalty Rate',
          hint: '2',
          prefixIcon: Icons.warning_amber_outlined,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}

class _KfsPreviewStep extends StatelessWidget {
  const _KfsPreviewStep();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      children: [
        const _SectionTitle(
          titleMr: 'Key Fact Statement',
          titleEn: 'KFS Preview',
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: GirviColors.line),
          ),
          child: Column(
            children: const [
              _KfsRow(label: 'मुद्दल / Principal', value: '₹75,000'),
              _KfsDivider(),
              _KfsRow(label: 'व्याज दर / Interest Rate', value: '18% p.a.'),
              _KfsDivider(),
              _KfsRow(label: 'APR', value: '18%'),
              _KfsDivider(),
              _KfsRow(label: 'एकूण परतफेड / Total Payable', value: '₹82,450'),
              _KfsDivider(),
              _KfsRow(label: 'कर्जाची कालावधी / Tenure', value: '31 दिवस / Days'),
              _KfsDivider(),
              _KfsRow(label: 'दंड व्याज / Penalty', value: '2% प्रति महिना'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: GirviColors.cream,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: GirviColors.gold.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'लिलाव नियम / Auction Rules',
                style: TextStyle(
                  color: GirviColors.ink,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 6),
              Text(
                '• 14 दिवसांची सूचना दिल्यानंतर लिलाव करता येईल.',
                style: TextStyle(
                  color: GirviColors.muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '• सोने परत करण्यासाठी 7 कामकाजाचे दिवस.',
                style: TextStyle(
                  color: GirviColors.muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Checkbox(value: false, onChanged: (_) {}),
            const Expanded(
              child: Text(
                'मी KFS वाचले आणि सहमत आहे / I have read and agree to the KFS',
                style: TextStyle(
                  color: GirviColors.ink,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _KfsRow extends StatelessWidget {
  const _KfsRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: GirviColors.muted,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: GirviColors.ink,
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _KfsDivider extends StatelessWidget {
  const _KfsDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Divider(height: 1, color: GirviColors.line),
    );
  }
}

class _VaultAssignmentStep extends StatelessWidget {
  const _VaultAssignmentStep();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      children: [
        const _SectionTitle(
          titleMr: 'वॉल्ट नियुक्ती',
          titleEn: 'Vault Assignment',
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: GirviColors.navy,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: const [
              Icon(Icons.lock_outline, color: GirviColors.gold, size: 28),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'सूचित वॉल्ट / Suggested Vault',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'VA-A/SF-02/TR-05/SL-18',
                      style: TextStyle(
                        color: GirviColors.gold,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: GirviColors.line),
          ),
          child: Column(
            children: [
              _VaultDropdown(label: 'वॉल्ट / Vault', value: 'Vault A'),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: _VaultDropdown(label: 'सेफ / Safe', value: 'SF-02')),
                  const SizedBox(width: 12),
                  Expanded(child: _VaultDropdown(label: 'ट्रे / Tray', value: 'TR-05')),
                ],
              ),
              const SizedBox(height: 14),
              _VaultDropdown(label: 'स्लॉट / Slot', value: 'SL-18'),
            ],
          ),
        ),
      ],
    );
  }
}

class _VaultDropdown extends StatelessWidget {
  const _VaultDropdown({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: GirviColors.ink,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: GirviColors.screenBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: GirviColors.line),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: GirviColors.muted),
              items: [
                DropdownMenuItem(value: value, child: Text(value)),
              ],
              onChanged: (_) {},
            ),
          ),
        ),
      ],
    );
  }
}

class _SuccessStep extends StatelessWidget {
  const _SuccessStep();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: GirviColors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(45),
            ),
            child: const Icon(
              Icons.check_circle,
              color: GirviColors.green,
              size: 56,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'गिरवी तयार झाली',
            style: TextStyle(
              color: GirviColors.ink,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Girvi Created Successfully',
            style: TextStyle(
              color: GirviColors.muted,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: GirviColors.line),
            ),
            child: Column(
              children: const [
                _SuccessRow(label: 'Serial ID', value: 'GRV-2026-000522'),
                _SuccessRow(label: 'Customer', value: 'Suresh Patil'),
                _SuccessRow(label: 'Loan Amount', value: '₹75,000'),
                _SuccessRow(label: 'Due Date', value: '15 Jul 2026'),
                _SuccessRow(label: 'Vault', value: 'VA-A/SF-02/TR-05/SL-18'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessRow extends StatelessWidget {
  const _SuccessRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: GirviColors.muted,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: GirviColors.ink,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
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
            color: GirviColors.ink,
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          titleEn,
          style: const TextStyle(
            color: GirviColors.muted,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _AppTextField extends StatelessWidget {
  const _AppTextField({
    this.controller,
    required this.label,
    required this.hint,
    this.prefixIcon,
    this.keyboardType,
    this.inputFormatters,
    this.maxLength,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
  });

  final TextEditingController? controller;
  final String label;
  final String hint;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: GirviColors.ink,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hint,
            hintStyle: const TextStyle(
              color: GirviColors.muted,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: GirviColors.muted, size: 22)
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: GirviColors.line),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: GirviColors.line),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: GirviColors.navy, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
            counterText: '',
          ),
        ),
      ],
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: GirviColors.ink,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: GirviColors.line),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: GirviColors.muted),
              items: items
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
