// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:moneytracker/utilis/colors.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class QrItem {
  final int id;
  final String title;
  final String data;
  final DateTime createdAt;

  const QrItem({
    required this.id,
    required this.title,
    required this.data,
    required this.createdAt,
  });
}

class QrCodeView extends StatefulWidget {
  const QrCodeView({super.key});

  @override
  State<QrCodeView> createState() => _QrCodeViewState();
}

class _QrCodeViewState extends State<QrCodeView> {
  final _titleCtrl = TextEditingController();
  final _dataCtrl = TextEditingController();

  String _currentData = "";

  // ✅ Scanner state
  bool _isScanning = false;
  bool _scanHandled = false;

  List<QrItem> _history = [
    QrItem(
      id: 1,
      title: "My Wallet",
      data: "moneytracker://wallet?id=1",
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    QrItem(
      id: 2,
      title: "Pay: Dinner",
      data: "PAY|amount=250|note=Dinner",
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
  ];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _dataCtrl.dispose();
    super.dispose();
  }

  // ✅ Check URL
  bool _isUrl(String text) {
    final uri = Uri.tryParse(text.trim());
    return uri != null && (uri.scheme == "http" || uri.scheme == "https");
  }

  void _generate() {
    FocusManager.instance.primaryFocus?.unfocus();
    final data = _dataCtrl.text.trim();
    final title = _titleCtrl.text.trim();

    if (data.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter QR data first")),
      );
      return;
    }

    setState(() {
      _currentData = data;
      _history.insert(
        0,
        QrItem(
          id: DateTime.now().millisecondsSinceEpoch,
          title: title.isEmpty ? "QR Code" : title,
          data: data,
          createdAt: DateTime.now(),
        ),
      );
    });
  }

  // ✅ Handle scanned text
  Future<void> _handleScanned(String data) async {
    setState(() {
      _isScanning = false;
      _scanHandled = false;
    });

    final isUrl = _isUrl(data);

    // Store in history (always)
    setState(() {
      _currentData = data;
      _history.insert(
        0,
        QrItem(
          id: DateTime.now().millisecondsSinceEpoch,
          title: isUrl ? "Scanned Link" : "Scanned QR",
          data: data,
          createdAt: DateTime.now(),
        ),
      );
    });

    // If not URL => view only
    if (!isUrl) {
      _openPreviewBottomSheet(data);
      return;
    }

    // If URL => choose action
    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _QrScanActionSheet(data: data),
    );

    if (action == null) return;

    if (action == "VIEW") {
      _openPreviewBottomSheet(data);
    } else if (action == "BROWSER") {
      final uri = Uri.parse(data);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _toggleScanner() {
    setState(() {
      _isScanning = !_isScanning;
      _scanHandled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectColor.whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ProjectColor.whiteColor,
        elevation: 0,
        title: const Text(
          "QR Code",
          style: TextStyle(
            color: ProjectColor.blackColor,
            fontWeight: FontWeight.w900,
          ),
        ),

        // ✅ Added scan button (UI style kept simple)
        actions: [
          IconButton(
            onPressed: _toggleScanner,
            icon: Icon(
              _isScanning ? Icons.close : Icons.qr_code_scanner,
              color: ProjectColor.blackColor,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Your existing UI (unchanged)
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _headerCard(),
                const SizedBox(height: 12),
                _generatorCard(),
                const SizedBox(height: 12),
                if (_currentData.isNotEmpty) _previewCard(_currentData),
                if (_currentData.isNotEmpty) const SizedBox(height: 12),
                _historyHeader(),
                const SizedBox(height: 8),
                if (_history.isEmpty) _emptyState() else ..._history.map((e) => _historyTile(e)),
                const SizedBox(height: 80),
              ],
            ),

            // ✅ Scanner overlay
            if (_isScanning)
              Positioned.fill(
                child: Container(
                  color: Colors.black,
                  child: Stack(
                    children: [
                      MobileScanner(
                        onDetect: (capture) {
                          if (_scanHandled) return;

                          final barcode = capture.barcodes.isNotEmpty
                              ? capture.barcodes.first
                              : null;
                          final raw = barcode?.rawValue?.trim();

                          if (raw == null || raw.isEmpty) return;

                          _scanHandled = true;
                          _handleScanned(raw);
                        },
                      ),

                      // Simple scan box overlay
                      Center(
                        child: Container(
                          width: 240,
                          height: 240,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),

                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 20,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: const Text(
                            "Align the QR code inside the box",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ------------------------------
  // Your existing widgets (UNCHANGED)
  // ------------------------------

  Widget _headerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ProjectColor.lavenderPurple.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ProjectColor.lavenderPurple.withOpacity(0.25)),
        boxShadow: const [
          BoxShadow(
            blurRadius: 12,
            offset: Offset(0, 10),
            color: Color(0x10000000),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black12),
            ),
            child: const Icon(
              Icons.qr_code_2,
              color: ProjectColor.electricPurple,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Generate & Save QR",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 4),
                Text(
                  "Create new QR codes and keep history for quick access.",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _generatorCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Create QR",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: ProjectColor.blackColor,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _titleCtrl,
            decoration: InputDecoration(
              hintText: "Title (optional) e.g. Pay rent",
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _dataCtrl,
            minLines: 2,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: "QR data (text / link / JSON)\nExample: PAY|amount=200|note=Food",
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: InkWell(
              onTap: _generate,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  color: ProjectColor.lavenderPurple.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: ProjectColor.lavenderPurple.withOpacity(0.28),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 12,
                      offset: Offset(0, 8),
                      color: Color(0x10000000),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    "Generate QR",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: ProjectColor.blackColor,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _previewCard(String data) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ProjectColor.lavenderPurple.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ProjectColor.lavenderPurple.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black12),
            ),
            child: QrImageView(data: data, size: 88),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Current QR", style: TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text(
                  data,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: ProjectColor.grey, fontSize: 12),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _chipButton(
                      label: "Preview",
                      icon: Icons.visibility_outlined,
                      onTap: () => _openPreviewBottomSheet(data),
                    ),
                    const SizedBox(width: 8),
                    _chipButton(
                      label: "Full Screen",
                      icon: Icons.open_in_full,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => FullScreenQrView(data: data)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _historyHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "History",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: ProjectColor.blackColor),
        ),
        Text("${_history.length}",
            style: TextStyle(color: ProjectColor.grey, fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _historyTile(QrItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
        boxShadow: const [
          BoxShadow(blurRadius: 10, offset: Offset(0, 8), color: Color(0x0F000000)),
        ],
      ),
      child: ListTile(
        onTap: () {
          setState(() => _currentData = item.data);
          _openPreviewBottomSheet(item.data);
        },
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: ProjectColor.lavenderPurple.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: ProjectColor.lavenderPurple.withOpacity(0.25)),
          ),
          child: const Icon(Icons.qr_code, color: ProjectColor.electricPurple),
        ),
        title: Text(item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w900)),
        subtitle: Text(_fmt(item.createdAt), style: TextStyle(color: ProjectColor.grey, fontSize: 12)),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  Widget _chipButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: ProjectColor.electricPurple.withOpacity(0.08),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: ProjectColor.electricPurple.withOpacity(0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: ProjectColor.electricPurple),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: ProjectColor.electricPurple,
                )),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ProjectColor.lavenderPurple.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ProjectColor.lavenderPurple.withOpacity(0.20)),
      ),
      child: const Row(
        children: [
          Icon(Icons.inbox_outlined, color: ProjectColor.grey),
          SizedBox(width: 10),
          Expanded(
            child: Text("No QR history yet. Create your first QR above.",
                style: TextStyle(color: ProjectColor.grey)),
          ),
        ],
      ),
    );
  }

  void _openPreviewBottomSheet(String data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Material(
            borderRadius: BorderRadius.circular(18),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text("QR Preview",
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: ProjectColor.lavenderPurple.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: ProjectColor.lavenderPurple.withOpacity(0.25)),
                    ),
                    child: QrImageView(data: data, size: 220),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    data,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: ProjectColor.grey, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _fmt(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final y = dt.year.toString();
    return "$d/$m/$y";
  }
}

/// ✅ Action sheet ONLY for URL scans
class _QrScanActionSheet extends StatelessWidget {
  final String data;
  const _QrScanActionSheet({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Material(
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text("Scanned Link",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            const SizedBox(height: 10),
            Text(
              data,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(color: ProjectColor.grey, fontSize: 12),
            ),
            const SizedBox(height: 14),
            ListTile(
              onTap: () => Navigator.pop(context, "VIEW"),
              leading: const Icon(Icons.visibility_outlined),
              title: const Text("View"),
              trailing: const Icon(Icons.chevron_right),
            ),
            ListTile(
              onTap: () => Navigator.pop(context, "BROWSER"),
              leading: const Icon(Icons.open_in_browser),
              title: const Text("Open in Browser"),
              trailing: const Icon(Icons.chevron_right),
            ),
          ]),
        ),
      ),
    );
  }
}

class FullScreenQrView extends StatelessWidget {
  final String data;
  const FullScreenQrView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectColor.whiteColor,
      appBar: AppBar(
        backgroundColor: ProjectColor.whiteColor,
        elevation: 0,
        title: const Text(
          "QR Code",
          style: TextStyle(color: ProjectColor.blackColor, fontWeight: FontWeight.w900),
        ),
        iconTheme: const IconThemeData(color: ProjectColor.blackColor),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ProjectColor.lavenderPurple.withOpacity(0.06),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: ProjectColor.lavenderPurple.withOpacity(0.25)),
            ),
            child: QrImageView(data: data, size: 300),
          ),
        ),
      ),
    );
  }
}
