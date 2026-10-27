import '../../game/domain/ticket.dart';

/// Text printed on the PDF, already translated.
typedef TicketLabels = ({
  String documentTitle,
  String Function(int number) ticketHeading,
  String Function(String code) gameCode,
  String Function(int first, int last) pageFooter,
});

/// Turns tickets into a printable document and hands it to the platform's
/// print or save dialog.
abstract interface class TicketPrinter {
  Future<void> printTickets({
    required List<Ticket> tickets,
    required String gameCode,
    required TicketLabels labels,
  });
}
