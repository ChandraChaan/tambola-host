import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n.dart';
import '../../game/domain/settings.dart';
import '../../game/presentation/settings_controller.dart';

Future<void> showSettingsSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => const SettingsSheet(),
    );

class SettingsSheet extends ConsumerWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final settings = ref.watch(settingsProvider);
    final controller = ref.read(settingsProvider.notifier);
    final text = Theme.of(context).textTheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.settings, style: text.titleLarge),
            const SizedBox(height: 16),
            Text(l10n.settingsVoice, style: text.titleSmall),
            const SizedBox(height: 8),
            SegmentedButton<VoiceLanguage>(
              key: const Key('voice'),
              segments: [
                ButtonSegment(
                  value: VoiceLanguage.off,
                  icon: const Icon(Icons.volume_off_outlined),
                  label: Text(l10n.voiceOff),
                ),
                ButtonSegment(
                  value: VoiceLanguage.english,
                  label: Text(l10n.voiceEnglish),
                ),
                ButtonSegment(
                  value: VoiceLanguage.hindi,
                  label: Text(l10n.voiceHindi),
                ),
              ],
              selected: {settings.voice},
              onSelectionChanged: (s) => controller.setVoice(s.first),
            ),
            const SizedBox(height: 8),
            Text(l10n.voiceNote, style: text.bodySmall),
            const SizedBox(height: 8),
            SwitchListTile(
              key: const Key('rhymes'),
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.settingsRhymes),
              subtitle: Text(l10n.settingsRhymesHint),
              value: settings.rhymes,
              onChanged: controller.setRhymes,
            ),
            const SizedBox(height: 8),
            Text(l10n.settingsTheme, style: text.titleSmall),
            const SizedBox(height: 8),
            SegmentedButton<ThemeChoice>(
              key: const Key('theme'),
              segments: [
                ButtonSegment(
                  value: ThemeChoice.system,
                  icon: const Icon(Icons.brightness_auto_outlined),
                  label: Text(l10n.themeSystem),
                ),
                ButtonSegment(
                  value: ThemeChoice.light,
                  icon: const Icon(Icons.light_mode_outlined),
                  label: Text(l10n.themeLight),
                ),
                ButtonSegment(
                  value: ThemeChoice.dark,
                  icon: const Icon(Icons.dark_mode_outlined),
                  label: Text(l10n.themeDark),
                ),
              ],
              selected: {settings.theme},
              onSelectionChanged: (s) => controller.setTheme(s.first),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.close),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
