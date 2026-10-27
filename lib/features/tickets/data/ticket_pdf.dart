import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../game/domain/ticket.dart';
import '../../game/domain/ticket_generator.dart';
import '../domain/ticket_printer.dart';

/// Builds an A4 PDF with one strip of six tickets per page, so every page
/// holds each number from 1 to 90 exactly once.
Future<Uint8List> buildTicketsPdf({
  required List<Ticket> tickets,
  required String gameCode,
  required TicketLabels labels,
  PdfPageFormat format = PdfPageFormat.a4,
  bool compress = true,
}) {
  final doc = pw.Document(
    title: labels.documentTitle,
    creator: 'Tambola Host',
    compress: compress,
  );
  const perPage = TicketGenerator.ticketsPerStrip;
  for (var start = 0; start < tickets.length; start += perPage) {
    final page = tickets.sublist(
      start,
      start + perPage > tickets.length ? tickets.length : start + perPage,
    );
    doc.addPage(
      pw.Page(
        pageFormat: format,
        margin: const pw.EdgeInsets.symmetric(horizontal: 32, vertical: 28),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            for (final ticket in page)
              _PdfTicket(ticket: ticket, gameCode: gameCode, labels: labels),
            pw.Spacer(),
            pw.Text(
              labels.pageFooter(page.first.number, page.last.number),
              textAlign: pw.TextAlign.center,
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
            ),
          ],
        ),
      ),
    );
  }
  return doc.save();
}

class _PdfTicket extends pw.StatelessWidget {
  _PdfTicket({
    required this.ticket,
    required this.gameCode,
    required this.labels,
  });

  final Ticket ticket;
  final String gameCode;
  final TicketLabels labels;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 10),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: PdfColors.grey500,
            style: pw.BorderStyle.dashed,
          ),
        ),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                labels.ticketHeading(ticket.number),
                style: const pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                labels.gameCode(gameCode),
                style: const pw.TextStyle(fontSize: 10),
              ),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Table(
            border: pw.TableBorder.all(width: 0.8),
            children: [
              for (var r = 0; r < Ticket.rows; r++)
                pw.TableRow(
                  children: [
                    for (var c = 0; c < Ticket.columns; c++)
                      _cell(ticket.cell(r, c)),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _cell(int number) => pw.Container(
    height: 28,
    alignment: pw.Alignment.center,
    color: number == 0 ? PdfColors.grey200 : null,
    child: number == 0
        ? null
        : pw.Text(
            '$number',
            style: const pw.TextStyle(
              fontSize: 15,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
  );
}

/// Opens the browser's (or phone's) print dialog, where the host can print
/// or save the tickets as a PDF.
class PdfTicketPrinter implements TicketPrinter {
  const PdfTicketPrinter();

  @override
  Future<void> printTickets({
    required List<Ticket> tickets,
    required String gameCode,
    required TicketLabels labels,
  }) async {
    await Printing.layoutPdf(
      name: 'tambola-tickets-$gameCode.pdf',
      format: PdfPageFormat.a4,
      onLayout: (format) => buildTicketsPdf(
        tickets: tickets,
        gameCode: gameCode,
        labels: labels,
        format: format,
      ),
    );
  }
}
