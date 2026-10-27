import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n.dart';
import '../../game/presentation/game_controller.dart';
import 'caller_controls.dart';
import 'current_number_card.dart';
import 'new_game_dialog.dart';
import 'number_board.dart';
import 'previous_calls.dart';
import 'settings_sheet.dart';

class CallerScreen extends ConsumerWidget {
  const CallerScreen({super.key});

  /// From this width the board sits beside the controls, sized for a TV.
  static const double wideBreakpoint = 900;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final code = ref.watch(gameProvider.select((g) => g.code));
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.callerTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: Text(
                l10n.gameCodeLabel(code),
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
          IconButton(
            key: const Key('new-game'),
            tooltip: l10n.newGame,
            icon: const Icon(Icons.restart_alt),
            onPressed: () => showNewGameDialog(context, ref),
          ),
          IconButton(
            key: const Key('settings'),
            tooltip: l10n.settings,
            icon: const Icon(Icons.tune),
            onPressed: () => showSettingsSheet(context),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= wideBreakpoint) {
              return const _WideLayout();
            }
            return const _NarrowLayout();
          },
        ),
      ),
    );
  }
}

class _NarrowLayout extends StatelessWidget {
  const _NarrowLayout();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        CurrentNumberCard(),
        SizedBox(height: 16),
        CallerControls(),
        SizedBox(height: 16),
        PreviousCalls(),
        SizedBox(height: 16),
        AspectRatio(aspectRatio: 10 / 9, child: NumberBoard()),
      ],
    );
  }
}

class _WideLayout extends StatelessWidget {
  const _WideLayout();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 380,
            child: ListView(
              children: const [
                CurrentNumberCard(),
                SizedBox(height: 16),
                CallerControls(),
                SizedBox(height: 16),
                PreviousCalls(),
              ],
            ),
          ),
          const SizedBox(width: 24),
          const Expanded(child: NumberBoard()),
        ],
      ),
    );
  }
}
