import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/item.dart';
import '../models/shopping_list.dart';
import '../l10n/app_localizations.dart';

class ListScreen extends StatefulWidget {
  final ShoppingList list;

  const ListScreen({super.key, required this.list});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final List<Item> _items = [];

  String get _storageKey => 'items_${widget.list.id}';

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_storageKey);
    if (data != null) {
      final decoded = jsonDecode(data) as List;
      setState(() {
        _items.clear();
        _items.addAll(decoded.map((e) => Item.fromJson(e)).toList());
        _sortItems();
      });
    }
  }

  Future<void> _saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = _items.map((e) => e.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(encoded));
  }

  void _sortItems() {
    _items.sort((a, b) {
      if (a.purchased == b.purchased) return 0;
      return a.purchased ? 1 : -1;
    });
  }

  void _addItem() {
    final localizations = AppLocalizations.of(context)!;
    final nameController = TextEditingController();
    final quantityController = TextEditingController();
    final unitController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(localizations.newItem),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: localizations.itemNameHint,
              ),
            ),
            TextField(
              controller: quantityController,
              decoration: InputDecoration(
                labelText: localizations.quantityHint,
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: unitController,
              decoration: const InputDecoration(labelText: 'Jednotka'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.cancel),
          ),
          TextButton(
            onPressed: () {
              final name = nameController.text.trim();
              final quantityText = quantityController.text.trim();
              final unit = unitController.text.trim();

              if (name.isEmpty || name.length > 30) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(localizations.invalidItemName)),
                );
                return;
              }

              if (unit.length > 10) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Jednotka max 10 znaků.')),
                );
                return;
              }

              final quantity = double.tryParse(quantityText);
              if (quantityText.isNotEmpty &&
                  (quantity == null || quantity < 0)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(localizations.invalidQuantity)),
                );
                return;
              }

              setState(() {
                _items.add(
                  Item(
                    id: DateTime.now().toIso8601String(),
                    name: name,
                    quantity: quantity,
                    unit: unit,
                  ),
                );
                _sortItems();
              });
              _saveItems();
              Navigator.pop(context);
            },
            child: Text(localizations.add),
          ),
        ],
      ),
    );
  }

  void _editItem(Item item) {
    final localizations = AppLocalizations.of(context)!;
    final nameController = TextEditingController(text: item.name);
    final quantityController = TextEditingController(
      text: item.quantity?.toString() ?? '',
    );
    final unitController = TextEditingController(text: item.unit ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(localizations.edit),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: localizations.itemNameHint,
              ),
            ),
            TextField(
              controller: quantityController,
              decoration: InputDecoration(
                labelText: localizations.quantityHint,
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: unitController,
              decoration: const InputDecoration(labelText: 'Jednotka'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.cancel),
          ),
          TextButton(
            onPressed: () {
              final name = nameController.text.trim();
              final quantityText = quantityController.text.trim();
              final unit = unitController.text.trim();

              if (name.isEmpty || name.length > 30) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(localizations.invalidItemName)),
                );
                return;
              }

              final quantity = double.tryParse(quantityText);
              if (quantityText.isNotEmpty &&
                  (quantity == null || quantity < 0)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(localizations.invalidQuantity)),
                );
                return;
              }

              setState(() {
                final index = _items.indexOf(item);
                _items[index] = Item(
                  id: item.id,
                  name: name,
                  quantity: quantity,
                  unit: unit,
                  purchased: item.purchased,
                );
                _sortItems();
              });
              _saveItems();
              Navigator.pop(context);
            },
            child: Text(localizations.save),
          ),
        ],
      ),
    );
  }

  void _deleteItem(Item item) {
    final localizations = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(localizations.delete),
        content: Text('${localizations.delete} "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.cancel),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _items.remove(item);
              });
              _saveItems();
              Navigator.pop(context);
            },
            child: Text(localizations.delete),
          ),
        ],
      ),
    );
  }

  void _togglePurchased(Item item) {
    setState(() {
      item.purchased = !item.purchased;
      _sortItems();
    });
    _saveItems();
  }

  void _showItemOptions(Item item) {
    final localizations = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: Text(localizations.edit),
              onTap: () {
                Navigator.pop(context);
                _editItem(item);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: Text(localizations.delete),
              onTap: () {
                Navigator.pop(context);
                _deleteItem(item);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(widget.list.title)),
      body: _items.isEmpty
          ? Center(child: Text(localizations.noItems))
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (ctx, i) {
                final item = _items[i];
                return GestureDetector(
                  onLongPress: () => _showItemOptions(item),
                  child: CheckboxListTile(
                    value: item.purchased,
                    onChanged: (_) => _togglePurchased(item),
                    title: Text(item.name),
                    subtitle: item.quantity != null
                        ? Text('${item.quantity} ${item.unit ?? ''}')
                        : null,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
    );
  }
}
