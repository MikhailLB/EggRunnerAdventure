import 'package:flutter/material.dart';

import '../app/routes.dart';
import '../app/theme.dart';
import '../data/progress_store.dart';
import '../hatchway/config/era_hatch_config.dart';
import '../l10n/app_l10n.dart';
import '../l10n/app_strings.dart';
import '../widgets/parchment_background.dart';
import '../widgets/reader_avatar.dart';
import 'web_page_screen.dart';

/// Settings hub: language switcher, reset progress, legal/support and About.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.localeController});

  final LocaleController localeController;

  static String get privacyUrl => EraHatchConfig.privacyUrl;
  static String get supportUrl => EraHatchConfig.supportUrl;

  void _openWeb(BuildContext context, String title, String url) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WebPageScreen(title: title, url: url),
      ),
    );
  }

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
              _SectionHeader(text: l10n.t('profile_title')),
              const SizedBox(height: 8),
              _Card(
                child: AnimatedBuilder(
                  animation: store,
                  builder: (context, _) {
                    final name = store.readerName;
                    final subtitle = (name != null && name.isNotEmpty)
                        ? name
                        : l10n.t('profile_name_placeholder');
                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () =>
                          Navigator.pushNamed(context, Routes.profile),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            const ReaderAvatar(size: 52),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    subtitle,
                                    style: const TextStyle(
                                      color: AppColors.ink,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    l10n.t('profile_settings_hint'),
                                    style: const TextStyle(
                                      color: AppColors.muted,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: AppColors.muted,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              _SectionHeader(text: l10n.t('settings_language')),
              const SizedBox(height: 8),
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.t('settings_language_hint'),
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 13,
                        height: 1.4,
                      ),
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
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: () => _confirmReset(context, l10n),
                      icon: const Icon(Icons.restart_alt_rounded),
                      label: Text(l10n.t('settings_reset')),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.rust,
                        side: const BorderSide(
                          color: AppColors.rust,
                          width: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _SectionHeader(text: l10n.t('settings_legal')),
              const SizedBox(height: 8),
              _Card(
                child: Column(
                  children: [
                    _LinkRow(
                      icon: Icons.privacy_tip_rounded,
                      label: l10n.t('settings_privacy'),
                      onTap: () => _openWeb(
                        context,
                        l10n.t('settings_privacy'),
                        privacyUrl,
                      ),
                    ),
                    const Divider(height: 18, color: AppColors.divider),
                    _LinkRow(
                      icon: Icons.support_agent_rounded,
                      label: l10n.t('settings_support'),
                      onTap: () => _openWeb(
                        context,
                        l10n.t('settings_support'),
                        supportUrl,
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
                      style: const TextStyle(
                        color: AppColors.ink,
                        height: 1.5,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          size: 16,
                          color: AppColors.muted,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          l10n.t('settings_version'),
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontWeight: FontWeight.w600,
                          ),
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

class _LinkRow extends StatelessWidget {
  const _LinkRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icon, size: 22, color: AppColors.rust),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
            const Icon(
              Icons.open_in_new_rounded,
              size: 18,
              color: AppColors.muted,
            ),
          ],
        ),
      ),
    );
  }
}

class _LangChip extends StatelessWidget {
  const _LangChip({
    required this.code,
    required this.selected,
    required this.onTap,
  });
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
            border: Border.all(
              color: selected ? AppColors.rust : AppColors.divider,
              width: 1.4,
            ),
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
