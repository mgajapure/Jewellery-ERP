import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/injection.dart';
import '../../../core/navigation/app_navigation.dart';
import '../domain/entities/customer.dart';
import '../presentation/bloc/customer_detail_bloc.dart';
import '../presentation/bloc/customer_detail_event.dart';
import '../presentation/bloc/customer_detail_state.dart';
import '../theme/customer_colors.dart';
import 'customer_details_page.dart';

class EditCustomerPage extends StatelessWidget {
  const EditCustomerPage({super.key});

  static const routeName = 'edit-customer';

  @override
  Widget build(BuildContext context) {
    final customer = GoRouterState.of(context).extra as Customer;
    return BlocProvider(
      create: (_) => getIt<CustomerDetailBloc>(),
      child: _EditCustomerView(customer: customer),
    );
  }
}

class _EditCustomerView extends StatefulWidget {
  const _EditCustomerView({required this.customer});

  final Customer customer;

  @override
  State<_EditCustomerView> createState() => _EditCustomerViewState();
}

class _EditCustomerViewState extends State<_EditCustomerView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _altMobileController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _pincodeController;
  late final TextEditingController _panController;
  String _selectedGender = 'Male';
  DateTime? _selectedDob;

  // Parses "Street, City, State - Pincode" stored format back into parts.
  static ({String street, String city, String state, String pincode})
      _parseAddress(String address) {
    try {
      final dashIdx = address.lastIndexOf(' - ');
      final pincode = dashIdx >= 0 ? address.substring(dashIdx + 3).trim() : '';
      final withoutPin = dashIdx >= 0 ? address.substring(0, dashIdx).trim() : address;
      final lastComma = withoutPin.lastIndexOf(', ');
      final state = lastComma >= 0 ? withoutPin.substring(lastComma + 2).trim() : '';
      final withoutState = lastComma >= 0 ? withoutPin.substring(0, lastComma).trim() : withoutPin;
      final secondLast = withoutState.lastIndexOf(', ');
      final city = secondLast >= 0 ? withoutState.substring(secondLast + 2).trim() : '';
      final street = secondLast >= 0 ? withoutState.substring(0, secondLast).trim() : withoutState;
      return (street: street, city: city, state: state, pincode: pincode);
    } catch (_) {
      return (street: address, city: '', state: '', pincode: '');
    }
  }

  @override
  void initState() {
    super.initState();
    final c = widget.customer;
    _nameController = TextEditingController(text: c.nameEn);
    _altMobileController =
        TextEditingController(text: c.alternateMobile ?? '');
    final parsed = _parseAddress(c.address);
    _addressController = TextEditingController(text: parsed.street);
    _cityController = TextEditingController(text: parsed.city);
    _stateController = TextEditingController(text: parsed.state);
    _pincodeController = TextEditingController(text: parsed.pincode);
    _panController = TextEditingController(text: c.panNumber ?? '');
    _selectedDob = c.dateOfBirth;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _altMobileController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _panController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final initial = _selectedDob ?? DateTime(1990);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
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
    final request = UpdateCustomerRequest(
      id: widget.customer.id,
      name: _nameController.text.trim(),
      alternateMobile: _altMobileController.text.trim().isEmpty
          ? null
          : _altMobileController.text.trim(),
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      pincode: _pincodeController.text.trim(),
      gender: _selectedGender,
      dateOfBirth: _selectedDob?.toIso8601String().substring(0, 10),
      panNumber: _panController.text.trim().isEmpty
          ? null
          : _panController.text.trim(),
    );
    context.read<CustomerDetailBloc>().add(UpdateCustomer(request));
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
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
          if (context.canPop()) {
            context.pop();
          } else {
            context.goNamed(
              CustomerDetailsPage.routeName,
              pathParameters: {'id': state.customer.id},
            );
          }
        }
        if (state is CustomerOperationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: CustomerColors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
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
                  _EditCustomerHeader(customer: widget.customer),
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
                            validator: (v) =>
                                (v == null || v.trim().isEmpty)
                                    ? 'नाव आवश्यक आहे / Name is required'
                                    : null,
                          ),
                          const SizedBox(height: 14),
                          _ReadOnlyField(
                            label: 'मोबाईल नंबर / Mobile Number',
                            value: widget.customer.mobile,
                            prefixIcon: Icons.phone_outlined,
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
                          _AppTextField(
                            controller: _panController,
                            label: 'PAN क्रमांक / PAN Number',
                            hint: 'ABCDE1234F',
                            prefixIcon: Icons.credit_card_outlined,
                            textCapitalization:
                                TextCapitalization.characters,
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
                                    CustomerColors.navy.withValues(
                                        alpha: 0.6),
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
                                      'ग्राहक अपडेट करा / Update Customer',
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

class _EditCustomerHeader extends StatelessWidget {
  const _EditCustomerHeader({required this.customer});

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 14, 18, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => AppNavigation.popOrGoNamed(
              context,
              CustomerDetailsPage.routeName,
              pathParameters: {'id': customer.id},
            ),
            icon: const Icon(Icons.arrow_back,
                color: CustomerColors.ink),
            tooltip: 'Back',
          ),
          const Expanded(
            child: Text(
              'ग्राहक संपादित करा / Edit Customer',
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

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({
    required this.label,
    required this.value,
    required this.prefixIcon,
  });

  final String label;
  final String value;
  final IconData prefixIcon;

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
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          decoration: BoxDecoration(
            color: CustomerColors.screenBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: CustomerColors.line),
          ),
          child: Row(
            children: [
              Icon(prefixIcon, color: CustomerColors.muted, size: 22),
              const SizedBox(width: 12),
              Text(
                value,
                style: const TextStyle(
                  color: CustomerColors.muted,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              const Icon(Icons.lock_outline,
                  size: 16, color: CustomerColors.muted),
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
    this.inputFormatters,
    this.maxLength,
    this.maxLines = 1,
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
              borderSide:
                  const BorderSide(color: CustomerColors.line),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: CustomerColors.line),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: CustomerColors.navy, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: CustomerColors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: CustomerColors.red, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
                vertical: 16, horizontal: 14),
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
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: CustomerColors.line),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined,
                    color: CustomerColors.muted, size: 22),
                const SizedBox(width: 12),
                Text(
                  _displayText,
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

class _GenderDropdown extends StatelessWidget {
  const _GenderDropdown(
      {required this.value, required this.onChanged});

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
          padding:
              const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
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
