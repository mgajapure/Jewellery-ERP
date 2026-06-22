import '../../../../core/errors/result.dart';
import '../entities/dashboard_summary.dart';

/// Dashboard repository contract.
abstract class DashboardRepository {
  Future<Result<DashboardSummary>> getSummary();
}
