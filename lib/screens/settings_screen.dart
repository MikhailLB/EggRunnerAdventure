import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../data/progress_store.dart';
import '../l10n/app_l10n.dart';
import '../l10n/app_strings.dart';
import '../widgets/parchment_background.dart';

/// Settings hub: language switcher, reset progress, and About section.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.localeController});

  final LocaleController localeController;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final store = ProgressStore.instance;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.t('settings_title'))),
      extendBodyBehindAppBar: true,
      body: ParchmentBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 70, 20, 30),
            children: [
              _SectionHeader(text: l10n.t('settings_language')),
              const SizedBox(height: 8),
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.t('settings_language_hint'),
                      style: const TextStyle(color: AppColors.muted, fontSize: 13, height: 1.4),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: AppStrings.supportedLocales.map((code) {
                        final selected = store.languageCode == code;
                        return _LangChip(
                          code: code,
                          selected: selected,
                          onTap: () => localeController.set(code),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _SectionHeader(text: l10n.t('settings_reset')),
              const SizedBox(height: 8),
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.t('settings_reset_hint'),
                      style: const TextStyle(color: AppColors.muted, fontSize: 13, height: 1.4),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: () => _confirmReset(context, l10n),
                      icon: const Icon(Icons.restart_alt_rounded),
                      label: Text(l10n.t('settings_reset')),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.rust,
                        side: const BorderSide(color: AppColors.rust, width: 1.6),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _SectionHeader(text: l10n.t('settings_about')),
              const SizedBox(height: 8),
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.t('settings_about_body'),
                      style: const TextStyle(color: AppColors.ink, height: 1.5, fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.muted),
                        const SizedBox(width: 6),
                        Text(
                          l10n.t('settings_version'),
                          style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context, AppL10n l10n) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.parchment,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.t('settings_reset_confirm')),
        content: Text(l10n.t('settings_reset_confirm_body')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.t('settings_reset_confirm_no')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.t('settings_reset_confirm_yes')),
          ),
        ],
      ),
    );
    if (ok == true) {
      ProgressStore.instance.resetProgress();
    }
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.muted,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: child,
    );
  }
}

class _LangChip extends StatelessWidget {
  const _LangChip({required this.code, required this.selected, required this.onTap});
  final String code;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.rust : AppColors.parchment,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: selected ? AppColors.rust : AppColors.divider, width: 1.4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppStrings.flag(code), style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(
                AppStrings.label(code),
                style: TextStyle(
                  color: selected ? Colors.white : AppColors.ink,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
