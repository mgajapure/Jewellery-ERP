import '../../domain/entities/girvi.dart';

class GirviItemModel {
  const GirviItemModel({
    required this.id,
    required this.description,
    required this.itemType,
    required this.quantity,
    required this.grossWeightG,
    required this.stoneWeightG,
    required this.netWeightG,
    required this.purity,
    required this.metalType,
    required this.valuationAmount,
    this.photoUrls = const [],
  });

  factory GirviItemModel.fromJson(Map<String, dynamic> json) {
    return GirviItemModel(
      id: json['id'] as String,
      description: json['description'] as String,
      itemType: json['itemType'] as String,
      quantity: json['quantity'] as int,
      grossWeightG: (json['grossWeightG'] as num).toDouble(),
      stoneWeightG: (json['stoneWeightG'] as num).toDouble(),
      netWeightG: (json['netWeightG'] as num).toDouble(),
      purity: json['purity'] as String,
      metalType: MetalType.values.firstWhere(
        (e) => e.name == json['metalType'],
        orElse: () => MetalType.gold,
      ),
      valuationAmount: (json['valuationAmount'] as num).toDouble(),
      photoUrls: (json['photoUrls'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  final String id;
  final String description;
  final String itemType;
  final int quantity;
  final double grossWeightG;
  final double stoneWeightG;
  final double netWeightG;
  final String purity;
  final MetalType metalType;
  final double valuationAmount;
  final List<String> photoUrls;

  GirviItem toEntity() => GirviItem(
    id: id,
    description: description,
    itemType: itemType,
    quantity: quantity,
    grossWeightG: grossWeightG,
    stoneWeightG: stoneWeightG,
    netWeightG: netWeightG,
    purity: purity,
    metalType: metalType,
    valuationAmount: valuationAmount,
    photoUrls: photoUrls,
  );
}

class GirviPaymentModel {
  const GirviPaymentModel({
    required this.id,
    required this.amount,
    required this.principalPaid,
    required this.interestPaid,
    required this.paymentType,
    required this.paidAt,
    this.referenceNumber,
    this.notes,
  });

  factory GirviPaymentModel.fromJson(Map<String, dynamic> json) {
    return GirviPaymentModel(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      principalPaid: (json['principalPaid'] as num).toDouble(),
      interestPaid: (json['interestPaid'] as num).toDouble(),
      paymentType: PaymentType.values.firstWhere(
        (e) => e.name == json['paymentType'],
        orElse: () => PaymentType.cash,
      ),
      paidAt: DateTime.parse(json['paidAt'] as String),
      referenceNumber: json['referenceNumber'] as String?,
      notes: json['notes'] as String?,
    );
  }

  final String id;
  final double amount;
  final double principalPaid;
  final double interestPaid;
  final PaymentType paymentType;
  final DateTime paidAt;
  final String? referenceNumber;
  final String? notes;

  GirviPayment toEntity() => GirviPayment(
    id: id,
    amount: amount,
    principalPaid: principalPaid,
    interestPaid: interestPaid,
    paymentType: paymentType,
    paidAt: paidAt,
    referenceNumber: referenceNumber,
    notes: notes,
  );
}

class GirviModel {
  const GirviModel({
    required this.id,
    required this.serialId,
    required this.tenantId,
    required this.customerId,
    required this.customerName,
    required this.customerNameEn,
    required this.customerMobile,
    required this.status,
    required this.loanAmount,
    required this.outstandingAmount,
    required this.accruedInterest,
    required this.penaltyAmount,
    required this.interestRate,
    required this.interestType,
    required this.penaltyRate,
    required this.startDate,
    required this.dueDate,
    required this.daysLeft,
    required this.items,
    this.payments = const [],
    this.vaultLocation,
    this.kfsDocUrl,
    required this.createdAt,
    required this.updatedAt,
    this.version = 1,
  });

  factory GirviModel.fromJson(Map<String, dynamic> json) {
    return GirviModel(
      id: json['id'] as String,
      serialId: json['serialId'] as String,
      tenantId: json['tenantId'] as String,
      customerId: json['customerId'] as String,
      customerName: json['customerName'] as String,
      customerNameEn: json['customerNameEn'] as String,
      customerMobile: json['customerMobile'] as String,
      status: GirviStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => GirviStatus.active,
      ),
      loanAmount: (json['loanAmount'] as num).toDouble(),
      outstandingAmount: (json['outstandingAmount'] as num).toDouble(),
      accruedInterest: (json['accruedInterest'] as num).toDouble(),
      penaltyAmount: (json['penaltyAmount'] as num).toDouble(),
      interestRate: (json['interestRate'] as num).toDouble(),
      interestType: InterestType.values.firstWhere(
        (e) => e.name == json['interestType'],
        orElse: () => InterestType.simple,
      ),
      penaltyRate: (json['penaltyRate'] as num).toDouble(),
      startDate: DateTime.parse(json['startDate'] as String),
      dueDate: DateTime.parse(json['dueDate'] as String),
      daysLeft: json['daysLeft'] as int,
      items: (json['items'] as List<dynamic>)
          .map((e) => GirviItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      payments: (json['payments'] as List<dynamic>?)
              ?.map(
                (e) => GirviPaymentModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      vaultLocation: json['vaultLocation'] as String?,
      kfsDocUrl: json['kfsDocUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      version: json['version'] as int? ?? 1,
    );
  }

  final String id;
  final String serialId;
  final String tenantId;
  final String customerId;
  final String customerName;
  final String customerNameEn;
  final String customerMobile;
  final GirviStatus status;
  final double loanAmount;
  final double outstandingAmount;
  final double accruedInterest;
  final double penaltyAmount;
  final double interestRate;
  final InterestType interestType;
  final double penaltyRate;
  final DateTime startDate;
  final DateTime dueDate;
  final int daysLeft;
  final List<GirviItemModel> items;
  final List<GirviPaymentModel> payments;
  final String? vaultLocation;
  final String? kfsDocUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  Girvi toEntity() => Girvi(
    id: id,
    serialId: serialId,
    tenantId: tenantId,
    customerId: customerId,
    customerName: customerName,
    customerNameEn: customerNameEn,
    customerMobile: customerMobile,
    status: status,
    loanAmount: loanAmount,
    outstandingAmount: outstandingAmount,
    accruedInterest: accruedInterest,
    penaltyAmount: penaltyAmount,
    interestRate: interestRate,
    interestType: interestType,
    penaltyRate: penaltyRate,
    startDate: startDate,
    dueDate: dueDate,
    daysLeft: daysLeft,
    items: items.map((e) => e.toEntity()).toList(),
    payments: payments.map((e) => e.toEntity()).toList(),
    vaultLocation: vaultLocation,
    kfsDocUrl: kfsDocUrl,
    createdAt: createdAt,
    updatedAt: updatedAt,
    version: version,
  );
}
