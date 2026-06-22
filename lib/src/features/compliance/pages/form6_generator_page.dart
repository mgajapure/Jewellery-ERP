import 'package:flutter/material.dart';

import '../../../core/navigation/app_navigation.dart';
import '../theme/compliance_colors.dart';
import 'compliance_dashboard_page.dart';

/// SCR-036 Form 6 Generator
///
/// Generates Money Lending License records for Maharashtra compliance.
class Form6GeneratorPage extends StatefulWidget {
  const Form6GeneratorPage({super.key});

  static const routeName = 'form6-generator';

  @override
  State<Form6GeneratorPage> createState() => _Form6GeneratorPageState();
}

class _Form6GeneratorPageState extends State<Form6GeneratorPage> {
  final TextEditingController _licenseController =
      TextEditingController(text: 'ML-2026-000123');
  final TextEditingController _businessController =
      TextEditingController(text: 'Shree Jewellers');
  final TextEditingController _ownerController =
      TextEditingController(text: 'Mayur Patil');
  final TextEditingController _addressController =
      TextEditingController(text: '123, MG Road, Pune, Maharashtra');

  @override
  void dispose() {
    _licenseController.dispose();
    _businessController.dispose();
    _ownerController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ComplianceColors.screenBg,
      appBar: AppBar(
        backgroundColor: ComplianceColors.navy,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => AppNavigation.popOrGoNamed(
            context,
            ComplianceDashboardPage.routeName,
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'फॉर्म ६ जनरेटर',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              'Form 6 Generator',
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
                    _SectionTitle(
                      titleMr: 'परवाना माहिती',
                      titleEn: 'License Information',
                    ),
                    const SizedBox(height: 12),
                    _InputField(
                      labelMr: 'परवाना क्रमांक',
                      labelEn: 'License Number',
                      controller: _licenseController,
                    ),
                    const SizedBox(height: 12),
                    _InputField(
                      labelMr: 'व्यवसायाचे नाव',
                      labelEn: 'Business Name',
                      controller: _businessController,
                    ),
                    const SizedBox(height: 12),
                    _InputField(
                      labelMr: 'मालकाचे नाव',
                      labelEn: 'Owner Name',
                      controller: _ownerController,
                    ),
                    const SizedBox(height: 12),
                    _InputField(
                      labelMr: 'पत्ता',
                      labelEn: 'Address',
                      controller: _addressController,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),
                    _PreviewCard(
                      license: _licenseController.text,
                      business: _businessController.text,
                      owner: _ownerController.text,
                      address: _addressController.text,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: preview generated PDF.
                      },
                      icon: const Icon(Icons.visibility_outlined, size: 18),
                      label: const Text('Preview'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ComplianceColors.navy,
                        side: const BorderSide(color: ComplianceColors.navy),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: generate Form 6 PDF.
                        },
                        icon: const Icon(Icons.picture_as_pdf_outlined, size: 20),
                        label: const Text(
                          'फॉर्म ६ तयार करा / Generate Form 6',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ComplianceColors.navy,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
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
            color: ComplianceColors.ink,
          ),
        ),
        Text(
          titleEn,
          style: const TextStyle(
            fontSize: 12,
            color: ComplianceColors.muted,
          ),
        ),
      ],
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.labelMr,
    required this.labelEn,
    required this.controller,
    this.maxLines = 1,
  });

  final String labelMr;
  final String labelEn;
  final TextEditingController controller;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ComplianceColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$labelMr / $labelEn',
            style: const TextStyle(
              fontSize: 11,
              color: ComplianceColors.muted,
            ),
          ),
          TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({
    required this.license,
    required this.business,
    required this.owner,
    required this.address,
  });

  final String license;
  final String business;
  final String owner;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ComplianceColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'पूर्वावलोकन / Preview',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: ComplianceColors.ink,
            ),
          ),
          const SizedBox(height: 16),
          _PreviewRow(label: 'License Number', value: license),
          const SizedBox(height: 10),
          _PreviewRow(label: 'Business Name', value: business),
          const SizedBox(height: 10),
          _PreviewRow(label: 'Owner Name', value: owner),
          const SizedBox(height: 10),
          _PreviewRow(label: 'Address', value: address),
        ],
      ),
    );
  }
}

class _PreviewRow extends StatelessWidget {
  const _PreviewRow({required this.label, required this.value});

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
            fontSize: 11,
            color: ComplianceColors.muted,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: ComplianceColors.ink,
          ),
        ),
      ],
    );
  }
}
