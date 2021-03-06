import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nedaa/constants/calculation_methods.dart';
import 'package:nedaa/modules/settings/models/calculation_method.dart';

class CalculationMethodsDialog extends StatelessWidget {
  const CalculationMethodsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    var locale = Localizations.localeOf(context);
    var methods =
        calculationMethods[locale.languageCode] ?? calculationMethods['en']!;

    return SimpleDialog(
      title: Text(t!.calculationMethods),
      children: methods.entries.map((entry) {
        return SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, CalculationMethod(entry.key));
          },
          child: Text(entry.value),
        );
      }).toList(),
    );
  }
}
