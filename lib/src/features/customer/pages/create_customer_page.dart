import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/di/injection.dart';
import '../../../core/navigation/app_navigation.dart';
import '../domain/entities/customer.dart';
import '../presentation/bloc/customer_detail_bloc.dart';
import '../presentation/bloc/customer_detail_event.dart';
import '../presentation/bloc/customer_detail_state.dart';
import '../theme/customer_colors.dart';
import 'customer_details_page.dart';
import 'customer_list_page.dart';

class CreateCustomerPage extends StatelessWidget {
  const CreateCustomerPage({super.key});

  static const routeName = 'create-customer';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CustomerDetailBloc>(),
      child: const _CreateCustomerWizard(),
    );
  }
}

class _CreateCustomerWizard extends StatefulWidget {
  const _CreateCustomerWizard();

  @override
  State<_CreateCustomerWizard> createState() => _CreateCustomerWizardState();
}

class _CreateCustomerWizardState extends State<_CreateCustomerWizard> {
  int _step = 0;
  static const _totalSteps = 4;

  // Personal
  final _nameCtrl = TextEditingController();
  final _nameEnCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _altMobileCtrl = TextEditingController();
  String _gender = 'Male';
  DateTime? _dob;

  // Address
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _stateCtrl = TextEditingController();
  final _pincodeCtrl = TextEditingController();

  // KYC
  String? _aadhaarImagePath;
  final _aadhaarCtrl = TextEditingController();
  final _panCtrl = TextEditingController();

  // Photo
  String? _photoPath;

  final _imagePicker = ImagePicker();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nameEnCtrl.dispose();
    _mobileCtrl.dispose();
    _altMobileCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _pincodeCtrl.dispose();
    _aadhaarCtrl.dispose();
    _panCtrl.dispose();
    super.dispose();
  }

  bool _validateStep() {
    switch (_step) {
      case 0:
        if (_nameCtrl.text.trim().isEmpty) {
          _showError('पूर्ण नाव आवश्यक आहे / Full name is required');
          return false;
        }
        if (_mobileCtrl.text.trim().length != 10) {
          _showError('10 अंकी मोबाईल नंबर टाका / Enter 10-digit mobile number');
          return false;
        }
        return true;
      case 1:
        if (_addressCtrl.text.trim().isEmpty) {
          _showError('पत्ता आवश्यक आहे / Address is required');
          return false;
        }
        if (_cityCtrl.text.trim().isEmpty) {
          _showError('शहर आवश्यक आहे / City is required');
          return false;
        }
        if (_pincodeCtrl.text.trim().length != 6) {
          _showError('6 अंकी पिनकोड टाका / Enter 6-digit pincode');
          return false;
        }
        if (_stateCtrl.text.trim().isEmpty) {
          _showError('राज्य आवश्यक आहे / State is required');
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: CustomerColors.red,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  void _next() {
    if (!_validateStep()) return;
    if (_step < _totalSteps - 1) {
      setState(() => _step++);
    } else {
      _submit();
    }
  }

  void _back() {
    if (_step > 0) setState(() => _step--);
  }

  void _submit() {
    final request = CreateCustomerRequest(
      name: _nameCtrl.text.trim(),
      mobile: _mobileCtrl.text.trim(),
      alternateMobile: _altMobileCtrl.text.trim().isEmpty
          ? null
          : _altMobileCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      city: _cityCtrl.text.trim(),
      state: _stateCtrl.text.trim(),
      pincode: _pincodeCtrl.text.trim(),
      gender: _gender,
      dateOfBirth: _dob?.toIso8601String().substring(0, 10),
      panNumber: _panCtrl.text.trim().isEmpty ? null : _panCtrl.text.trim(),
    );
    context.read<CustomerDetailBloc>().add(CreateCustomer(request));
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1930),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      helpText: 'जन्मतारीख निवडा / Select Date of Birth',
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: CustomerColors.navy,
            onPrimary: Colors.white,
            onSurface: CustomerColors.ink,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _dob = picked);
  }

  Future<void> _pickImage({bool isAadhaar = false}) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetCtx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined,
                  color: CustomerColors.navy),
              title: const Text('कॅमेरा / Camera'),
              onTap: () => Navigator.pop(sheetCtx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined,
                  color: CustomerColors.navy),
              title: const Text('गॅलरी / Gallery'),
              onTap: () => Navigator.pop(sheetCtx, ImageSource.gallery),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return;
    try {
      final image = await _imagePicker.pickImage(
        source: source,
        maxWidth: isAadhaar ? 1200 : 800,
        imageQuality: isAadhaar ? 90 : 80,
      );
      if (image != null && mounted) {
        setState(() {
          if (isAadhaar) {
            _aadhaarImagePath = image.path;
          } else {
            _photoPath = image.path;
          }
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          final mockPath =
              'mock://photo-${DateTime.now().millisecondsSinceEpoch}.jpg';
          if (isAadhaar) {
            _aadhaarImagePath = mockPath;
          } else {
            _photoPath = mockPath;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CustomerDetailBloc, CustomerDetailState>(
      listener: (context, state) {
        if (state is CustomerOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: CustomerColors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ));
          context.goNamed(
            CustomerDetailsPage.routeName,
            pathParameters: {'id': state.customer.id},
          );
        }
        if (state is CustomerOperationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: CustomerColors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ));
        }
      },
      child: BlocBuilder<CustomerDetailBloc, CustomerDetailState>(
        builder: (context, state) {
          final isSubmitting = state is CustomerOperationLoading;
          return Scaffold(
            backgroundColor: CustomerColors.screenBg,
            body: SafeArea(
              child: Column(
                children: [
                  _WizardHeader(step: _step),
                  const SizedBox(height: 4),
                  _StepIndicator(
                    current: _step,
                    total: _totalSteps,
                    labels: const [
                      'वैयक्तिक\nPersonal',
                      'पत्ता\nAddress',
                      'KYC',
                      'पुष्टी\nConfirm',
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                      child: IndexedStack(
                        index: _step,
                        children: [
                          _PersonalStep(
                            nameCtrl: _nameCtrl,
                            nameEnCtrl: _nameEnCtrl,
                            mobileCtrl: _mobileCtrl,
                            altMobileCtrl: _altMobileCtrl,
                            gender: _gender,
                            dob: _dob,
                            onGenderChanged: (v) {
                              if (v != null) setState(() => _gender = v);
                            },
                            onDobTap: _pickDate,
                          ),
                          _AddressStep(
                            addressCtrl: _addressCtrl,
                            cityCtrl: _cityCtrl,
                            stateCtrl: _stateCtrl,
                            pincodeCtrl: _pincodeCtrl,
                          ),
                          _KycStep(
                            aadhaarImagePath: _aadhaarImagePath,
                            aadhaarCtrl: _aadhaarCtrl,
                            panCtrl: _panCtrl,
                            onPickAadhaar: () => _pickImage(isAadhaar: true),
                          ),
                          _ConfirmStep(
                            photoPath: _photoPath,
                            onPickPhoto: _pickImage,
                            name: _nameCtrl.text,
                            nameEn: _nameEnCtrl.text,
                            mobile: _mobileCtrl.text,
                            address: _addressCtrl.text,
                            city: _cityCtrl.text,
                            state: _stateCtrl.text,
                          ),
                        ],
                      ),
                    ),
                  ),
                  _WizardFooter(
                    step: _step,
                    totalSteps: _totalSteps,
                    isSubmitting: isSubmitting,
                    onBack: _back,
                    onNext: _next,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

class _WizardHeader extends StatelessWidget {
  const _WizardHeader({required this.step});

  final int step;

  static const _titles = [
    'वैयक्तिक माहिती / Personal',
    'पत्ता / Address',
    'KYC दस्तऐवज / Documents',
    'पुष्टीकरण / Confirm',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 10, 16, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: () => AppNavigation.popOrGoNamed(
              context,
              CustomerListPage.routeName,
            ),
            icon: const Icon(Icons.arrow_back, color: CustomerColors.ink),
          ),
          Expanded(
            child: Text(
              'नवीन ग्राहक / ${_titles[step]}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: CustomerColors.ink,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

// ─── Step Indicator ───────────────────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({
    required this.current,
    required this.total,
    required this.labels,
  });

  final int current;
  final int total;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(total * 2 - 1, (i) {
          if (i.isOdd) {
            final stepIndex = i ~/ 2;
            final done = stepIndex < current;
            return Expanded(
              child: Container(
                height: 2,
                color: done
                    ? CustomerColors.navy
                    : CustomerColors.line,
              ),
            );
          }
          final stepIndex = i ~/ 2;
          final done = stepIndex < current;
          final active = stepIndex == current;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done
                      ? CustomerColors.navy
                      : active
                          ? CustomerColors.gold
                          : Colors.white,
                  border: Border.all(
                    color: done || active
                        ? Colors.transparent
                        : CustomerColors.line,
                    width: 1.5,
                  ),
                ),
                child: done
                    ? const Icon(Icons.check, color: Colors.white, size: 14)
                    : Text(
                        '${stepIndex + 1}',
                        style: TextStyle(
                          color: active
                              ? CustomerColors.navy
                              : CustomerColors.muted,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 52,
                child: Text(
                  labels[stepIndex],
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: active
                        ? CustomerColors.navy
                        : done
                            ? CustomerColors.ink
                            : CustomerColors.muted,
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
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
    required this.step,
    required this.totalSteps,
    required this.isSubmitting,
    required this.onBack,
    required this.onNext,
  });

  final int step;
  final int totalSteps;
  final bool isSubmitting;
  final VoidCallback onBack;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final isLast = step == totalSteps - 1;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: CustomerColors.line)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Row(
        children: [
          if (step > 0) ...[
            OutlinedButton(
              onPressed: isSubmitting ? null : onBack,
              style: OutlinedButton.styleFrom(
                foregroundColor: CustomerColors.muted,
                side: const BorderSide(color: CustomerColors.line),
                minimumSize: const Size(88, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('मागे / Back'),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: ElevatedButton(
              onPressed: isSubmitting ? null : onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomerColors.navy,
                foregroundColor: CustomerColors.gold,
                disabledBackgroundColor:
                    CustomerColors.navy.withValues(alpha: 0.6),
                minimumSize: const Size(0, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: isSubmitting && isLast
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: CustomerColors.gold,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Text(
                      isLast
                          ? 'ग्राहक जतन करा / Save Customer'
                          : 'पुढे जा / Continue',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Step 1: Personal ─────────────────────────────────────────────────────────

class _PersonalStep extends StatelessWidget {
  const _PersonalStep({
    required this.nameCtrl,
    required this.nameEnCtrl,
    required this.mobileCtrl,
    required this.altMobileCtrl,
    required this.gender,
    required this.dob,
    required this.onGenderChanged,
    required this.onDobTap,
  });

  final TextEditingController nameCtrl;
  final TextEditingController nameEnCtrl;
  final TextEditingController mobileCtrl;
  final TextEditingController altMobileCtrl;
  final String gender;
  final DateTime? dob;
  final ValueChanged<String?> onGenderChanged;
  final VoidCallback onDobTap;

  @override
  Widget build(BuildContext context) {
    return _StepCard(
      children: [
        _AppTextField(
          controller: nameCtrl,
          label: 'पूर्ण नाव / Full Name (मराठी)',
          hint: 'मराठी नाव टाका',
          prefixIcon: Icons.person_outline,
        ),
        const SizedBox(height: 14),
        _AppTextField(
          controller: nameEnCtrl,
          label: 'Name in English',
          hint: 'English name',
          prefixIcon: Icons.person_outline,
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 14),
        _AppTextField(
          controller: mobileCtrl,
          label: 'मोबाईल नंबर / Mobile Number',
          hint: '10 अंकी मोबाईल नंबर',
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          maxLength: 10,
        ),
        const SizedBox(height: 14),
        _AppTextField(
          controller: altMobileCtrl,
          label: 'पर्यायी मोबाईल / Alternate Mobile (ऐच्छिक)',
          hint: 'पर्यायी मोबाईल नंबर',
          prefixIcon: Icons.phone_android_outlined,
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          maxLength: 10,
        ),
        const SizedBox(height: 14),
        _GenderPicker(value: gender, onChanged: onGenderChanged),
        const SizedBox(height: 14),
        _DobPicker(value: dob, onTap: onDobTap),
      ],
    );
  }
}

// ─── Step 2: Address ──────────────────────────────────────────────────────────

class _AddressStep extends StatelessWidget {
  const _AddressStep({
    required this.addressCtrl,
    required this.cityCtrl,
    required this.stateCtrl,
    required this.pincodeCtrl,
  });

  final TextEditingController addressCtrl;
  final TextEditingController cityCtrl;
  final TextEditingController stateCtrl;
  final TextEditingController pincodeCtrl;

  @override
  Widget build(BuildContext context) {
    return _StepCard(
      children: [
        _AppTextField(
          controller: addressCtrl,
          label: 'पत्ता / Address',
          hint: 'घर क्रमांक, रस्ता, परिसर',
          prefixIcon: Icons.home_outlined,
          maxLines: 2,
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _AppTextField(
                controller: cityCtrl,
                label: 'शहर / City',
                hint: 'शहर',
                prefixIcon: Icons.location_city_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _AppTextField(
                controller: pincodeCtrl,
                label: 'पिनकोड / Pincode',
                hint: '6 अंक',
                prefixIcon: Icons.pin_drop_outlined,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 6,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _AppTextField(
          controller: stateCtrl,
          label: 'राज्य / State',
          hint: 'राज्य',
          prefixIcon: Icons.map_outlined,
        ),
      ],
    );
  }
}

// ─── Step 3: KYC ─────────────────────────────────────────────────────────────

class _KycStep extends StatelessWidget {
  const _KycStep({
    required this.aadhaarImagePath,
    required this.aadhaarCtrl,
    required this.panCtrl,
    required this.onPickAadhaar,
  });

  final String? aadhaarImagePath;
  final TextEditingController aadhaarCtrl;
  final TextEditingController panCtrl;
  final VoidCallback onPickAadhaar;

  @override
  Widget build(BuildContext context) {
    return _StepCard(
      children: [
        _DocCaptureTile(
          icon: Icons.document_scanner_outlined,
          titleMr: 'आधार कार्ड फोटो',
          titleEn: 'Aadhaar Card Photo',
          capturedMr: 'आधार फोटो कॅप्चर झाला',
          capturedEn: 'Aadhaar captured · Tap to retake',
          imagePath: aadhaarImagePath,
          onTap: onPickAadhaar,
        ),
        const SizedBox(height: 14),
        _AppTextField(
          controller: aadhaarCtrl,
          label: 'आधार क्रमांक / Aadhaar Number',
          hint: '12 अंकी आधार क्रमांक',
          prefixIcon: Icons.badge_outlined,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          maxLength: 12,
        ),
        const SizedBox(height: 14),
        _AppTextField(
          controller: panCtrl,
          label: 'PAN क्रमांक / PAN Number (ऐच्छिक)',
          hint: 'ABCDE1234F',
          prefixIcon: Icons.credit_card_outlined,
          textCapitalization: TextCapitalization.characters,
          maxLength: 10,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: CustomerColors.gold.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: CustomerColors.gold.withValues(alpha: 0.25),
            ),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline,
                  color: CustomerColors.gold, size: 16),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  '₹50,000 पेक्षा जास्त व्यवहारासाठी PAN अनिवार्य\nPAN mandatory for transactions above ₹50,000',
                  style: TextStyle(
                    color: CustomerColors.ink,
                    fontSize: 11,
                    height: 1.4,
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

// ─── Step 4: Confirm ─────────────────────────────────────────────────────────

class _ConfirmStep extends StatelessWidget {
  const _ConfirmStep({
    required this.photoPath,
    required this.onPickPhoto,
    required this.name,
    required this.nameEn,
    required this.mobile,
    required this.address,
    required this.city,
    required this.state,
  });

  final String? photoPath;
  final VoidCallback onPickPhoto;
  final String name;
  final String nameEn;
  final String mobile;
  final String address;
  final String city;
  final String state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _DocCaptureTile(
          icon: Icons.person_outline,
          titleMr: 'ग्राहकाचा फोटो',
          titleEn: 'Customer Photo',
          capturedMr: 'फोटो कॅप्चर झाला',
          capturedEn: 'Photo captured · Tap to retake',
          imagePath: photoPath,
          onTap: onPickPhoto,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: CustomerColors.line),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _ReviewSectionTitle(
                  titleMr: 'माहिती पुनरावलोकन',
                  titleEn: 'Review Information'),
              const SizedBox(height: 12),
              _ReviewRow(label: 'नाव / Name', value: name.isEmpty ? '—' : name),
              _ReviewRow(
                  label: 'English Name',
                  value: nameEn.isEmpty ? '—' : nameEn),
              _ReviewRow(
                  label: 'मोबाईल / Mobile',
                  value: mobile.isEmpty ? '—' : mobile),
              _ReviewRow(
                  label: 'पत्ता / Address',
                  value: [address, city, state]
                      .where((s) => s.isNotEmpty)
                      .join(', ')),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: CustomerColors.navy.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: CustomerColors.navy.withValues(alpha: 0.15)),
          ),
          child: const Row(
            children: [
              Icon(Icons.check_circle_outline,
                  color: CustomerColors.navy, size: 18),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'सर्व माहिती तपासा आणि "ग्राहक जतन करा" दाबा\nReview all details before saving the customer',
                  style: TextStyle(
                    color: CustomerColors.ink,
                    fontSize: 12,
                    height: 1.4,
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

// ─── Shared Widgets ───────────────────────────────────────────────────────────

class _StepCard extends StatelessWidget {
  const _StepCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: CustomerColors.line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
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
    this.textCapitalization = TextCapitalization.words,
  });

  final TextEditingController? controller;
  final String label;
  final String hint;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final int maxLines;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: CustomerColors.ink,
            fontSize: 12,
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
          textCapitalization: textCapitalization,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hint,
            hintStyle: const TextStyle(
              color: CustomerColors.muted,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: CustomerColors.muted, size: 20)
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: CustomerColors.line),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: CustomerColors.line),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: CustomerColors.navy, width: 1.5),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
            counterText: '',
          ),
        ),
      ],
    );
  }
}

class _GenderPicker extends StatelessWidget {
  const _GenderPicker({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'लिंग / Gender',
          style: TextStyle(
            color: CustomerColors.ink,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: CustomerColors.line),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down,
                  color: CustomerColors.muted),
              items: const [
                DropdownMenuItem(
                    value: 'Male', child: Text('पुरुष / Male')),
                DropdownMenuItem(
                    value: 'Female', child: Text('स्त्री / Female')),
                DropdownMenuItem(
                    value: 'Other', child: Text('इतर / Other')),
              ],
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class _DobPicker extends StatelessWidget {
  const _DobPicker({required this.value, required this.onTap});

  final DateTime? value;
  final VoidCallback onTap;

  String get _display {
    if (value == null) return 'DD/MM/YYYY';
    return '${value!.day.toString().padLeft(2, '0')}/'
        '${value!.month.toString().padLeft(2, '0')}/${value!.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'जन्मतारीख / Date of Birth',
          style: TextStyle(
            color: CustomerColors.ink,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: CustomerColors.line),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined,
                    color: CustomerColors.muted, size: 20),
                const SizedBox(width: 12),
                Text(
                  _display,
                  style: TextStyle(
                    color: value != null
                        ? CustomerColors.ink
                        : CustomerColors.muted,
                    fontSize: 13,
                    fontWeight: value != null
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DocCaptureTile extends StatelessWidget {
  const _DocCaptureTile({
    required this.icon,
    required this.titleMr,
    required this.titleEn,
    required this.capturedMr,
    required this.capturedEn,
    required this.imagePath,
    required this.onTap,
  });

  final IconData icon;
  final String titleMr;
  final String titleEn;
  final String capturedMr;
  final String capturedEn;
  final String? imagePath;
  final VoidCallback onTap;

  bool get _captured => imagePath != null;
  bool get _isMock =>
      imagePath?.startsWith('mock://') ?? false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _captured
              ? CustomerColors.green.withValues(alpha: 0.05)
              : CustomerColors.cream,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _captured
                ? CustomerColors.green.withValues(alpha: 0.35)
                : CustomerColors.gold.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            if (_captured && !_isMock)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(imagePath!),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _captured
                      ? CustomerColors.green.withValues(alpha: 0.15)
                      : CustomerColors.navy,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _captured ? Icons.check : icon,
                  color: _captured
                      ? CustomerColors.green
                      : CustomerColors.gold,
                  size: 24,
                ),
              ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _captured ? capturedMr : titleMr,
                    style: TextStyle(
                      color: _captured
                          ? CustomerColors.green
                          : CustomerColors.ink,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _captured ? capturedEn : titleEn,
                    style: const TextStyle(
                      color: CustomerColors.muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              _captured ? Icons.check_circle : Icons.arrow_forward_ios,
              color: _captured
                  ? CustomerColors.green
                  : CustomerColors.muted,
              size: _captured ? 22 : 14,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewSectionTitle extends StatelessWidget {
  const _ReviewSectionTitle(
      {required this.titleMr, required this.titleEn});

  final String titleMr;
  final String titleEn;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.checklist_outlined,
            color: CustomerColors.navy, size: 18),
        const SizedBox(width: 8),
        Text(
          titleMr,
          style: const TextStyle(
            color: CustomerColors.ink,
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '/ $titleEn',
          style: const TextStyle(
            color: CustomerColors.muted,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: CustomerColors.muted,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '—' : value,
              style: const TextStyle(
                color: CustomerColors.ink,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
