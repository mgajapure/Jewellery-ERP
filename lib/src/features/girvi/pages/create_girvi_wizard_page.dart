import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../core/di/injection.dart';
import '../../../core/navigation/app_navigation.dart';
import '../../../core/widgets/bilingual_text.dart';
import '../domain/entities/girvi.dart';
import '../domain/repositories/girvi_repository.dart';
import '../presentation/bloc/create_girvi_bloc.dart';
import '../presentation/bloc/create_girvi_event.dart';
import '../presentation/bloc/create_girvi_state.dart';
import '../theme/girvi_colors.dart';
import 'girvi_list_page.dart';

final _currencyFmt = NumberFormat.currency(locale: 'hi_IN', symbol: '₹', decimalDigits: 0);

class CreateGirviWizardPage extends StatelessWidget {
  const CreateGirviWizardPage({super.key});

  static const routeName = 'create-girvi';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateGirviBloc(repository: getIt<GirviRepository>()),
      child: const _WizardView(),
    );
  }
}

// ─── Wizard shell ────────────────────────────────────────────────────────────

class _WizardView extends StatefulWidget {
  const _WizardView();

  @override
  State<_WizardView> createState() => _WizardViewState();
}

class _WizardViewState extends State<_WizardView> {
  int _currentStep = 0;
  Girvi? _createdGirvi;

  static const _shortLabels = ['ग्राहक', 'दागिने', 'फोटो', 'मूल्य', 'कर्ज', 'KFS', 'वॉल्ट', '✓'];
  static const _stepLabels = [
    'ग्राहक / Customer',
    'दागिने / Items',
    'फोटो / Photos',
    'मूल्य / Valuation',
    'कर्ज / Loan Terms',
    'KFS Preview',
    'वॉल्ट / Vault',
    'यशस्वी / Done',
  ];

  void _advance() => setState(() => _currentStep++);

  void _next(CreateGirviDraft draft) {
    if (_currentStep == 6) {
      context.read<CreateGirviBloc>().add(const CreateGirviSubmitted());
    } else if (_currentStep == 7) {
      context.goNamed(GirviListPage.routeName);
    } else {
      _advance();
    }
  }

  void _back() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      AppNavigation.popOrGoNamed(context, GirviListPage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateGirviBloc, CreateGirviState>(
      listener: (context, state) {
        if (state is CreateGirviSuccess) {
          setState(() {
            _createdGirvi = state.girvi;
            _currentStep = 7;
          });
        } else if (state is CreateGirviError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.shade700,
            ),
          );
        }
      },
      builder: (context, state) {
        final draft = switch (state) {
          CreateGirviDraft d => d,
          CreateGirviSubmitting s => s.draft,
          CreateGirviError e => e.draft,
          _ => CreateGirviDraft(
              startDate: DateTime.now(),
              dueDate: DateTime.now().add(const Duration(days: 30)),
            ),
        };
        final isSubmitting = state is CreateGirviSubmitting;

        return Scaffold(
          backgroundColor: GirviColors.screenBg,
          body: SafeArea(
            child: Column(
              children: [
                _WizardHeader(
                  stepLabel: _stepLabels[_currentStep],
                  onBack: _back,
                ),
                _CircleStepIndicator(
                  currentStep: _currentStep,
                  shortLabels: _shortLabels,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: IndexedStack(
                    index: _currentStep,
                    children: [
                      _CustomerSelectionStep(draft: draft),
                      _ItemsStep(draft: draft),
                      _PhotosStep(draft: draft),
                      _ValuationStep(draft: draft),
                      _LoanTermsStep(draft: draft),
                      _KfsPreviewStep(draft: draft),
                      _VaultAssignmentStep(draft: draft),
                      _SuccessStep(girvi: _createdGirvi),
                    ],
                  ),
                ),
                _WizardFooter(
                  currentStep: _currentStep,
                  isSubmitting: isSubmitting,
                  onPrimary: () => _next(draft),
                  onSecondary: _back,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

class _WizardHeader extends StatelessWidget {
  const _WizardHeader({required this.stepLabel, required this.onBack});

  final String stepLabel;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(4, 10, 16, 10),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back, color: GirviColors.ink),
          ),
          Expanded(
            child: Column(
              children: [
                const BilingualText(
                  en: 'New Girvi',
                  mr: 'नवीन गिरवी',
                  hi: 'नई गिरवी',
                  style: TextStyle(
                    color: GirviColors.ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  stepLabel,
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

// ─── Circle step indicator ────────────────────────────────────────────────────

class _CircleStepIndicator extends StatelessWidget {
  const _CircleStepIndicator({
    required this.currentStep,
    required this.shortLabels,
  });

  final int currentStep;
  final List<String> shortLabels;

  @override
  Widget build(BuildContext context) {
    final total = shortLabels.length;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Row(
        children: List.generate(total * 2 - 1, (idx) {
          if (idx.isOdd) {
            final stepIndex = idx ~/ 2 + 1;
            final lineComplete = stepIndex <= currentStep;
            return Expanded(
              child: Container(
                height: 2,
                color: lineComplete ? GirviColors.navy : GirviColors.line,
              ),
            );
          }
          final i = idx ~/ 2;
          final isDone = i < currentStep;
          final isCurrent = i == currentStep;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone
                      ? GirviColors.navy
                      : isCurrent
                          ? GirviColors.gold
                          : Colors.white,
                  border: Border.all(
                    color: isDone
                        ? GirviColors.navy
                        : isCurrent
                            ? GirviColors.gold
                            : GirviColors.line,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: isDone
                      ? const Icon(Icons.check, size: 13, color: Colors.white)
                      : Text(
                          '${i + 1}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: isCurrent ? GirviColors.ink : GirviColors.muted,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                shortLabels[i],
                style: TextStyle(
                  fontSize: 7,
                  fontWeight: isCurrent ? FontWeight.w900 : FontWeight.w600,
                  color: isCurrent ? GirviColors.ink : GirviColors.muted,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// ─── Footer ───────────────────────────────────────────────────────────────────

class _WizardFooter extends StatelessWidget {
  const _WizardFooter({
    required this.currentStep,
    required this.isSubmitting,
    required this.onPrimary,
    required this.onSecondary,
  });

  final int currentStep;
  final bool isSubmitting;
  final VoidCallback onPrimary;
  final VoidCallback onSecondary;

  Widget get _primaryLabelWidget {
    if (isSubmitting) {
      return const BilingualText(
        en: 'Processing...',
        mr: 'प्रक्रिया सुरू...',
        hi: 'प्रक्रिया जारी...',
        style: TextStyle(fontWeight: FontWeight.w800),
      );
    }
    if (currentStep == 6) {
      return const BilingualText(
        en: 'Create',
        mr: 'गिरवी तयार करा',
        hi: 'गिरवी बनाएं',
        style: TextStyle(fontWeight: FontWeight.w800),
        textAlign: TextAlign.center,
      );
    }
    if (currentStep == 7) {
      return const BilingualText(
        en: 'Done',
        mr: 'गिरवी यादी',
        hi: 'गिरवी सूची',
        style: TextStyle(fontWeight: FontWeight.w800),
        textAlign: TextAlign.center,
      );
    }
    return const BilingualText(
      en: 'Continue',
      mr: 'पुढे',
      hi: 'आगे',
      style: TextStyle(fontWeight: FontWeight.w800),
      textAlign: TextAlign.center,
    );
  }

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
          if (currentStep > 0 && currentStep < 7)
            Expanded(
              child: OutlinedButton(
                onPressed: isSubmitting ? null : onSecondary,
                style: OutlinedButton.styleFrom(
                  foregroundColor: GirviColors.ink,
                  side: const BorderSide(color: GirviColors.line),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const BilingualText(
                  en: 'Back',
                  mr: 'मागे',
                  hi: 'पिछला',
                  style: TextStyle(fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          if (currentStep > 0 && currentStep < 7) const SizedBox(width: 12),
          Expanded(
            flex: currentStep == 0 || currentStep == 7 ? 1 : 2,
            child: ElevatedButton(
              onPressed: isSubmitting ? null : onPrimary,
              style: ElevatedButton.styleFrom(
                backgroundColor: GirviColors.navy,
                foregroundColor: GirviColors.gold,
                disabledBackgroundColor: GirviColors.navy.withValues(alpha: 0.5),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: GirviColors.gold),
                    )
                  : _primaryLabelWidget,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Step 1: Customer selection ───────────────────────────────────────────────

class _CustomerSelectionStep extends StatefulWidget {
  const _CustomerSelectionStep({required this.draft});

  final CreateGirviDraft draft;

  @override
  State<_CustomerSelectionStep> createState() => _CustomerSelectionStepState();
}

class _CustomerSelectionStepState extends State<_CustomerSelectionStep> {
  static const _mockCustomers = [
    ('cust-001', 'सुरेश पाटील', 'Suresh Patil', '+91 98765 43210'),
    ('cust-002', 'मीना जाधव', 'Meena Jadhav', '+91 87654 32109'),
    ('cust-003', 'अमोल देशमुख', 'Amol Deshmukh', '+91 76543 21098'),
    ('cust-004', 'प्रिया शिंदे', 'Priya Shinde', '+91 65432 10987'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      children: [
        const _SectionTitle(titleMr: 'ग्राहक निवडा', titleEn: 'Select Customer'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: GirviColors.line),
          ),
          child: const Row(
            children: [
              Icon(Icons.search, color: GirviColors.muted),
              SizedBox(width: 12),
              BilingualText(
                en: 'Name / Mobile / ID Search',
                mr: 'नाव / मोबाईल / आयडी शोधा',
                hi: 'नाम / मोबाइल / आईडी खोजें',
                style: TextStyle(color: GirviColors.muted, fontWeight: FontWeight.w600),
              ),
              Spacer(),
              Icon(Icons.qr_code_scanner, color: GirviColors.muted),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const _SectionTitle(titleMr: 'अलीकडील ग्राहक', titleEn: 'Recent Customers'),
        const SizedBox(height: 12),
        for (final (id, name, nameEn, mobile) in _mockCustomers) ...[
          _CustomerTile(
            customerId: id,
            name: name,
            nameEn: nameEn,
            mobile: mobile,
            selected: widget.draft.customerId == id,
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _CustomerTile extends StatelessWidget {
  const _CustomerTile({
    required this.customerId,
    required this.name,
    required this.nameEn,
    required this.mobile,
    this.selected = false,
  });

  final String customerId;
  final String name;
  final String nameEn;
  final String mobile;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<CreateGirviBloc>().add(
        CreateGirviCustomerSelected(
          customerId: customerId,
          customerName: name,
          customerNameEn: nameEn,
          customerMobile: mobile,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? GirviColors.navy : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? GirviColors.navy : GirviColors.line),
          boxShadow: const [BoxShadow(color: Color(0x10000000), blurRadius: 8, offset: Offset(0, 3))],
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
              child: Icon(Icons.person, color: selected ? GirviColors.gold : GirviColors.navy, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: TextStyle(
                          color: selected ? Colors.white : GirviColors.ink,
                          fontSize: 14,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 2),
                  Text(nameEn,
                      style: TextStyle(
                          color: selected ? Colors.white70 : GirviColors.muted,
                          fontSize: 11,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(mobile,
                      style: TextStyle(
                          color: selected ? Colors.white70 : GirviColors.ink,
                          fontSize: 12,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            if (selected) const Icon(Icons.check_circle, color: GirviColors.gold, size: 24),
          ],
        ),
      ),
    );
  }
}

// ─── Step 2: Items ────────────────────────────────────────────────────────────

class _ItemsStep extends StatelessWidget {
  const _ItemsStep({required this.draft});

  final CreateGirviDraft draft;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      children: [
        Row(
          children: [
            const Expanded(
              child: _SectionTitle(titleMr: 'दागिने', titleEn: 'Jewellery Items'),
            ),
            FilledButton.icon(
              onPressed: () => context.read<CreateGirviBloc>().add(const CreateGirviItemAdded()),
              icon: const Icon(Icons.add, size: 18),
              label: const BilingualText(
                en: 'Item',
                mr: 'वस्तू',
                hi: 'वस्तु',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: GirviColors.navy,
                foregroundColor: GirviColors.gold,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (draft.items.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: GirviColors.line),
            ),
            child: Column(
              children: [
                Icon(Icons.diamond_outlined, size: 48, color: GirviColors.muted.withValues(alpha: 0.5)),
                const SizedBox(height: 12),
                const BilingualText(
                  en: 'No items added yet',
                  mr: 'कोणतीही वस्तू नाही',
                  hi: 'कोई वस्तु नहीं जोड़ी गई',
                  style: TextStyle(color: GirviColors.muted, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => context.read<CreateGirviBloc>().add(const CreateGirviItemAdded()),
                  icon: const Icon(Icons.add),
                  label: const BilingualText(
                    en: 'Add First Item',
                    mr: 'पहिली वस्तू जोडा',
                    hi: 'पहली वस्तु जोड़ें',
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: GirviColors.navy,
                    side: const BorderSide(color: GirviColors.navy),
                  ),
                ),
              ],
            ),
          )
        else
          for (int i = 0; i < draft.items.length; i++) ...[
            _ItemCard(item: draft.items[i], index: i),
            const SizedBox(height: 12),
          ],
      ],
    );
  }
}

class _ItemCard extends StatefulWidget {
  const _ItemCard({required this.item, required this.index});

  final GirviItemDraft item;
  final int index;

  @override
  State<_ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<_ItemCard> {
  bool _expanded = true;
  late TextEditingController _descCtrl;
  late TextEditingController _qtyCtrl;
  late TextEditingController _grossCtrl;
  late TextEditingController _stoneCtrl;
  String _itemType = 'Chain';
  String _purity = '22K';
  MetalType _metalType = MetalType.gold;

  static const _itemTypes = ['Ring', 'Chain', 'Necklace', 'Mangalsutra', 'Bangle', 'Bracelet', 'Pendant', 'Coin', 'Bar', 'Custom'];
  static const _purities = ['18K', '20K', '22K', '24K'];
  static const _metalTypes = [MetalType.gold, MetalType.silver, MetalType.platinum, MetalType.other];
  static const _metalLabels = ['Gold', 'Silver', 'Platinum', 'Other'];

  @override
  void initState() {
    super.initState();
    _descCtrl = TextEditingController(text: widget.item.description);
    _qtyCtrl = TextEditingController(text: widget.item.quantity == 1 ? '1' : '${widget.item.quantity}');
    _grossCtrl = TextEditingController(text: widget.item.grossWeightG == 0 ? '' : widget.item.grossWeightG.toStringAsFixed(2));
    _stoneCtrl = TextEditingController(text: widget.item.stoneWeightG == 0 ? '' : widget.item.stoneWeightG.toStringAsFixed(2));
    _itemType = widget.item.itemType;
    _purity = widget.item.purity;
    _metalType = widget.item.metalType;
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    _qtyCtrl.dispose();
    _grossCtrl.dispose();
    _stoneCtrl.dispose();
    super.dispose();
  }

  void _sync() {
    final gross = double.tryParse(_grossCtrl.text) ?? 0.0;
    final stone = double.tryParse(_stoneCtrl.text) ?? 0.0;
    context.read<CreateGirviBloc>().add(
      CreateGirviItemUpdated(widget.item.copyWith(
        itemType: _itemType,
        description: _descCtrl.text,
        quantity: int.tryParse(_qtyCtrl.text) ?? 1,
        grossWeightG: gross,
        stoneWeightG: stone,
        purity: _purity,
        metalType: _metalType,
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final netWt = (double.tryParse(_grossCtrl.text) ?? 0.0) - (double.tryParse(_stoneCtrl.text) ?? 0.0);
    final displayNet = netWt.clamp(0.0, double.infinity);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GirviColors.line),
      ),
      child: Column(
        children: [
          // Card header (always visible)
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: GirviColors.navy.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${widget.index + 1}',
                        style: const TextStyle(
                          color: GirviColors.navy,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _itemType,
                          style: const TextStyle(
                              color: GirviColors.ink, fontWeight: FontWeight.w900, fontSize: 13),
                        ),
                        if (_descCtrl.text.isNotEmpty)
                          Text(_descCtrl.text,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: GirviColors.muted, fontSize: 11)),
                      ],
                    ),
                  ),
                  Text(
                    '${displayNet.toStringAsFixed(1)}g • $_purity',
                    style: const TextStyle(color: GirviColors.muted, fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(width: 8),
                  Icon(_expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: GirviColors.muted),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            const Divider(height: 1, color: GirviColors.line),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _DropdownField(
                    label: 'वस्तूचा प्रकार / Item Type',
                    value: _itemType,
                    items: _itemTypes,
                    onChanged: (v) {
                      setState(() => _itemType = v!);
                      _sync();
                    },
                  ),
                  const SizedBox(height: 12),
                  _AppTextField(
                    controller: _descCtrl,
                    label: 'वर्णन / Description',
                    hint: 'उदा. 22K सोन्याची चेन',
                    prefixIcon: Icons.description_outlined,
                    onChanged: (_) {},
                    onEditingComplete: _sync,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _AppTextField(
                          controller: _qtyCtrl,
                          label: 'प्रमाण / Qty',
                          hint: '1',
                          prefixIcon: Icons.numbers_outlined,
                          keyboardType: TextInputType.number,
                          onChanged: (_) => _sync(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _DropdownField(
                          label: 'शुद्धता / Purity',
                          value: _purity,
                          items: _purities,
                          onChanged: (v) {
                            setState(() => _purity = v!);
                            _sync();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _AppTextField(
                          controller: _grossCtrl,
                          label: 'एकूण वजन (g)',
                          hint: '12.50',
                          prefixIcon: Icons.scale_outlined,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (_) {
                            setState(() {}); // refresh net weight display
                            _sync();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _AppTextField(
                          controller: _stoneCtrl,
                          label: 'दगड वजन (g)',
                          hint: '0.00',
                          prefixIcon: Icons.diamond_outlined,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (_) {
                            setState(() {});
                            _sync();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: GirviColors.screenBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: GirviColors.line),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.scale_outlined, color: GirviColors.navy, size: 18),
                        const SizedBox(width: 10),
                        BilingualText(
                          en: 'Net Weight: ${displayNet.toStringAsFixed(2)} g',
                          mr: 'निव्वळ वजन: ${displayNet.toStringAsFixed(2)} g',
                          hi: 'निवल वजन: ${displayNet.toStringAsFixed(2)} g',
                          style: const TextStyle(
                              color: GirviColors.navy, fontWeight: FontWeight.w800, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Metal type selection
                  Row(
                    children: List.generate(_metalTypes.length, (i) {
                      final selected = _metalType == _metalTypes[i];
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _metalType = _metalTypes[i]);
                            _sync();
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: i < _metalTypes.length - 1 ? 6 : 0),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: selected ? GirviColors.navy : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: selected ? GirviColors.navy : GirviColors.line),
                            ),
                            child: Text(
                              _metalLabels[i],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: selected ? GirviColors.gold : GirviColors.muted,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 14),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => context.read<CreateGirviBloc>().add(
                        CreateGirviItemRemoved(widget.item.id),
                      ),
                      icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                      label: const BilingualText(
                          en: 'Remove',
                          mr: 'वस्तू काढा',
                          hi: 'हटाएं',
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700, fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Step 3: Photos per item ──────────────────────────────────────────────────

class _PhotosStep extends StatelessWidget {
  const _PhotosStep({required this.draft});

  final CreateGirviDraft draft;

  @override
  Widget build(BuildContext context) {
    if (draft.items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.photo_library_outlined, size: 56, color: GirviColors.muted.withValues(alpha: 0.4)),
              const SizedBox(height: 16),
              const BilingualText(
                en: 'Add items in the previous step first',
                mr: 'आधी दागिने जोडा',
                hi: 'पहले पिछले चरण में वस्तुएं जोड़ें',
                style: TextStyle(color: GirviColors.muted, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      children: [
        const _SectionTitle(titleMr: 'प्रत्येक वस्तूचे फोटो', titleEn: 'Photos Per Item'),
        const SizedBox(height: 4),
        const BilingualText(
          en: 'Minimum 3 photos per item',
          mr: 'प्रत्येक वस्तूसाठी किमान 3 फोटो',
          hi: 'प्रत्येक वस्तु के लिए न्यूनतम 3 फोटो',
          style: TextStyle(color: GirviColors.muted, fontSize: 12, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        for (final item in draft.items) ...[
          _ItemPhotoSection(item: item),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}

class _ItemPhotoSection extends StatelessWidget {
  const _ItemPhotoSection({required this.item});

  final GirviItemDraft item;

  static const _slotLabels = ['समोर / Front', 'मागे / Back', 'वजन / Weight'];

  Future<void> _pickPhoto(BuildContext context, String itemId) async {
    final action = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetCtx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: GirviColors.line, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, color: GirviColors.navy),
              title: const BilingualText(
                en: 'Camera',
                mr: 'कॅमेरा',
                hi: 'कैमरा',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              onTap: () => Navigator.pop(sheetCtx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: GirviColors.navy),
              title: const BilingualText(
                en: 'Gallery',
                mr: 'गॅलरी',
                hi: 'गैलरी',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              onTap: () => Navigator.pop(sheetCtx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (action == null) return;

    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(source: action, imageQuality: 70, maxWidth: 1080);
      if (file != null && context.mounted) {
        context.read<CreateGirviBloc>().add(
          CreateGirviItemPhotoAdded(itemId: itemId, photoPath: file.path),
        );
      }
    } catch (_) {
      // Camera not available in emulator / test env — use mock path
      if (context.mounted) {
        context.read<CreateGirviBloc>().add(
          CreateGirviItemPhotoAdded(
            itemId: itemId,
            photoPath: 'mock://photo-${DateTime.now().millisecondsSinceEpoch}.jpg',
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final photoCount = item.photoPaths.length;
    final minRequired = 3;
    final hasEnough = photoCount >= minRequired;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasEnough ? GirviColors.green.withValues(alpha: 0.4) : GirviColors.line,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.description.isEmpty ? item.itemType : item.description,
                    style: const TextStyle(
                        color: GirviColors.ink, fontWeight: FontWeight.w900, fontSize: 13),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: hasEnough
                        ? GirviColors.green.withValues(alpha: 0.1)
                        : GirviColors.gold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$photoCount / $minRequired+',
                    style: TextStyle(
                      color: hasEnough ? GirviColors.green : GirviColors.gold,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Column(
              children: [
                // First row: 3 required slots
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: minRequired,
                  itemBuilder: (ctx, i) {
                    final hasPhoto = i < photoCount;
                    final path = hasPhoto ? item.photoPaths[i] : null;
                    return _PhotoSlot(
                      label: i < _slotLabels.length ? _slotLabels[i] : 'अतिरिक्त ${i + 1}',
                      photoPath: path,
                      required: true,
                      onTap: hasPhoto ? null : () => _pickPhoto(ctx, item.id),
                      onDelete: hasPhoto
                          ? () => ctx.read<CreateGirviBloc>().add(
                                CreateGirviItemPhotoRemoved(itemId: item.id, photoIndex: i),
                              )
                          : null,
                    );
                  },
                ),
                // Extra photos beyond 3
                if (photoCount > minRequired) ...[
                  const SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: photoCount - minRequired,
                    itemBuilder: (ctx, i) {
                      final photoIndex = i + minRequired;
                      return _PhotoSlot(
                        label: 'अतिरिक्त ${i + 1}',
                        photoPath: item.photoPaths[photoIndex],
                        onDelete: () => ctx.read<CreateGirviBloc>().add(
                          CreateGirviItemPhotoRemoved(itemId: item.id, photoIndex: photoIndex),
                        ),
                      );
                    },
                  ),
                ],
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _pickPhoto(context, item.id),
                    icon: const Icon(Icons.add_a_photo_outlined, size: 18),
                    label: const BilingualText(
                      en: 'Add Photo',
                      mr: 'फोटो जोडा',
                      hi: 'फोटो जोड़ें',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: GirviColors.navy,
                      side: const BorderSide(color: GirviColors.navy),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoSlot extends StatelessWidget {
  const _PhotoSlot({
    required this.label,
    this.photoPath,
    this.required = false,
    this.onTap,
    this.onDelete,
  });

  final String label;
  final String? photoPath;
  final bool required;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  bool get _isMockPath => photoPath?.startsWith('mock://') ?? false;
  bool get _isFilePath => photoPath != null && !_isMockPath;

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoPath != null;

    return Stack(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: hasPhoto ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: hasPhoto
                    ? GirviColors.green.withValues(alpha: 0.5)
                    : required
                        ? GirviColors.gold.withValues(alpha: 0.5)
                        : GirviColors.line,
                width: required && !hasPhoto ? 1.5 : 1,
              ),
            ),
            child: hasPhoto
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: _isFilePath
                        ? Image.file(File(photoPath!), fit: BoxFit.cover, width: double.infinity, height: double.infinity)
                        : Container(
                            color: GirviColors.green.withValues(alpha: 0.15),
                            child: const Center(
                              child: Icon(Icons.check_circle, color: GirviColors.green, size: 36),
                            ),
                          ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo_outlined,
                          color: required ? GirviColors.gold : GirviColors.muted, size: 26),
                      const SizedBox(height: 4),
                      Text(
                        label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: required ? GirviColors.gold : GirviColors.muted,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        if (hasPhoto && onDelete != null)
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: onDelete,
              child: Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 14),
              ),
            ),
          ),
      ],
    );
  }
}

// ─── Step 4: Valuation & LTV chips ───────────────────────────────────────────

class _ValuationStep extends StatelessWidget {
  const _ValuationStep({required this.draft});

  final CreateGirviDraft draft;

  static const _ltvOptions = [50.0, 60.0, 65.0, 70.0, 75.0];

  @override
  Widget build(BuildContext context) {
    final valuation = draft.totalValuation;
    final goldRate10g = draft.goldRatePerGram * 10;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      children: [
        const _SectionTitle(titleMr: 'मूल्यांकन आणि LTV', titleEn: 'Valuation & LTV'),
        const SizedBox(height: 12),

        // Gold rate card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: GirviColors.navy,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BilingualText(
                en: 'Gold Rate Today',
                mr: 'आजचा सोन्याचा दर',
                hi: 'आज का सोने का भाव',
                style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    _currencyFmt.format(goldRate10g),
                    style: const TextStyle(color: GirviColors.gold, fontSize: 24, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(width: 10),
                  const BilingualText(
                    en: 'per 10g',
                    mr: 'प्रति 10 ग्रॅम',
                    hi: 'प्रति 10 ग्राम',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const BilingualText(
                en: 'Source: MCX (mock)',
                mr: 'स्रोत: MCX (mock)',
                hi: 'स्रोत: MCX (mock)',
                style: TextStyle(color: Colors.white54, fontSize: 11),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Item breakdown
        if (draft.items.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: GirviColors.line),
            ),
            child: Column(
              children: [
                for (int i = 0; i < draft.items.length; i++) ...[
                  _ValuationRow(
                    label: '${draft.items[i].itemType} ${i + 1} (${draft.items[i].purity})',
                    value: _currencyFmt.format(draft.items[i].valuationAt(draft.goldRatePerGram)),
                    subLabel: '${draft.items[i].netWeightG.toStringAsFixed(2)}g net',
                  ),
                  if (i < draft.items.length - 1) const Divider(height: 12, color: GirviColors.line),
                ],
                if (draft.items.length > 1) ...[
                  const Divider(height: 12, color: GirviColors.navy),
                  _ValuationRow(
                    label: 'एकूण मूल्य / Total Valuation',
                    value: _currencyFmt.format(valuation),
                    bold: true,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: GirviColors.screenBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: GirviColors.line),
            ),
            child: const Center(
              child: BilingualText(
                en: 'Valuation will appear after adding items',
                mr: 'दागिने जोडल्यानंतर मूल्यांकन दिसेल',
                hi: 'वस्तुएं जोड़ने के बाद मूल्यांकन दिखेगा',
                style: TextStyle(color: GirviColors.muted, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        const BilingualText(
          en: 'Select LTV Option',
          mr: 'LTV पर्याय निवडा',
          hi: 'LTV विकल्प चुनें',
          style: TextStyle(color: GirviColors.ink, fontSize: 13, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 4),
        const BilingualText(
          en: 'Max 75% LTV as per RBI guidelines',
          mr: 'RBI मार्गदर्शक तत्त्वे: सोने कर्जावर कमाल 75% LTV',
          hi: 'RBI दिशानिर्देश: अधिकतम 75% LTV',
          style: TextStyle(color: GirviColors.muted, fontSize: 11, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),

        // LTV chips — 5 options
        Column(
          children: List.generate(_ltvOptions.length, (i) {
            final ltv = _ltvOptions[i];
            final loanAmt = (valuation * ltv / 100).floorToDouble();
            final isSelected = draft.selectedLtvPercent == ltv && draft.manualLoanAmount == null;
            return GestureDetector(
              onTap: () => context.read<CreateGirviBloc>().add(CreateGirviLtvSelected(ltv)),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? GirviColors.navy : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? GirviColors.navy : GirviColors.line,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? GirviColors.gold.withValues(alpha: 0.2)
                            : GirviColors.screenBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${ltv.toInt()}%',
                          style: TextStyle(
                            color: isSelected ? GirviColors.gold : GirviColors.ink,
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
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
                            _currencyFmt.format(loanAmt),
                            style: TextStyle(
                              color: isSelected ? Colors.white : GirviColors.ink,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            '${ltv.toInt()}% of ${_currencyFmt.format(valuation)}',
                            style: TextStyle(
                              color: isSelected ? Colors.white60 : GirviColors.muted,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_circle, color: GirviColors.gold, size: 22),
                  ],
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: GirviColors.green.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: GirviColors.green.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: GirviColors.green, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'निवडलेले कर्ज: ${_currencyFmt.format(draft.effectiveLoanAmount)} (${draft.selectedLtvPercent.toInt()}% LTV)',
                  style: const TextStyle(
                      color: GirviColors.green, fontSize: 12, fontWeight: FontWeight.w800),
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
  const _ValuationRow({
    required this.label,
    required this.value,
    this.subLabel,
    this.bold = false,
  });

  final String label;
  final String value;
  final String? subLabel;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                    color: GirviColors.muted,
                    fontSize: 12,
                    fontWeight: bold ? FontWeight.w900 : FontWeight.w700,
                  )),
              if (subLabel != null)
                Text(subLabel!, style: const TextStyle(color: GirviColors.muted, fontSize: 10)),
            ],
          ),
        ),
        Text(value,
            style: TextStyle(
              color: GirviColors.ink,
              fontSize: bold ? 15 : 13,
              fontWeight: FontWeight.w900,
            )),
      ],
    );
  }
}

// ─── Step 5: Loan Terms ───────────────────────────────────────────────────────

class _LoanTermsStep extends StatefulWidget {
  const _LoanTermsStep({required this.draft});

  final CreateGirviDraft draft;

  @override
  State<_LoanTermsStep> createState() => _LoanTermsStepState();
}

class _LoanTermsStepState extends State<_LoanTermsStep> {
  late TextEditingController _rateCtrl;
  late TextEditingController _penaltyCtrl;
  late DateTime _dueDate;
  InterestType _interestType = InterestType.simple;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _rateCtrl = TextEditingController(text: widget.draft.interestRate.toStringAsFixed(0));
    _penaltyCtrl = TextEditingController(text: widget.draft.penaltyRate.toStringAsFixed(0));
    _dueDate = widget.draft.dueDate;
    _interestType = widget.draft.interestType;
    _initialized = true;
  }

  @override
  void dispose() {
    _rateCtrl.dispose();
    _penaltyCtrl.dispose();
    super.dispose();
  }

  void _sync() {
    if (!_initialized) return;
    context.read<CreateGirviBloc>().add(CreateGirviLoanTermsUpdated(
      interestRate: double.tryParse(_rateCtrl.text) ?? widget.draft.interestRate,
      interestType: _interestType,
      dueDate: _dueDate,
      penaltyRate: double.tryParse(_penaltyCtrl.text) ?? widget.draft.penaltyRate,
    ));
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: GirviColors.navy, onPrimary: Colors.white),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
      _sync();
    }
  }

  @override
  Widget build(BuildContext context) {
    final draft = widget.draft;
    final loanAmt = draft.effectiveLoanAmount;
    final months = _dueDate.difference(draft.startDate).inDays / 30.0;
    final interest = loanAmt * (double.tryParse(_rateCtrl.text) ?? draft.interestRate) / 100 * (months / 12);
    final total = loanAmt + interest;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      children: [
        const _SectionTitle(titleMr: 'कर्जाचे अटी', titleEn: 'Loan Terms'),
        const SizedBox(height: 12),

        // Loan amount summary
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: GirviColors.navy,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.currency_rupee, color: GirviColors.gold, size: 28),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BilingualText(
                en: 'Loan Amount',
                mr: 'कर्ज रक्कम',
                hi: 'ऋण राशि',
                style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w700),
              ),
                  Text(
                    _currencyFmt.format(loanAmt),
                    style: const TextStyle(color: GirviColors.gold, fontSize: 22, fontWeight: FontWeight.w900),
                  ),
                  Text('${draft.selectedLtvPercent.toInt()}% LTV',
                      style: const TextStyle(color: Colors.white60, fontSize: 11)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Interest type
        const BilingualText(
          en: 'Interest Type',
          mr: 'व्याज प्रकार',
          hi: 'ब्याज प्रकार',
          style: TextStyle(color: GirviColors.ink, fontSize: 13, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            for (final type in InterestType.values) ...[
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => _interestType = type);
                    _sync();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    margin: type != InterestType.values.last
                        ? const EdgeInsets.only(right: 8)
                        : EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: _interestType == type ? GirviColors.navy : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _interestType == type ? GirviColors.navy : GirviColors.line,
                      ),
                    ),
                    child: Text(
                      type == InterestType.simple ? 'Simple'
                          : type == InterestType.katmiti ? 'Katmiti'
                          : 'Daily',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _interestType == type ? GirviColors.gold : GirviColors.muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: _AppTextField(
                controller: _rateCtrl,
                label: 'व्याज दर (%) / Rate',
                hint: '18',
                prefixIcon: Icons.percent,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => _sync(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _AppTextField(
                controller: _penaltyCtrl,
                label: 'दंड दर (%) / Penalty',
                hint: '2',
                prefixIcon: Icons.warning_amber_outlined,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => _sync(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: _ReadOnlyField(
                label: 'सुरवात / Start Date',
                value: DateFormat('dd MMM yyyy').format(draft.startDate),
                icon: Icons.calendar_today_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: _pickDate,
                child: _ReadOnlyField(
                  label: 'देय / Due Date',
                  value: DateFormat('dd MMM yyyy').format(_dueDate),
                  icon: Icons.event_outlined,
                  tappable: true,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Summary
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: GirviColors.line),
          ),
          child: Column(
            children: [
              _InfoRow(label: 'मुद्दल / Principal', value: _currencyFmt.format(loanAmt)),
              const Divider(height: 16, color: GirviColors.line),
              _InfoRow(
                  label: 'अंदाजित व्याज / Est. Interest',
                  value: _currencyFmt.format(interest.clamp(0.0, double.infinity))),
              const Divider(height: 16, color: GirviColors.line),
              _InfoRow(
                  label: 'एकूण परतफेड / Total Payable',
                  value: _currencyFmt.format(total.clamp(0.0, double.infinity)),
                  bold: true),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Step 6: KFS ─────────────────────────────────────────────────────────────

class _KfsPreviewStep extends StatelessWidget {
  const _KfsPreviewStep({required this.draft});

  final CreateGirviDraft draft;

  @override
  Widget build(BuildContext context) {
    final loanAmt = draft.effectiveLoanAmount;
    final months = draft.dueDate.difference(draft.startDate).inDays;
    final interest = loanAmt * draft.interestRate / 100 * (months / 365.0);
    final total = loanAmt + interest;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      children: [
        const _SectionTitle(titleMr: 'Key Fact Statement', titleEn: 'KFS Preview'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: GirviColors.line),
          ),
          child: Column(
            children: [
              _InfoRow(label: 'मुद्दल / Principal', value: _currencyFmt.format(loanAmt)),
              const Divider(height: 16, color: GirviColors.line),
              _InfoRow(label: 'व्याज दर / Interest Rate',
                  value: '${draft.interestRate.toStringAsFixed(0)}% p.a.'),
              const Divider(height: 16, color: GirviColors.line),
              _InfoRow(label: 'APR', value: '${draft.interestRate.toStringAsFixed(0)}%'),
              const Divider(height: 16, color: GirviColors.line),
              _InfoRow(label: 'एकूण परतफेड / Total Payable', value: _currencyFmt.format(total), bold: true),
              const Divider(height: 16, color: GirviColors.line),
              _InfoRow(label: 'कालावधी / Tenure', value: '$months दिवस / Days'),
              const Divider(height: 16, color: GirviColors.line),
              _InfoRow(label: 'दंड व्याज / Penalty', value: '${draft.penaltyRate.toStringAsFixed(0)}% प्रति महिना'),
              const Divider(height: 16, color: GirviColors.line),
              _InfoRow(label: 'वॉल्ट / Vault', value: draft.vaultLocation),
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
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BilingualText(
                en: 'Auction Rules',
                mr: 'लिलाव नियम',
                hi: 'नीलामी नियम',
                style: TextStyle(color: GirviColors.ink, fontSize: 13, fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 6),
              BilingualText(
                en: '• Auction can be held after 14 days notice.',
                mr: '• 14 दिवसांची सूचना दिल्यानंतर लिलाव करता येईल.',
                hi: '• 14 दिनों की नोटिस के बाद नीलामी की जा सकती है।',
                style: TextStyle(color: GirviColors.muted, fontSize: 12, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 4),
              BilingualText(
                en: '• 7 working days to return gold.',
                mr: '• सोने परत करण्यासाठी 7 कामकाजाचे दिवस.',
                hi: '• सोना वापस करने के लिए 7 कार्य दिवस।',
                style: TextStyle(color: GirviColors.muted, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        BlocBuilder<CreateGirviBloc, CreateGirviState>(
          builder: (context, state) {
            final accepted = state is CreateGirviDraft ? state.kfsAccepted : false;
            return GestureDetector(
              onTap: () => context.read<CreateGirviBloc>().add(CreateGirviKfsAccepted(!accepted)),
              child: Row(
                children: [
                  Checkbox(
                    value: accepted,
                    onChanged: (v) => context.read<CreateGirviBloc>().add(CreateGirviKfsAccepted(v ?? false)),
                    activeColor: GirviColors.navy,
                  ),
                  const Expanded(
                    child: BilingualText(
                      en: 'I have read and agree to the KFS',
                      mr: 'मी KFS वाचले आणि सहमत आहे',
                      hi: 'मैंने KFS पढ़ा है और सहमत हूं',
                      style: TextStyle(color: GirviColors.ink, fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

// ─── Step 7: Vault ────────────────────────────────────────────────────────────

class _VaultAssignmentStep extends StatefulWidget {
  const _VaultAssignmentStep({required this.draft});

  final CreateGirviDraft draft;

  @override
  State<_VaultAssignmentStep> createState() => _VaultAssignmentStepState();
}

class _VaultAssignmentStepState extends State<_VaultAssignmentStep> {
  String _vault = 'Vault-A';
  String _safe = 'SF-02';
  String _tray = 'TR-05';
  String _slot = 'SL-18';

  void _sync() {
    final location = '$_vault/$_safe/$_tray/$_slot';
    context.read<CreateGirviBloc>().add(CreateGirviVaultSelected(location));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      children: [
        const _SectionTitle(titleMr: 'वॉल्ट नियुक्ती', titleEn: 'Vault Assignment'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: GirviColors.navy, borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              const Icon(Icons.lock_outline, color: GirviColors.gold, size: 28),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BilingualText(
                    en: 'Suggested',
                    mr: 'सूचित वॉल्ट',
                    hi: 'सुझाया गया वॉल्ट',
                    style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '$_vault/$_safe/$_tray/$_slot',
                    style: const TextStyle(color: GirviColors.gold, fontSize: 14, fontWeight: FontWeight.w900),
                  ),
                ],
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
              _VaultDropdown(
                label: 'वॉल्ट / Vault',
                value: _vault,
                items: const ['Vault-A', 'Vault-B', 'Vault-C'],
                onChanged: (v) {
                  setState(() => _vault = v!);
                  _sync();
                },
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _VaultDropdown(
                      label: 'सेफ / Safe',
                      value: _safe,
                      items: const ['SF-01', 'SF-02', 'SF-03'],
                      onChanged: (v) {
                        setState(() => _safe = v!);
                        _sync();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _VaultDropdown(
                      label: 'ट्रे / Tray',
                      value: _tray,
                      items: const ['TR-01', 'TR-02', 'TR-03', 'TR-04', 'TR-05'],
                      onChanged: (v) {
                        setState(() => _tray = v!);
                        _sync();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _VaultDropdown(
                label: 'स्लॉट / Slot',
                value: _slot,
                items: List.generate(20, (i) => 'SL-${(i + 1).toString().padLeft(2, '0')}'),
                onChanged: (v) {
                  setState(() => _slot = v!);
                  _sync();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _VaultDropdown extends StatelessWidget {
  const _VaultDropdown({
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
        Text(label,
            style: const TextStyle(color: GirviColors.ink, fontSize: 12, fontWeight: FontWeight.w800)),
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
              items: items.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Step 8: Success ──────────────────────────────────────────────────────────

class _SuccessStep extends StatelessWidget {
  const _SuccessStep({required this.girvi});

  final Girvi? girvi;

  @override
  Widget build(BuildContext context) {
    if (girvi == null) {
      return const Center(child: CircularProgressIndicator(color: GirviColors.navy));
    }
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
            child: const Icon(Icons.check_circle, color: GirviColors.green, size: 56),
          ),
          const SizedBox(height: 24),
          const BilingualText(
            en: 'Girvi Created Successfully!',
            mr: 'गिरवी तयार झाली!',
            hi: 'गिरवी सफलतापूर्वक बनाई गई!',
            style: TextStyle(color: GirviColors.ink, fontSize: 22, fontWeight: FontWeight.w900),
            textAlign: TextAlign.center,
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
              children: [
                _InfoRow(label: 'Serial ID', value: girvi!.serialId),
                const Divider(height: 16, color: GirviColors.line),
                _InfoRow(label: 'ग्राहक / Customer', value: girvi!.customerName),
                const Divider(height: 16, color: GirviColors.line),
                _InfoRow(label: 'कर्ज रक्कम / Loan', value: _currencyFmt.format(girvi!.loanAmount)),
                const Divider(height: 16, color: GirviColors.line),
                _InfoRow(label: 'देय तारीख / Due', value: DateFormat('dd MMM yyyy').format(girvi!.dueDate)),
                const Divider(height: 16, color: GirviColors.line),
                _InfoRow(label: 'वॉल्ट / Vault', value: girvi!.vaultLocation ?? '—'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shared helper widgets ────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.titleMr, required this.titleEn});

  final String titleMr;
  final String titleEn;

  @override
  Widget build(BuildContext context) {
    return BilingualText(
      en: titleEn,
      mr: titleMr,
      hi: titleMr,
      style: const TextStyle(color: GirviColors.ink, fontSize: 15, fontWeight: FontWeight.w900),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, this.bold = false});

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(color: GirviColors.muted, fontSize: 12, fontWeight: FontWeight.w700)),
        Text(value,
            style: TextStyle(
              color: GirviColors.ink,
              fontSize: bold ? 14 : 13,
              fontWeight: FontWeight.w900,
            )),
      ],
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({
    required this.label,
    required this.value,
    required this.icon,
    this.tappable = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool tappable;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: GirviColors.ink, fontSize: 13, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
          decoration: BoxDecoration(
            color: tappable ? Colors.white : GirviColors.screenBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: tappable ? GirviColors.navy.withValues(alpha: 0.4) : GirviColors.line),
          ),
          child: Row(
            children: [
              Icon(icon, color: tappable ? GirviColors.navy : GirviColors.muted, size: 18),
              const SizedBox(width: 10),
              Text(value,
                  style: TextStyle(
                    color: tappable ? GirviColors.ink : GirviColors.muted,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  )),
            ],
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
    this.onChanged,
    this.onEditingComplete,
    this.readOnly = false,
    this.maxLines = 1,
  });

  final TextEditingController? controller;
  final String label;
  final String hint;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final bool readOnly;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: GirviColors.ink, fontSize: 13, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          maxLines: maxLines,
          onChanged: onChanged,
          onEditingComplete: onEditingComplete,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hint,
            hintStyle: const TextStyle(color: GirviColors.muted, fontSize: 13),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: GirviColors.muted, size: 20)
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
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
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
        Text(label,
            style: const TextStyle(color: GirviColors.ink, fontSize: 13, fontWeight: FontWeight.w800)),
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
              items: items.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
