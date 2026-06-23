import '../../../../core/errors/result.dart';
import '../entities/girvi.dart';

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
}
