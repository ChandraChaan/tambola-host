import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n.dart';
import '../../game/domain/game.dart';
import '../../game/domain/game_code.dart';
import '../../game/presentation/game_controller.dart';

typedef NewGameRequest = ({int ticketCount, String? code});

Future<void> showNewGameDialog(BuildContext context, WidgetRef ref) async {
  final game = ref.read(gameProvider);
  final request = await showDialog<NewGameRequest>(
    context: context,
    builder: (context) =>
        NewGameDialog(currentCode: game.code, ticketCount: game.ticketCount),
  );
  if (request == null) return;
  ref
      .read(gameProvider.notifier)
      .newGame(ticketCount: request.ticketCount, code: request.code);
}

class NewGameDialog extends StatefulWidget {
  const NewGameDialog({
    required this.currentCode,
    required this.ticketCount,
    super.key,
  });

  final String currentCode;
  final int ticketCount;

  @override
  State<NewGameDialog> createState() => _NewGameDialogState();
}

class _NewGameDialogState extends State<NewGameDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _count = TextEditingController(
    text: '${widget.ticketCount}',
  );
  final TextEditingController _code = TextEditingController();

  @override
  void dispose() {
    _count.dispose();
    _code.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final code = GameCode.normalize(_code.text);
    Navigator.of(context).pop<NewGameRequest>((
      ticketCount: int.parse(_count.text),
      code: code.isEmpty ? null : code,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.newGameTitle),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.newGameBody(widget.currentCode)),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('new-game-count'),
                controller: _count,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(labelText: l10n.ticketCountLabel),
                validator: (value) {
                  final n = int.tryParse(value ?? '');
                  return n == null || n < 1 || n > Game.maxTickets
                      ? l10n.ticketCountError(Game.maxTickets)
                      : null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const Key('new-game-code'),
                controller: _code,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  labelText: l10n.gameCodeFieldLabel,
                  hintText: l10n.gameCodeFieldHint,
                ),
                validator: (value) {
                  final code = GameCode.normalize(value ?? '');
                  return code.isEmpty || GameCode.isValid(code)
                      ? null
                      : l10n.gameCodeError;
                },
                onFieldSubmitted: (_) => _submit(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          key: const Key('new-game-start'),
          onPressed: _submit,
          child: Text(l10n.start),
        ),
      ],
    );
  }
}
