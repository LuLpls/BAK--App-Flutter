// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Shopping Lists';

  @override
  String get settings => 'Settings';

  @override
  String get newList => 'New Shopping List';

  @override
  String get newItem => 'New Item';

  @override
  String get cancel => 'Cancel';

  @override
  String get add => 'Add';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get noLists => 'No shopping lists yet';

  @override
  String get noItems => 'No items yet';

  @override
  String get listNameHint => 'Enter list name';

  @override
  String get invalidListName => 'List name must be up to 30 characters';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get itemNameHint => 'Enter item name';

  @override
  String get invalidItemName => 'Item name must be up to 20 characters';

  @override
  String get quantityHint => 'Enter quantity';

  @override
  String get unitHint => 'Enter unit';

  @override
  String get invalidQuantity => 'Quantity must be a positive number';

  @override
  String get invalidUnit => 'Unit must be up to 10 characters';
}
