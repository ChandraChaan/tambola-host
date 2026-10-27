import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/ticket_pdf.dart';
import '../domain/ticket_printer.dart';

final ticketPrinterProvider = Provider<TicketPrinter>(
  (ref) => const PdfTicketPrinter(),
);
