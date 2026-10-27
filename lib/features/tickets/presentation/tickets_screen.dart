import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n.dart';
import '../../game/domain/game.dart';
import '../../game/presentation/game_controller.dart';
import 'ticket_view.dart';

class TicketsScreen extends ConsumerWidget {
  const TicketsScreen({super.key});

  static const double maxContentWidth = 640;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final (code, count) = ref.watch(
      gameProvider.select((g) => (g.code, g.ticketCount)),
    );
    final generator = ref.watch(ticketGeneratorProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.ticketsTitle),
        actions: [
          IconButton(
            key: const Key('ticket-count'),
            tooltip: l10n.changeTicketCount,
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _changeCount(context, ref, count),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: maxContentWidth),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: count + 1,
            itemBuilder: (context, index) {
              if (index == 0) return _Summary(code: code, count: count);
              final ticket = generator.ticket(index);
              return Padding(
                key: ValueKey('ticket-$code-$index'),
                padding: const EdgeInsets.only(bottom: 8),
                child: TicketView(ticket: ticket, gameCode: code),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _changeCount(
    BuildContext context,
    WidgetRef ref,
    int current,
  ) async {
    final count = await showDialog<int>(
      context: context,
      builder: (context) => _TicketCountDialog(initial: current),
    );
    if (count != null) ref.read(gameProvider.notifier).setTicketCount(count);
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.code, required this.count});

  final String code;
  final int count;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.ticketsSummary(count, code), style: text.titleLarge),
          const SizedBox(height: 8),
          Text(l10n.ticketsExplainer, style: text.bodyMedium),
        ],
      ),
    );
  }
}

class _TicketCountDialog extends StatefulWidget {
  const _TicketCountDialog({required this.initial});

  final int initial;

  @override
  State<_TicketCountDialog> createState() => _TicketCountDialogState();
}

class _TicketCountDialogState extends State<_TicketCountDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller = TextEditingController(
    text: '${widget.initial}',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(int.parse(_controller.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.changeTicketCount),
      content: Form(
        key: _formKey,
        child: TextFormField(
          key: const Key('ticket-count-field'),
          controller: _controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(labelText: l10n.ticketCountLabel),
          validator: (value) {
            final n = int.tryParse(value ?? '');
            return n == null || n < 1 || n > Game.maxTickets
                ? l10n.ticketCountError(Game.maxTickets)
                : null;
          },
          onFieldSubmitted: (_) => _submit(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(onPressed: _submit, child: Text(l10n.save)),
      ],
    );
  }
}
