import 'package:equatable/equatable.dart';

import '../../domain/entities/girvi.dart';

class GirviItemDraft extends Equatable {
  const GirviItemDraft({
    required this.id,
    this.itemType = 'Chain',
    this.description = '',
    this.quantity = 1,
    this.grossWeightG = 0.0,
    this.stoneWeightG = 0.0,
    this.purity = '22K',
    this.metalType = MetalType.gold,
    this.photoPaths = const [],
  });

  final String id;
  final String itemType;
  final String description;
  final int quantity;
  final double grossWeightG;
  final double stoneWeightG;
  final String purity;
  final MetalType metalType;
  final List<String> photoPaths;

  double get netWeightG => (grossWeightG - stoneWeightG).clamp(0.0, double.infinity);

  double get purityFactor {
    switch (purity) {
      case '24K': return 1.0;
      case '22K': return 22 / 24;
      case '20K': return 20 / 24;
      default: return 18 / 24;
    }
  }

  double valuationAt(double goldRatePerGram24K) => netWeightG * purityFactor * goldRatePerGram24K;

  GirviItemDraft copyWith({
    String? itemType,
    String? description,
    int? quantity,
    double? grossWeightG,
    double? stoneWeightG,
    String? purity,
    MetalType? metalType,
    List<String>? photoPaths,
  }) {
    return GirviItemDraft(
      id: id,
      itemType: itemType ?? this.itemType,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      grossWeightG: grossWeightG ?? this.grossWeightG,
      stoneWeightG: stoneWeightG ?? this.stoneWeightG,
      purity: purity ?? this.purity,
      metalType: metalType ?? this.metalType,
      photoPaths: photoPaths ?? this.photoPaths,
    );
  }

  @override
  List<Object?> get props => [
    id, itemType, description, quantity, grossWeightG, stoneWeightG,
    purity, metalType, photoPaths,
  ];
}

sealed class CreateGirviState extends Equatable {
  const CreateGirviState();

  @override
  List<Object?> get props => [];
}

class CreateGirviDraft extends CreateGirviState {
  const CreateGirviDraft({
    this.customerId,
    this.customerName,
    this.customerNameEn,
    this.customerMobile,
    this.items = const [],
    this.goldRatePerGram = 7185.0,
    this.selectedLtvPercent = 65.0,
    this.manualLoanAmount,
    this.interestRate = 18.0,
    this.interestType = InterestType.simple,
    required this.startDate,
    required this.dueDate,
    this.penaltyRate = 2.0,
    this.kfsAccepted = false,
    this.vaultLocation = 'VA-A/SF-02/TR-05/SL-18',
  });

  final String? customerId;
  final String? customerName;
  final String? customerNameEn;
  final String? customerMobile;
  final List<GirviItemDraft> items;
  final double goldRatePerGram;
  final double selectedLtvPercent;
  final double? manualLoanAmount;
  final double interestRate;
  final InterestType interestType;
  final DateTime startDate;
  final DateTime dueDate;
  final double penaltyRate;
  final bool kfsAccepted;
  final String vaultLocation;

  double get totalValuation => items.fold(0.0, (sum, item) => sum + item.valuationAt(goldRatePerGram));
  double get suggestedLoanAmount => (totalValuation * selectedLtvPercent / 100).floorToDouble();
  double get effectiveLoanAmount => manualLoanAmount ?? suggestedLoanAmount;
  bool get hasCustomer => customerId != null;
  bool get hasItems => items.isNotEmpty;

  CreateGirviDraft copyWith({
    String? customerId,
    String? customerName,
    String? customerNameEn,
    String? customerMobile,
    List<GirviItemDraft>? items,
    double? goldRatePerGram,
    double? selectedLtvPercent,
    Object? manualLoanAmount = _sentinel,
    double? interestRate,
    InterestType? interestType,
    DateTime? startDate,
    DateTime? dueDate,
    double? penaltyRate,
    bool? kfsAccepted,
    String? vaultLocation,
  }) {
    return CreateGirviDraft(
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerNameEn: customerNameEn ?? this.customerNameEn,
      customerMobile: customerMobile ?? this.customerMobile,
      items: items ?? this.items,
      goldRatePerGram: goldRatePerGram ?? this.goldRatePerGram,
      selectedLtvPercent: selectedLtvPercent ?? this.selectedLtvPercent,
      manualLoanAmount: manualLoanAmount == _sentinel
          ? this.manualLoanAmount
          : manualLoanAmount as double?,
      interestRate: interestRate ?? this.interestRate,
      interestType: interestType ?? this.interestType,
      startDate: startDate ?? this.startDate,
      dueDate: dueDate ?? this.dueDate,
      penaltyRate: penaltyRate ?? this.penaltyRate,
      kfsAccepted: kfsAccepted ?? this.kfsAccepted,
      vaultLocation: vaultLocation ?? this.vaultLocation,
    );
  }

  @override
  List<Object?> get props => [
    customerId, customerName, customerNameEn, customerMobile,
    items, goldRatePerGram, selectedLtvPercent, manualLoanAmount,
    interestRate, interestType, startDate, dueDate, penaltyRate,
    kfsAccepted, vaultLocation,
  ];
}

class CreateGirviSubmitting extends CreateGirviState {
  const CreateGirviSubmitting(this.draft);

  final CreateGirviDraft draft;

  @override
  List<Object?> get props => [draft];
}

class CreateGirviSuccess extends CreateGirviState {
  const CreateGirviSuccess(this.girvi);

  final Girvi girvi;

  @override
  List<Object?> get props => [girvi];
}

class CreateGirviError extends CreateGirviState {
  const CreateGirviError({required this.message, required this.draft});

  final String message;
  final CreateGirviDraft draft;

  @override
  List<Object?> get props => [message, draft];
}

const _sentinel = Object();
