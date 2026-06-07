import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  static const routeName = 'inventory';

  @override
  Widget build(BuildContext context) {
    const items = [
      InventoryItem(name: '22K Gold Bangles', sku: 'GLD-BNG-22K', stock: 42),
      InventoryItem(name: 'Diamond Necklace', sku: 'DIA-NCK-001', stock: 8),
      InventoryItem(name: 'Platinum Rings', sku: 'PLT-RNG-950', stock: 16),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        leading: IconButton(
          onPressed: () => context.go('/'),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.diamond_outlined)),
              title: Text(item.name),
              subtitle: Text(item.sku),
              trailing: Text('${item.stock} pcs'),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemCount: items.length,
      ),
    );
  }
}

class InventoryItem {
  const InventoryItem({
    required this.name,
    required this.sku,
    required this.stock,
  });

  final String name;
  final String sku;
  final int stock;
}
