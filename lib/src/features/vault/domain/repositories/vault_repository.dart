import '../../../../core/errors/result.dart';
import '../entities/vault_search_result.dart';
import '../entities/vault_slot.dart';

abstract class VaultRepository {
  Future<Result<List<VaultOccupancy>>> getOccupancy();
  Future<Result<List<VaultSearchResult>>> searchVault({
    required String query,
    required String searchMode,
  });
  Future<Result<List<String>>> getVaults();
  Future<Result<List<String>>> getSafes(String vault);
  Future<Result<List<String>>> getTrays(String vault, String safe);
  Future<Result<List<VaultSlot>>> getSlots(String vault, String safe, String tray);
  Future<Result<String>> assignSlot({required String coordinate});
}
