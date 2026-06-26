import '../../../../core/errors/result.dart';
import '../entities/savings_entities.dart';

abstract class SavingsRepository {
  Future<Result<SavingsDashboardStats>> getDashboardStats();
}
