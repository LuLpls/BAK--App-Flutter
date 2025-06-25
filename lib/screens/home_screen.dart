import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/shopping_list.dart';
import 'list_screen.dart';
import 'settings_screen.dart';
import '../l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<ShoppingList> _shoppingLists = [];

  @override
  void initState() {
    super.initState();
    _loadListsFromStorage();
  }

  Future<void> _loadListsFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('shoppingLists');
    if (data != null) {
      final decoded = jsonDecode(data) as List;
      setState(() {
        _shoppingLists.clear();
        _shoppingLists.addAll(
          decoded.map((json) => ShoppingList.fromJson(json)).toList(),
        );
      });
    }
  }

  Future<void> _saveListsToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = _shoppingLists.map((s) => s.toJson()).toList();
    await prefs.setString('shoppingLists', jsonEncode(encoded));
  }

  void _addShoppingList() {
    final localizations = AppLocalizations.of(context)!;
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(localizations.newList),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: localizations.listNameHint),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.cancel),
          ),
          TextButton(
            onPressed: () {
              final input = controller.text.trim();
              final title = input.isEmpty ? localizations.newList : input;

              if (title.length > 30) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(localizations.invalidListName)),
                );
                return;
              }

              setState(() {
                _shoppingLists.add(
                  ShoppingList(
                    id: DateTime.now().toIso8601String(),
                    title: title,
                  ),
                );
              });
              _saveListsToStorage();
              Navigator.pop(context);
            },
            child: Text(localizations.add),
          ),
        ],
      ),
    );
  }

  void _editShoppingList(ShoppingList list) {
    final localizations = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: list.title);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(localizations.edit),
        content: TextField(
          controller: controller,
          maxLength: 30,
          decoration: InputDecoration(hintText: localizations.listNameHint),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.cancel),
          ),
          TextButton(
            onPressed: () {
              final newTitle = controller.text.trim();
              if (newTitle.isEmpty || newTitle.length > 30) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(localizations.invalidListName)),
                );
                return;
              }

              setState(() {
                final index = _shoppingLists.indexOf(list);
                _shoppingLists[index] = ShoppingList(
                  id: list.id,
                  title: newTitle,
                );
              });
              _saveListsToStorage();
              Navigator.pop(context);
            },
            child: Text(localizations.save),
          ),
        ],
      ),
    );
  }

  void _deleteShoppingList(ShoppingList list) {
    final localizations = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(localizations.delete),
        content: Text('${localizations.delete} "${list.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.cancel),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _shoppingLists.remove(list);
              });
              _saveListsToStorage();
              Navigator.pop(context);
            },
            child: Text(localizations.delete),
          ),
        ],
      ),
    );
  }

  void _showListOptions(ShoppingList list) {
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
                _editShoppingList(list);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: Text(localizations.delete),
              onTap: () {
                Navigator.pop(context);
                _deleteShoppingList(list);
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
      appBar: AppBar(
        title: Text(localizations.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: _shoppingLists.isEmpty
          ? Center(child: Text(localizations.noLists))
          : ListView.builder(
              itemCount: _shoppingLists.length,
              itemBuilder: (ctx, i) {
                final list = _shoppingLists[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(list.title),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ListScreen(list: list),
                          ),
                        );
                      },
                      onLongPress: () => _showListOptions(list),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addShoppingList,
        child: const Icon(Icons.add),
      ),
    );
  }
}
