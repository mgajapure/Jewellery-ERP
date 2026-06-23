import '../../../../core/errors/result.dart';
import '../entities/inventory_item.dart';

abstract class InventoryRepository {
  Future<Result<List<InventoryItem>>> getItems({String? filter, String? query});
  Future<Result<InventoryItem>> getItemById(String id);
  Future<Result<InventoryItem>> getItemByBarcode(String barcode);
}
