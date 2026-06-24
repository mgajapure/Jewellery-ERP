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
      child: const _CreateCustomerView(),
    );
  }
}

class _CreateCustomerView extends StatefulWidget {
  const _CreateCustomerView();

  @override
  State<_CreateCustomerView> createState() => _CreateCustomerViewState();
}

class _CreateCustomerViewState extends State<_CreateCustomerView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _altMobileController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _panController = TextEditingController();
  final _aadhaarController = TextEditingController();
  String _selectedGender = 'Male';
  DateTime? _selectedDob;
  String? _photoPath;
  String? _aadhaarImagePath;
  final _imagePicker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _altMobileController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _panController.dispose();
    _aadhaarController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 800,
      imageQuality: 80,
    );
    if (image != null && mounted) {
      setState(() => _photoPath = image.path);
    }
  }

  Future<void> _pickAadhaarImage() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1200,
      imageQuality: 90,
    );
    if (image != null && mounted) {
      setState(() => _aadhaarImagePath = image.path);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'फोटो कॅप्चर झाला. आधार क्रमांक खाली टाका / Photo captured. Enter Aadhaar number below.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
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
    if (picked != null) setState(() => _selectedDob = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final request = CreateCustomerRequest(
      name: _nameController.text.trim(),
      mobile: _mobileController.text.trim(),
      alternateMobile: _altMobileController.text.trim().isEmpty
          ? null
          : _altMobileController.text.trim(),
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      pincode: _pincodeController.text.trim(),
      gender: _selectedGender,
      dateOfBirth: _selectedDob?.toIso8601String().substring(0, 10),
      panNumber:
          _panController.text.trim().isEmpty ? null : _panController.text.trim(),
    );
    context.read<CustomerDetailBloc>().add(CreateCustomer(request));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CustomerDetailBloc, CustomerDetailState>(
      listener: (context, state) {
        if (state is CustomerOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: CustomerColors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
          context.goNamed(
            CustomerDetailsPage.routeName,
            pathParameters: {'id': state.customer.id},
          );
        }
        if (state is CustomerOperationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: CustomerColors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
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
                  const _CreateCustomerHeader(),
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        padding:
                            const EdgeInsets.fromLTRB(20, 12, 20, 20),
                        children: [
                          const _SectionTitle(
                            titleMr: 'वैयक्तिक माहिती',
                            titleEn: 'Personal Information',
                          ),
                          const SizedBox(height: 12),
                          _AppTextField(
                            controller: _nameController,
                            label: 'पूर्ण नाव / Full Name',
                            hint: 'ग्राहकाचे पूर्ण नाव टाका',
                            prefixIcon: Icons.person_outline,
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'नाव आवश्यक आहे / Name is required'
                                : null,
                          ),
                          const SizedBox(height: 14),
                          _AppTextField(
                            controller: _mobileController,
                            label: 'मोबाईल नंबर / Mobile Number',
                            hint: '10 अंकी मोबाईल नंबर',
                            prefixIcon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            maxLength: 10,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'मोबाईल आवश्यक आहे / Mobile required';
                              }
                              if (v.trim().length != 10) {
                                return '10 अंकी नंबर टाका / Enter 10-digit number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          _AppTextField(
                            controller: _altMobileController,
                            label: 'पर्यायी मोबाईल / Alternate Mobile',
                            hint: 'पर्यायी मोबाईल नंबर (ऐच्छिक)',
                            prefixIcon: Icons.phone_android_outlined,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            maxLength: 10,
                          ),
                          const SizedBox(height: 14),
                          _GenderDropdown(
                            value: _selectedGender,
                            onChanged: (v) {
                              if (v != null) {
                                setState(() => _selectedGender = v);
                              }
                            },
                          ),
                          const SizedBox(height: 14),
                          _DatePickerField(
                            value: _selectedDob,
                            onTap: _pickDate,
                          ),
                          const SizedBox(height: 22),
                          const _SectionTitle(
                            titleMr: 'पत्ता',
                            titleEn: 'Address',
                          ),
                          const SizedBox(height: 12),
                          _AppTextField(
                            controller: _addressController,
                            label: 'पत्ता / Address',
                            hint: 'घर क्रमांक, रस्ता, परिसर',
                            prefixIcon: Icons.home_outlined,
                            maxLines: 2,
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'पत्ता आवश्यक आहे / Address required'
                                : null,
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: _AppTextField(
                                  controller: _cityController,
                                  label: 'शहर / City',
                                  hint: 'शहर',
                                  prefixIcon: Icons.location_city_outlined,
                                  validator: (v) =>
                                      (v == null || v.trim().isEmpty)
                                          ? 'शहर आवश्यक / City required'
                                          : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _AppTextField(
                                  controller: _pincodeController,
                                  label: 'पिनकोड / Pincode',
                                  hint: '6 अंक',
                                  prefixIcon: Icons.pin_drop_outlined,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  maxLength: 6,
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return 'पिनकोड आवश्यक';
                                    }
                                    if (v.trim().length != 6) {
                                      return '6 अंक टाका';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          _AppTextField(
                            controller: _stateController,
                            label: 'राज्य / State',
                            hint: 'राज्य',
                            prefixIcon: Icons.map_outlined,
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'राज्य आवश्यक / State required'
                                : null,
                          ),
                          const SizedBox(height: 22),
                          const _SectionTitle(
                            titleMr: 'KYC माहिती',
                            titleEn: 'KYC Information',
                          ),
                          const SizedBox(height: 12),
                          _AadhaarCaptureTile(
                            imagePath: _aadhaarImagePath,
                            onTap: _pickAadhaarImage,
                          ),
                          const SizedBox(height: 14),
                          _AppTextField(
                            controller: _aadhaarController,
                            label: 'आधार क्रमांक / Aadhaar Number',
                            hint: '12 अंकी आधार क्रमांक',
                            prefixIcon: Icons.badge_outlined,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            maxLength: 12,
                          ),
                          const SizedBox(height: 14),
                          _AppTextField(
                            controller: _panController,
                            label: 'PAN क्रमांक / PAN Number',
                            hint:
                                'ABCDE1234F (₹50,000 पेक्षा जास्त व्यवहारासाठी अनिवार्य)',
                            prefixIcon: Icons.credit_card_outlined,
                            textCapitalization: TextCapitalization.characters,
                          ),
                          const SizedBox(height: 14),
                          _CustomerPhotoTile(
                            imagePath: _photoPath,
                            onTap: _pickPhoto,
                          ),
                          const SizedBox(height: 28),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: isSubmitting ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: CustomerColors.navy,
                                foregroundColor: CustomerColors.gold,
                                disabledBackgroundColor:
                                    CustomerColors.navy.withValues(alpha: 0.6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: isSubmitting
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        color: CustomerColors.gold,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : const Text(
                                      'ग्राहक जतन करा / Save Customer',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
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

class _CreateCustomerHeader extends StatelessWidget {
  const _CreateCustomerHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 14, 18, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => AppNavigation.popOrGoNamed(
              context,
              CustomerListPage.routeName,
            ),
            icon: const Icon(Icons.arrow_back, color: CustomerColors.ink),
            tooltip: 'Back',
          ),
          const Expanded(
            child: Text(
              'नवीन ग्राहक / Create Customer',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: CustomerColors.ink,
                fontSize: 16,
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
            color: CustomerColors.ink,
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          titleEn,
          style: const TextStyle(
            color: CustomerColors.muted,
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
    this.textCapitalization = TextCapitalization.words,
    this.validator,
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
  final TextCapitalization textCapitalization;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: CustomerColors.ink,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          textCapitalization: textCapitalization,
          validator: validator,
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
                ? Icon(prefixIcon, color: CustomerColors.muted, size: 22)
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: CustomerColors.line),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: CustomerColors.line),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: CustomerColors.navy, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: CustomerColors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: CustomerColors.red, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 14,
            ),
            counterText: '',
          ),
        ),
      ],
    );
  }
}

class _DatePickerField extends StatelessWidget {
  const _DatePickerField({required this.value, required this.onTap});

  final DateTime? value;
  final VoidCallback onTap;

  String get _displayText {
    if (value == null) return 'DD/MM/YYYY';
    return '${value!.day.toString().padLeft(2, '0')}/'
        '${value!.month.toString().padLeft(2, '0')}/'
        '${value!.year}';
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
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: CustomerColors.line),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  color: CustomerColors.muted,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Text(
                  _displayText,
                  style: TextStyle(
                    color: value != null
                        ? CustomerColors.ink
                        : CustomerColors.muted,
                    fontSize: 13,
                    fontWeight:
                        value != null ? FontWeight.w700 : FontWeight.w500,
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

class _GenderDropdown extends StatelessWidget {
  const _GenderDropdown({required this.value, required this.onChanged});

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
            border: Border.all(color: CustomerColors.line),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: CustomerColors.muted,
              ),
              items: const [
                DropdownMenuItem(value: 'Male', child: Text('पुरुष / Male')),
                DropdownMenuItem(
                  value: 'Female',
                  child: Text('स्त्री / Female'),
                ),
                DropdownMenuItem(value: 'Other', child: Text('इतर / Other')),
              ],
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class _AadhaarCaptureTile extends StatelessWidget {
  const _AadhaarCaptureTile({
    required this.onTap,
    this.imagePath,
  });

  final VoidCallback onTap;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final captured = imagePath != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: captured
              ? CustomerColors.green.withValues(alpha: 0.06)
              : CustomerColors.cream,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: captured
                ? CustomerColors.green.withValues(alpha: 0.4)
                : CustomerColors.gold.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            if (captured)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(imagePath!),
                  width: 46,
                  height: 46,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: CustomerColors.navy,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.document_scanner_outlined,
                  color: CustomerColors.gold,
                  size: 24,
                ),
              ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    captured
                        ? 'आधार फोटो कॅप्चर झाला'
                        : 'आधार कार्ड फोटो काढा',
                    style: TextStyle(
                      color: captured
                          ? CustomerColors.green
                          : CustomerColors.ink,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    captured
                        ? 'Aadhaar photo captured · Tap to retake'
                        : 'Capture Aadhaar card photo',
                    style: const TextStyle(
                      color: CustomerColors.muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (!captured) ...[
                    const SizedBox(height: 4),
                    const Text(
                      'खाली Aadhaar नंबर टाका / Enter Aadhaar number below',
                      style: TextStyle(
                        color: CustomerColors.muted,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              captured ? Icons.check_circle : Icons.arrow_forward_ios,
              color: captured ? CustomerColors.green : CustomerColors.muted,
              size: captured ? 22 : 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomerPhotoTile extends StatelessWidget {
  const _CustomerPhotoTile({
    required this.onTap,
    this.imagePath,
  });

  final VoidCallback onTap;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final captured = imagePath != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: captured
                ? CustomerColors.green.withValues(alpha: 0.4)
                : CustomerColors.line,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: captured
                  ? Image.file(
                      File(imagePath!),
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: CustomerColors.navy.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: CustomerColors.navy,
                        size: 28,
                      ),
                    ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    captured ? 'फोटो कॅप्चर झाला' : 'ग्राहकाचा फोटो काढा',
                    style: TextStyle(
                      color: captured
                          ? CustomerColors.green
                          : CustomerColors.ink,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    captured
                        ? 'Capture Customer Photo · Tap to retake'
                        : 'Capture Customer Photo',
                    style: const TextStyle(
                      color: CustomerColors.muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              captured ? Icons.check_circle : Icons.add_a_photo_outlined,
              color: captured ? CustomerColors.green : CustomerColors.muted,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
