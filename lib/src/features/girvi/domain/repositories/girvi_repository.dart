import '../../../../core/errors/result.dart';
import '../entities/girvi.dart';

class GirviItemRequest {
  const GirviItemRequest({
    required this.itemType,
    required this.description,
    required this.quantity,
    required this.grossWeightG,
    required this.stoneWeightG,
    required this.netWeightG,
    required this.purity,
    required this.metalType,
    this.photoPaths = const [],
  });

  final String itemType;
  final String description;
  final int quantity;
  final double grossWeightG;
  final double stoneWeightG;
  final double netWeightG;
  final String purity;
  final MetalType metalType;
  final List<String> photoPaths;
}

class CreateGirviRequest {
  const CreateGirviRequest({
    required this.customerId,
    required this.items,
    required this.loanAmount,
    required this.interestRate,
    required this.interestType,
    required this.startDate,
    required this.dueDate,
    required this.penaltyRate,
    this.vaultLocation,
  });

  final String customerId;
  final List<GirviItemRequest> items;
  final double loanAmount;
  final double interestRate;
  final InterestType interestType;
  final DateTime startDate;
  final DateTime dueDate;
  final double penaltyRate;
  final String? vaultLocation;
}

class PaymentRequest {
  const PaymentRequest({
    required this.amount,
    required this.paymentType,
    this.referenceNumber,
    this.notes,
  });

  final double amount;
  final PaymentType paymentType;
  final String? referenceNumber;
  final String? notes;
}

class RenewalRequest {
  const RenewalRequest({
    required this.newLoanAmount,
    required this.interestRate,
    required this.months,
    required this.interestType,
  });

  final double newLoanAmount;
  final double interestRate;
  final int months;
  final InterestType interestType;
}

class AuctionRequest {
  const AuctionRequest({
    required this.saleAmount,
    required this.buyerName,
    this.buyerMobile,
  });

  final double saleAmount;
  final String buyerName;
  final String? buyerMobile;
}

abstract class GirviRepository {
  Future<Result<List<Girvi>>> getGirviList({
    GirviStatus? statusFilter,
    String? searchQuery,
  });

  Future<Result<Girvi>> getGirviById(String id);

  Future<Result<List<Girvi>>> getDueGirvi();

  Future<Result<List<Girvi>>> getOverdueGirvi();

  Future<Result<void>> makePayment(String girviId, PaymentRequest request);

  Future<Result<Girvi>> renewGirvi(String girviId, RenewalRequest request);

  Future<Result<void>> redeemGirvi(String girviId);

  Future<Result<void>> completeAuction(String girviId, AuctionRequest request);

  Future<Result<Girvi>> createGirvi(CreateGirviRequest request);
}
