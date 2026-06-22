import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/navigation/app_navigation.dart';
import '../theme/customer_colors.dart';
import 'customer_details_page.dart';
import 'customer_list_page.dart';

class CreateCustomerPage extends StatefulWidget {
  const CreateCustomerPage({super.key});

  static const routeName = 'create-customer';

  @override
  State<CreateCustomerPage> createState() => _CreateCustomerPageState();
}

class _CreateCustomerPageState extends State<CreateCustomerPage> {
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _altMobileController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _panController = TextEditingController();

  String _selectedGender = 'पुरुष / Male';

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomerColors.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            const _CreateCustomerHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
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
                  ),
                  const SizedBox(height: 14),
                  _AppTextField(
                    controller: _mobileController,
                    label: 'मोबाईल नंबर / Mobile Number',
                    hint: '10 अंकी मोबाईल नंबर',
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 10,
                  ),
                  const SizedBox(height: 14),
                  _AppTextField(
                    controller: _altMobileController,
                    label: 'पर्यायी मोबाईल / Alternate Mobile',
                    hint: 'पर्यायी मोबाईल नंबर (ऐच्छिक)',
                    prefixIcon: Icons.phone_android_outlined,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 10,
                  ),
                  const SizedBox(height: 14),
                  _GenderDropdown(
                    value: _selectedGender,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedGender = value);
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  _AppTextField(
                    label: 'जन्मतारीख / Date of Birth',
                    hint: 'DD/MM/YYYY',
                    prefixIcon: Icons.calendar_today_outlined,
                    readOnly: true,
                    onTap: () {},
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
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          maxLength: 6,
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
                  ),
                  const SizedBox(height: 22),
                  const _SectionTitle(
                    titleMr: 'KYC माहिती',
                    titleEn: 'KYC Information',
                  ),
                  const SizedBox(height: 12),
                  const _AadhaarCaptureTile(),
                  const SizedBox(height: 14),
                  _AppTextField(
                    controller: _panController,
                    label: 'PAN क्रमांक / PAN Number',
                    hint: 'ABCDE1234F (₹50,000 पेक्षा जास्त व्यवहारासाठी अनिवार्य)',
                    prefixIcon: Icons.credit_card_outlined,
                    textCapitalization: TextCapitalization.characters,
                  ),
                  const SizedBox(height: 14),
                  _CustomerPhotoTile(
                    onTap: () {},
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => context.goNamed(CustomerDetailsPage.routeName),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomerColors.navy,
                        foregroundColor: CustomerColors.gold,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
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
          ],
        ),
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
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
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
              borderSide: const BorderSide(color: CustomerColors.navy, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
            counterText: '',
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
              icon: const Icon(Icons.keyboard_arrow_down, color: CustomerColors.muted),
              items: const [
                DropdownMenuItem(
                  value: 'पुरुष / Male',
                  child: Text('पुरुष / Male'),
                ),
                DropdownMenuItem(
                  value: 'स्त्री / Female',
                  child: Text('स्त्री / Female'),
                ),
                DropdownMenuItem(
                  value: 'इतर / Other',
                  child: Text('इतर / Other'),
                ),
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
  const _AadhaarCaptureTile();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: CustomerColors.cream,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: CustomerColors.gold.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
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
                children: const [
                  Text(
                    'आधार OCR स्कॅन करा',
                    style: TextStyle(
                      color: CustomerColors.ink,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Scan Aadhaar with OCR',
                    style: TextStyle(
                      color: CustomerColors.muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'माहिती आपोआप भरली जाईल / Details will auto-fill',
                    style: TextStyle(
                      color: CustomerColors.muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: CustomerColors.muted,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomerPhotoTile extends StatelessWidget {
  const _CustomerPhotoTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: CustomerColors.line),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: CustomerColors.navy.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.camera_alt_outlined,
                color: CustomerColors.navy,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'ग्राहकाचा फोटो काढा',
                    style: TextStyle(
                      color: CustomerColors.ink,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Capture Customer Photo',
                    style: TextStyle(
                      color: CustomerColors.muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.add_a_photo_outlined,
              color: CustomerColors.muted,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
