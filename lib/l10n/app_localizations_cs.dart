// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get appTitle => 'Nákupní seznamy';

  @override
  String get settings => 'Nastavení';

  @override
  String get newList => 'Nový nákupní seznam';

  @override
  String get newItem => 'Nová položka';

  @override
  String get cancel => 'Zrušit';

  @override
  String get add => 'Přidat';

  @override
  String get edit => 'Upravit';

  @override
  String get delete => 'Smazat';

  @override
  String get save => 'Uložit';

  @override
  String get noLists => 'Zatím žádné seznamy';

  @override
  String get noItems => 'Zatím žádné položky';

  @override
  String get listNameHint => 'Zadej název seznamu';

  @override
  String get invalidListName => 'Název seznamu nesmí být delší než 30 znaků';

  @override
  String get darkMode => 'Tmavý režim';

  @override
  String get language => 'Jazyk';

  @override
  String get itemNameHint => 'Zadej název položky';

  @override
  String get invalidItemName => 'Název položky nesmí být delší než 20 znaků';

  @override
  String get quantityHint => 'Zadej množství';

  @override
  String get unitHint => 'Zadej jednotku';

  @override
  String get invalidQuantity => 'Množství musí být kladné číslo';

  @override
  String get invalidUnit => 'Jednotka může mít maximálně 10 znaků';
}
