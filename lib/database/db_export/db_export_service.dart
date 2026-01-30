import 'dart:io';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';

class DbExportService {
  Future<void> shareDatabaseFile() async {
    // ✅ close DB before copy (important)
    final dbPath = join(await getDatabasesPath(), 'wallet.db');

    final file = File(dbPath);
    if (!await file.exists()) {
      throw Exception("DB file not found: $dbPath");
    }

    await Share.shareXFiles([XFile(file.path)], text: "My MoneyTracker Database");
  }

  Future<String> exportToDownloadsAndroid() async {
    final dbPath = join(await getDatabasesPath(), 'wallet.db');
    final dbFile = File(dbPath);

    if (!await dbFile.exists()) throw Exception("DB not found");

    // ✅ request storage permission (older android)
    await Permission.storage.request();

    // ✅ Download folder path (works for many devices)
    final downloadsDir = Directory('/storage/emulated/0/Download');
    if (!await downloadsDir.exists()) {
      throw Exception("Downloads folder not found");
    }

    final outPath = join(
      downloadsDir.path,
      'moneytracker_wallet_${DateTime.now().millisecondsSinceEpoch}.db',
    );

    await dbFile.copy(outPath);
    return outPath;
  }

  /*
  
  final path = await DbExportService().exportToDownloadsAndroid();
  print("Exported to: $path");
  
   */
}
