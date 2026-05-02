import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:spendigo/Models/transaction_model.dart';
import 'package:intl/intl.dart';

class ReportService {
  static Future<void> generateAndPreviewReport(
    List<TransactionModel> transactions,
    String rangeTitle,
    String currency,
  ) async {
    final pdf = pw.Document();

    // Load a font that supports Unicode (like Roboto)
    final font = await PdfGoogleFonts.robotoRegular();
    final boldFont = await PdfGoogleFonts.robotoBold();

    final totalIncome = transactions
        .where((t) => t.type == "Income")
        .fold(0.0, (sum, t) => sum + t.amount);
    final totalExpense = transactions
        .where((t) => t.type == "Expense")
        .fold(0.0, (sum, t) => sum + t.amount);
    final netBalance = totalIncome - totalExpense;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        theme: pw.ThemeData.withFont(base: font, bold: boldFont),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Spendigo Financial Report',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(DateFormat('dd MMM yyyy').format(DateTime.now())),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Period: $rangeTitle',
              style: pw.TextStyle(fontSize: 16, color: PdfColors.grey700),
            ),
            pw.SizedBox(height: 30),

            // Summary Cards
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryBox(
                  'Total Income',
                  '$currency ${totalIncome.toStringAsFixed(2)}',
                  PdfColors.green,
                ),
                _buildSummaryBox(
                  'Total Expense',
                  '$currency ${totalExpense.toStringAsFixed(2)}',
                  PdfColors.red,
                ),
                _buildSummaryBox(
                  'Net Balance',
                  '$currency ${netBalance.toStringAsFixed(2)}',
                  netBalance >= 0 ? PdfColors.blue : PdfColors.orange,
                ),
              ],
            ),

            pw.SizedBox(height: 40),
            pw.Text(
              'Detailed Transactions',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),

            // Table
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              columnWidths: {
                0: const pw.FlexColumnWidth(2),
                1: const pw.FlexColumnWidth(3),
                2: const pw.FlexColumnWidth(2),
                3: const pw.FlexColumnWidth(3),
                4: const pw.FlexColumnWidth(2),
              },
              children: [
                // Table Header
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    _tableHeader('Date'),
                    _tableHeader('Category'),
                    _tableHeader('Wallet'),
                    _tableHeader('Note'),
                    _tableHeader('Amount'),
                  ],
                ),
                // Table Data
                ...transactions.map((t) {
                  return pw.TableRow(
                    children: [
                      _tableCell(DateFormat('dd/MM/yy').format(t.date)),
                      _tableCell(t.category),
                      _tableCell(t.wallet),
                      _tableCell(t.note),
                      _tableCell(
                        '$currency ${t.amount.toStringAsFixed(0)}',
                        color: t.type == "Income"
                            ? PdfColors.green
                            : PdfColors.red,
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Spendigo_Report_${rangeTitle.replaceAll(' ', '_')}.pdf',
    );
  }

  static pw.Widget _buildSummaryBox(
    String title,
    String value,
    PdfColor color,
  ) {
    return pw.Container(
      width: 150,
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: color, width: 2),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _tableHeader(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(text, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
    );
  }

  static pw.Widget _tableCell(String text, {PdfColor color = PdfColors.black}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(text, style: pw.TextStyle(color: color, fontSize: 10)),
    );
  }
}
