import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../data/progress_store.dart';
import '../data/reader_profile_service.dart';
import '../l10n/app_l10n.dart';
import '../widgets/parchment_background.dart';
import '../widgets/reader_avatar.dart';

/// Reader Profile — the sole place in the app that surfaces the camera and
/// photo-library capabilities. The user picks a source (camera / gallery),
/// the shot is copied into the documents directory via [ReaderProfileService],
/// and the resulting path is persisted through [ProgressStore] so every
/// screen that displays [ReaderAvatar] updates immediately.
class ReaderProfileScreen extends StatefulWidget {
  const ReaderProfileScreen({super.key});

  @override
  State<ReaderProfileScreen> createState() => _ReaderProfileScreenState();
}

class _ReaderProfileScreenState extends State<ReaderProfileScreen> {
  final ReaderProfileService _picker = ReaderProfileService();
  final TextEditingController _nameCtrl = TextEditingController();
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl.text = ProgressStore.instance.readerName ?? '';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _pick(AppL10n l10n, {required bool fromCamera}) async {
    if (_busy) return;
    setState(() => _busy = true);
    String? newPath;
    String? failureKey;
    try {
      newPath = fromCamera
          ? await _picker.pickFromCamera()
          : await _picker.pickFromGallery();
    } catch (_) {
      failureKey = fromCamera
          ? 'profile_camera_error'
          : 'profile_gallery_error';
    }
    if (!mounted) return;
    setState(() => _busy = false);
    if (newPath != null) {
      final store = ProgressStore.instance;
      store.setReaderAvatarPath(
        newPath,
        previousPath: store.readerAvatarPath,
      );
    } else if (failureKey != null) {
      _showSnack(l10n.t(failureKey));
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _openSourceSheet(AppL10n l10n) async {
    final choice = await showModalBottomSheet<_AvatarAction>(
      context: context,
      backgroundColor: AppColors.parchment,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final hasAvatar = ProgressStore.instance.readerAvatarPath != null;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    l10n.t('profile_change_avatar'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                _SheetRow(
                  icon: Icons.photo_camera_rounded,
                  label: l10n.t('profile_take_photo'),
                  onTap: () => Navigator.pop(ctx, _AvatarAction.camera),
                ),
                _SheetRow(
                  icon: Icons.photo_library_rounded,
                  label: l10n.t('profile_pick_gallery'),
                  onTap: () => Navigator.pop(ctx, _AvatarAction.gallery),
                ),
                if (hasAvatar)
                  _SheetRow(
                    icon: Icons.delete_outline_rounded,
                    label: l10n.t('profile_remove_avatar'),
                    destructive: true,
                    onTap: () => Navigator.pop(ctx, _AvatarAction.remove),
                  ),
                _SheetRow(
                  icon: Icons.close_rounded,
                  label: l10n.t('profile_cancel'),
                  onTap: () => Navigator.pop(ctx),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || choice == null) return;
    switch (choice) {
      case _AvatarAction.camera:
        await _pick(l10n, fromCamera: true);
      case _AvatarAction.gallery:
        await _pick(l10n, fromCamera: false);
      case _AvatarAction.remove:
        final store = ProgressStore.instance;
        store.setReaderAvatarPath(null, previousPath: store.readerAvatarPath);
    }
  }

  void _saveName() {
    ProgressStore.instance.setReaderName(_nameCtrl.text);
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppL10n.of(context).t('profile_saved'))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final store = ProgressStore.instance;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.t('profile_title'))),
      extendBodyBehindAppBar: true,
      body: ParchmentBackground(
        child: SafeArea(
          child: AnimatedBuilder(
            animation: store,
            builder: (context, _) {
              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 70, 20, 30),
                children: [
                  _AvatarHeader(
                    busy: _busy,
                    onTap: () => _openSourceSheet(l10n),
                    caption: l10n.t('profile_avatar_hint'),
                  ),
                  const SizedBox(height: 20),
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.t('profile_name_hint'),
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _nameCtrl,
                          maxLength: 24,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _saveName(),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.parchment,
                            hintText: l10n.t('profile_name_placeholder'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: AppColors.divider,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: AppColors.divider,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: AppColors.rust,
                                width: 1.6,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FilledButton.icon(
                              onPressed: _saveName,
                              icon: const Icon(Icons.check_rounded),
                              label: Text(l10n.t('profile_save')),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _Card(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          size: 18,
                          color: AppColors.muted,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.t('profile_privacy_note'),
                            style: const TextStyle(
                              color: AppColors.muted,
                              fontSize: 12.5,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

enum _AvatarAction { camera, gallery, remove }

class _AvatarHeader extends StatelessWidget {
  const _AvatarHeader({
    required this.busy,
    required this.onTap,
    required this.caption,
  });

  final bool busy;
  final VoidCallback onTap;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 148,
          child: Stack(
            alignment: Alignment.center,
            children: [
              ReaderAvatar(
                size: 132,
                showEditBadge: true,
                onTap: busy ? null : onTap,
              ),
              if (busy)
                Container(
                  width: 132,
                  height: 132,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withValues(alpha: 0.25),
                  ),
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          caption,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.muted, fontSize: 13),
        ),
      ],
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

class _SheetRow extends StatelessWidget {
  const _SheetRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final color = destructive ? AppColors.rust : AppColors.ink;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
