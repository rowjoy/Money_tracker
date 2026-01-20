import 'dart:io';

import 'package:open_filex/open_filex.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ReceiptService {
  /// ✅ Single bazaar receipt PDF (one item)
  Future<File> createBazaarReceiptPdf({
    required String header,
    required String subtitle,
    required Map<String, dynamic> row,
  }) async {
    final doc = pw.Document();

    final receiptNo = "${row["receipt_no"] ?? ""}";
    final createdAt = "${row["created_at"] ?? ""}";
    final name = "${row["bazaar_name"] ?? ""}";
    final note = "${row["note"] ?? ""}";
    final amount = ((row["amount"] as num?)?.toDouble() ?? 0.0).toStringAsFixed(2);

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a6,
        margin: const pw.EdgeInsets.all(12),
        build: (_) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  header,
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Center(
                child: pw.Text(
                  subtitle,
                  style: const pw.TextStyle(fontSize: 9),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Divider(),

              _kv("Receipt", receiptNo),
              _kv("Date", createdAt),
              pw.Divider(),

              _kv("Bazaar", name),
              if (note.trim().isNotEmpty) _kv("Note", note),
              pw.Divider(),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("TOTAL", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(amount, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),

              pw.SizedBox(height: 10),
              pw.Center(child: pw.Text("Thank you!", style: const pw.TextStyle(fontSize: 10))),
            ],
          );
        },
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/${receiptNo.isEmpty ? "bazaar_receipt" : receiptNo}.pdf");
    await file.writeAsBytes(await doc.save());
    return file;
  }

  /// ✅ Daily Report PDF (many items in one day)
  Future<File> createDailyReportPdf({
    required String header,
    required String subtitle,
    required DateTime date,
    required List<Map<String, dynamic>> rows,
  }) async {
    final doc = pw.Document();

    double total = 0;
    for (final r in rows) {
      total += ((r["amount"] as num?)?.toDouble() ?? 0.0);
    }

    final dateText =
        "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a6,
        margin: const pw.EdgeInsets.all(12),
        build: (_) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  header,
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Center(
                child: pw.Text(
                  subtitle,
                  style: const pw.TextStyle(fontSize: 9),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Divider(),

              _kv("Type", "Daily Report"),
              _kv("Date", dateText),
              pw.Divider(),

              if (rows.isEmpty)
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 10),
                  child: pw.Text("No bazaar items found for this date."),
                )
              else
                ...rows.map((r) {
                  final name = "${r["bazaar_name"] ?? ""}";
                  final note = "${r["note"] ?? ""}";
                  final amount = ((r["amount"] as num?)?.toDouble() ?? 0.0).toStringAsFixed(2);

                  return pw.Container(
                    margin: const pw.EdgeInsets.only(bottom: 6),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Expanded(
                              child: pw.Text(
                                name,
                                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                                maxLines: 1,
                              ),
                            ),
                            pw.Text(amount),
                          ],
                        ),
                        if (note.trim().isNotEmpty)
                          pw.Text(
                            note,
                            style: const pw.TextStyle(fontSize: 9),
                            maxLines: 1,
                          ),
                      ],
                    ),
                  );
                }).toList(),

              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("TOTAL", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(total.toStringAsFixed(2),
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),

              pw.SizedBox(height: 10),
              pw.Center(child: pw.Text("Thank you!", style: const pw.TextStyle(fontSize: 10))),
            ],
          );
        },
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final fileName =
        "daily_report_${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}.pdf";
    final file = File("${dir.path}/$fileName");
    await file.writeAsBytes(await doc.save());
    return file;
  }

  /// Open generated file
  Future<void> openFile(File file) async {
    await OpenFilex.open(file.path);
  }

  /// Share generated file
  Future<void> shareFile(File file) async {
    await Share.shareXFiles([XFile(file.path)]);
  }

  // ------------------------------
  // PDF helper key-value row
  // ------------------------------
  static pw.Widget _kv(String k, String v) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        children: [
          pw.Expanded(child: pw.Text(k)),
          pw.Expanded(
            child: pw.Text(
              v,
              textAlign: pw.TextAlign.right,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
