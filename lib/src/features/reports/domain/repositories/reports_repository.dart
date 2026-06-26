import '../../../../core/errors/result.dart';
import '../entities/reports_entities.dart';

abstract class ReportsRepository {
  Future<Result<ReportsDashboardData>> getDashboardData({String? period});
}
