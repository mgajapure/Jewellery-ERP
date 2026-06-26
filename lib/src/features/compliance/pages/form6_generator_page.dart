import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/widgets/app_header.dart';
import '../presentation/bloc/generate_form_bloc.dart';
import '../theme/compliance_colors.dart';
import 'compliance_dashboard_page.dart';

/// SCR-036 Form 6 Generator
///
/// Generates Money Lending License records for Maharashtra compliance.
class Form6GeneratorPage extends StatelessWidget {
  const Form6GeneratorPage({super.key});

  static const routeName = 'form6-generator';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<GenerateFormBloc>(),
      child: const _Form6Scaffold(),
    );
  }
}

class _Form6Scaffold extends StatefulWidget {
  const _Form6Scaffold();

  @override
  State<_Form6Scaffold> createState() => _Form6ScaffoldState();
}

class _Form6ScaffoldState extends State<_Form6Scaffold> {
  final _licenseController =
      TextEditingController(text: 'ML-2026-000123');
  final _businessController =
      TextEditingController(text: 'Shree Jewellers');
  final _ownerController =
      TextEditingController(text: 'Mayur Patil');
  final _addressController =
      TextEditingController(text: '123, MG Road, Pune, Maharashtra');

  @override
  void dispose() {
    _licenseController.dispose();
    _businessController.dispose();
    _ownerController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _generate() {
    context
        .read<GenerateFormBloc>()
        .add(GenerateFormSubmitted(formType: 'FORM6'));
  }

  void _showSuccess(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.check_circle_outline,
                color: ComplianceColors.green, size: 28),
            SizedBox(width: 10),
            Text(
              'यशस्वी / Success',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: ComplianceColors.ink),
            ),
          ],
        ),
        content: const Text(
          'फॉर्म ६ यशस्वीरित्या तयार केला.\nForm 6 has been generated successfully.',
          style:
              TextStyle(fontSize: 14, color: ComplianceColors.muted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'ठीक आहे / OK',
              style: TextStyle(
                  color: ComplianceColors.navy,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GenerateFormBloc, GenerateFormState>(
      listener: (context, state) {
        if (state is GenerateFormSuccess) {
          _showSuccess(context);
        } else if (state is GenerateFormError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: ComplianceColors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: ComplianceColors.screenBg,
        body: SafeArea(
          child: Column(
            children: [
              AppHeader(
                titleMr: 'फॉर्म ६ जनरेटर',
                titleEn: 'Form 6 Generator',
                showBackButton: true,
                backFallbackRoute: ComplianceDashboardPage.routeName,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SectionTitle(
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
              BlocBuilder<GenerateFormBloc, GenerateFormState>(
                builder: (context, state) {
                  final isLoading = state is GenerateFormLoading;
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: isLoading ? null : () {},
                            icon: const Icon(
                                Icons.visibility_outlined,
                                size: 18),
                            label: const Text('Preview'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: ComplianceColors.navy,
                              side: const BorderSide(
                                  color: ComplianceColors.navy),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed: isLoading ? null : _generate,
                              icon: isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.picture_as_pdf_outlined,
                                      size: 20),
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
                                    borderRadius:
                                        BorderRadius.circular(12)),
                                elevation: 0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
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
              fontSize: 12, color: ComplianceColors.muted),
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
                fontSize: 11, color: ComplianceColors.muted),
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
              fontSize: 11, color: ComplianceColors.muted),
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
