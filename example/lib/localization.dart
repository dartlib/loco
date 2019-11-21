import 'dart:async';

import 'package:flutter/material.dart';

class LocoExampleLocalizations {
  static LocoExampleLocalizations of(BuildContext context) {
    return Localizations.of<LocoExampleLocalizations>(
      context,
      LocoExampleLocalizations,
    );
  }

  String get appTitle => "LoCo Example";
}

class LocoExampleLocalizationsDelegate
    extends LocalizationsDelegate<LocoExampleLocalizations> {
  @override
  Future<LocoExampleLocalizations> load(Locale locale) =>
      Future(() => LocoExampleLocalizations());

  @override
  bool shouldReload(LocoExampleLocalizationsDelegate old) => false;

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode.toLowerCase().contains("en");
}
