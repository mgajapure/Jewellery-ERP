import 'package:equatable/equatable.dart';

enum GirviStatus { active, partialPaid, renewed, redeemed, overdue }

enum MetalType { gold, silver, platinum, other }

enum PaymentType { cash, upi, bankTransfer, cheque }

enum InterestType { simple, katmiti, daily }

class GirviItem extends Equatable {
  const GirviItem({
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

  @override
  List<Object?> get props => [
    id, description, itemType, quantity, grossWeightG, stoneWeightG,
    netWeightG, purity, metalType, valuationAmount, photoUrls,
  ];
}

class GirviPayment extends Equatable {
  const GirviPayment({
    required this.id,
    required this.amount,
    required this.principalPaid,
    required this.interestPaid,
    required this.paymentType,
    required this.paidAt,
    this.referenceNumber,
    this.notes,
  });

  final String id;
  final double amount;
  final double principalPaid;
  final double interestPaid;
  final PaymentType paymentType;
  final DateTime paidAt;
  final String? referenceNumber;
  final String? notes;

  @override
  List<Object?> get props => [
    id, amount, principalPaid, interestPaid, paymentType,
    paidAt, referenceNumber, notes,
  ];
}

class Girvi extends Equatable {
  const Girvi({
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
  final List<GirviItem> items;
  final List<GirviPayment> payments;
  final String? vaultLocation;
  final String? kfsDocUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  @override
  List<Object?> get props => [
    id, serialId, tenantId, customerId, customerName, customerNameEn,
    customerMobile, status, loanAmount, outstandingAmount, accruedInterest,
    penaltyAmount, interestRate, interestType, penaltyRate, startDate, dueDate,
    daysLeft, items, payments, vaultLocation, kfsDocUrl, createdAt, updatedAt,
    version,
  ];
}
