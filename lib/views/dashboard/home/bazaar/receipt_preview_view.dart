import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moneytracker/data/receipt_service.dart';
import 'package:moneytracker/repo/bazaar_repo.dart';
import 'package:moneytracker/utilis/helpers.dart';
import '../../../../utilis/colors.dart';

/// ✅ Full ReceiptPreviewPage
/// - Keeps your UI same
/// - Works for:
///   1) Single receipt (bazaarId)
///   2) Daily Report (selectedDate)  <-- NEW
///
/// Usage:
///   ReceiptPreviewPage(bazaarId: 10)
///   ReceiptPreviewPage(reportDate: DateTime.now())
class ReceiptPreviewPage extends StatefulWidget {
  final int? bazaarId;
  final DateTime? reportDate;

  const ReceiptPreviewPage({
    super.key,
    this.bazaarId,
    this.reportDate,
  }) : assert(bazaarId != null || reportDate != null,
            "Provide bazaarId OR reportDate");

  @override
  State<ReceiptPreviewPage> createState() => _ReceiptPreviewPageState();
}

class _ReceiptPreviewPageState extends State<ReceiptPreviewPage> {
  final repo = BazaarRepository();
  final service = ReceiptService();

  final _headerCtrl = TextEditingController();
  final _subtitleCtrl = TextEditingController();

  Map<String, dynamic>? row;
  List<Map<String, dynamic>> reportRows = [];

  bool loading = true;

  bool get isDailyReport => widget.reportDate != null;

  @override
  void dispose() {
    _headerCtrl.dispose();
    _subtitleCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final header = await repo.getSetting("receipt_header") ?? "MoneyTracker";
    final subtitle = await repo.getSetting("receipt_subtitle") ?? "POS Receipt";

    if (isDailyReport) {
      final date = widget.reportDate!;
      final rows = await repo.listByDate(date);

      if (!mounted) return;
      setState(() {
        _headerCtrl.text = header;
        _subtitleCtrl.text = subtitle;
        reportRows = rows;
        loading = false;
      });
    } else {
      final r = await repo.getById(widget.bazaarId!);

      if (!mounted) return;
      setState(() {
        row = r;
        _headerCtrl.text = header;
        _subtitleCtrl.text = subtitle;
        loading = false;
      });
    }
  }

  Future<void> _saveSettings() async {
    await repo.setSetting("receipt_header", _headerCtrl.text.trim());
    await repo.setSetting("receipt_subtitle", _subtitleCtrl.text.trim());
  }

  Future<void> _downloadAndOpen() async {
    await _saveSettings();

    final header = _headerCtrl.text.trim().isEmpty ? "MoneyTracker" : _headerCtrl.text.trim();
    final subtitle = _subtitleCtrl.text.trim().isEmpty ? "POS Receipt" : _subtitleCtrl.text.trim();

    if (isDailyReport) {
      final date = widget.reportDate!;
      final file = await service.createDailyReportPdf(
        header: header,
        subtitle: subtitle,
        date: date,
        rows: reportRows,
      );
      await service.openFile(file);
      return;
    }

    if (row == null) return;

    final file = await service.createBazaarReceiptPdf(
      header: header,
      subtitle: subtitle,
      row: row!,
    );
    await service.openFile(file);
  }

  Future<void> _share() async {
    await _saveSettings();

    final header = _headerCtrl.text.trim().isEmpty ? "MoneyTracker" : _headerCtrl.text.trim();
    final subtitle = _subtitleCtrl.text.trim().isEmpty ? "POS Receipt" : _subtitleCtrl.text.trim();

    if (isDailyReport) {
      final date = widget.reportDate!;
      final file = await service.createDailyReportPdf(
        header: header,
        subtitle: subtitle,
        date: date,
        rows: reportRows,
      );
      await service.shareFile(file);
      return;
    }

    if (row == null) return;

    final file = await service.createBazaarReceiptPdf(
      header: header,
      subtitle: subtitle,
      row: row!,
    );
    await service.shareFile(file);
  }

  double _reportTotal() {
    double total = 0;
    for (final r in reportRows) {
      total += ((r["amount"] as num?)?.toDouble() ?? 0.0);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectColor.whiteColor,
      appBar: AppBar(
        backgroundColor: ProjectColor.whiteColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios, color: ProjectColor.blackColor),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: ProjectColor.blackColor),
        title: Text(
          isDailyReport ? "Daily Report" : "Receipt",
          style: const TextStyle(
            color: ProjectColor.blackColor,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          IconButton(
            tooltip: "Share",
            onPressed: _share,
            icon: const Icon(Icons.share),
            color: ProjectColor.blackColor,
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SafeArea(
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : _content(),
      ),
    );
  }

  Widget _content() {
    if (isDailyReport) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _receiptHeaderSettings(),
          const SizedBox(height: 12),
          _dailyReportCard(),
          const SizedBox(height: 12),
          _button("Download / Open Report", _downloadAndOpen),
        ],
      );
    }

    if (row == null) {
      return const Center(child: Text("Receipt not found"));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _receiptHeaderSettings(),
        const SizedBox(height: 12),
        _receiptCard(),
        const SizedBox(height: 12),
        _button("Download / Open Receipt", _downloadAndOpen),
      ],
    );
  }

  Widget _receiptHeaderSettings() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ProjectColor.lavenderPurple.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ProjectColor.lavenderPurple.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Receipt Settings", style: TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          _field(_headerCtrl, "Header (Shop name)"),
          const SizedBox(height: 10),
          _field(_subtitleCtrl, "Subtitle (Phone / Address)"),
        ],
      ),
    );
  }

  /// -------- SINGLE RECEIPT CARD (same UI) --------
  Widget _receiptCard() {
    final amount = ((row!["amount"] as num?)?.toDouble() ?? 0.0).toStringAsFixed(2);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        children: [
          Text(
            _headerCtrl.text.trim().isEmpty ? "MoneyTracker" : _headerCtrl.text.trim(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          Text(
            _subtitleCtrl.text.trim().isEmpty ? "POS Receipt" : _subtitleCtrl.text.trim(),
            style: TextStyle(color: ProjectColor.grey, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Divider(),

          _kv("Receipt", "${row!["receipt_no"]}"),
          _kv("Date", Helpers.fmtIso(row!["created_at"] as String)),
          const Divider(),

          _kv("Bazaar", "${row!["bazaar_name"]}"),
          _kv("Note", "${row!["note"] ?? ""}"),
          const Divider(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("TOTAL", style: TextStyle(fontWeight: FontWeight.w900)),
              Text("\$$amount", style: const TextStyle(fontWeight: FontWeight.w900)),
            ],
          ),

          const SizedBox(height: 10),
          Text("Thank you!", style: TextStyle(color: ProjectColor.grey)),
        ],
      ),
    );
  }

  /// -------- DAILY REPORT CARD (same style, shows all items) --------
  Widget _dailyReportCard() {
    final total = _reportTotal().toStringAsFixed(2);
    final date = widget.reportDate!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        children: [
          Text(
            _headerCtrl.text.trim().isEmpty ? "MoneyTracker" : _headerCtrl.text.trim(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          Text(
            _subtitleCtrl.text.trim().isEmpty ? "POS Receipt" : _subtitleCtrl.text.trim(),
            style: TextStyle(color: ProjectColor.grey, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Divider(),

          _kv("Type", "Daily Report"),
          _kv("Date", Helpers.fmtDate(date)),
          const Divider(),

          if (reportRows.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text("No bazaar items found for this date.",
                  style: TextStyle(color: ProjectColor.grey)),
            )
          else
            ...reportRows.map((r) {
              final name = "${r["bazaar_name"]}";
              final note = "${r["note"] ?? ""}";
              final amount = ((r["amount"] as num?)?.toDouble() ?? 0.0).toStringAsFixed(2);

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w900)),
                        ),
                        Text("\$$amount", style: const TextStyle(fontWeight: FontWeight.w900)),
                      ],
                    ),
                    if (note.trim().isNotEmpty)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          note,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: ProjectColor.grey, fontSize: 12),
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),

          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("TOTAL", style: TextStyle(fontWeight: FontWeight.w900)),
              Text("\$$total", style: const TextStyle(fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 10),
          Text("Thank you!", style: TextStyle(color: ProjectColor.grey)),
        ],
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(k, style: TextStyle(color: ProjectColor.grey))),
          Expanded(
            child: Text(
              v,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w800),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _button(String text, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: ProjectColor.lavenderPurple.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ProjectColor.lavenderPurple.withOpacity(0.28)),
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: ProjectColor.blackColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String hint) {
    return TextField(
      controller: c,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
      ),
    );
  }
}
