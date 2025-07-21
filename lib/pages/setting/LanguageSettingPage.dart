import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../local/localeUtil.dart';
import '../../providers/LocaleStore.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageSettingPage extends ConsumerWidget {
  const LanguageSettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeStore);
    final theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(title: const Text('语言设置')),
        body: ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'language settings'.tr(),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: Text('language'.tr()),
                subtitle: Text(_getLanguageName(locale)),
              ),
              const SizedBox(height: 16),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SegmentedButton<String>(
                    segments: LocaleUtil().supportedLanguages.map((supportedLocale) {
                      return ButtonSegment<String>(
                        value: supportedLocale.languageCode,
                        label: Text(_getLanguageName(supportedLocale)),
                      );
                    }).toList(),
                    selected: {locale.languageCode},
                    onSelectionChanged: (Set<String> selected) {
                      final selectedLangCode = selected.first;
                      final selectedLocale = LocaleUtil().supportedLanguages.firstWhere(
                            (l) => l.languageCode == selectedLangCode,
                      );
                      ref.read(localeStore.notifier).setLocale(selectedLocale);
                      context.setLocale(selectedLocale);
                    },
                  )
              ),
            ]
        )
    );
  }

  String _getLanguageName(Locale locale) {
    return locale.languageCode.tr();
  }
}