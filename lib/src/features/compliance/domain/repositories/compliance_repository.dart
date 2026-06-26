import '../../../../core/errors/result.dart';
import '../entities/compliance_entities.dart';

abstract class ComplianceRepository {
  Future<Result<ComplianceDashboardStats>> getDashboardStats();
  Future<Result<Form9Register>> getForm9Register({
    String? from,
    String? to,
  });
  Future<Result<bool>> generateForm(String formType);
}
