import '../../../../core/errors/result.dart';
import '../entities/interest_ledger.dart';

abstract class InterestRepository {
  Future<Result<InterestLedger>> getLedger(String girviId);
}
