import '../../../../core/errors/result.dart';
import '../entities/dashboard_summary.dart';

abstract class DashboardRepository {
  Future<Result<DashboardSummary>> getDashboardSummary();
}
