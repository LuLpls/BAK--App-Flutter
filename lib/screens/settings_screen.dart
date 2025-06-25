import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final currentLocale = localeProvider.locale.languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.settings)),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(localizations.darkMode),
            value: isDark,
            onChanged: themeProvider.toggleTheme,
          ),
          const Divider(),
          ListTile(
            title: Text(localizations.language),
            subtitle: Text(currentLocale == 'cs' ? 'Čeština' : 'English'),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(localizations.language),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RadioListTile<String>(
                        title: const Text('Čeština'),
                        value: 'cs',
                        groupValue: currentLocale,
                        onChanged: (value) {
                          localeProvider.setLocale(value!);
                          Navigator.pop(context);
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('English'),
                        value: 'en',
                        groupValue: currentLocale,
                        onChanged: (value) {
                          localeProvider.setLocale(value!);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
