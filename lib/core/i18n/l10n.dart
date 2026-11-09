import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';

export '../../l10n/app_localizations.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Shipped locales. English is the source; Spanish is the first translation.
const shippedLocales = <Locale>[Locale('en'), Locale('es')];

/// A saved locale code, or null to follow the system.
Locale? localeForCode(String? code) {
  if (code == null || code.isEmpty || code == 'system') return null;
  return Locale(code);
}

String localeCode(Locale? locale) => locale?.languageCode ?? '';
