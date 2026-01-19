// import 'package:flutter/material.dart';

// class SettingView extends StatelessWidget {
//   const SettingView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(child: Text("Setting view"));
//   }
// }


import 'package:flutter/material.dart';
import 'package:moneytracker/utilis/colors.dart';
import 'package:moneytracker/widget/custom_appber.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectColor.whiteColor,
      appBar: AppBar(
        backgroundColor: ProjectColor.whiteColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _profileCard(),
            const SizedBox(height: 14),

            _sectionTitle("Wallet"),
            _tile(
              context,
              icon: Icons.file_upload_outlined,
              title: "Export Database",
              subtitle: "Backup your SQLite file",
              onTap: () async {
                // TODO: call your exporter
                // await DBExporter.shareDatabase("moneytracker.db");
              },
            ),
            _tile(
              context,
              icon: Icons.history,
              title: "Transactions",
              subtitle: "See all transactions",
              onTap: () {
                // TODO: Navigator.push to TransactionsPage
              },
            ),

            const SizedBox(height: 14),
            _sectionTitle("App"),
            _tile(
              context,
              icon: Icons.palette_outlined,
              title: "Theme",
              subtitle: "Light / Dark (optional)",
              onTap: () {},
            ),
            _tile(
              context,
              icon: Icons.language_outlined,
              title: "Language",
              subtitle: "English / বাংলা (optional)",
              onTap: () {},
            ),

            const SizedBox(height: 14),
            _sectionTitle("Support"),
            _tile(
              context,
              icon: Icons.help_outline,
              title: "Help Center",
              subtitle: "How to use the app",
              onTap: () {},
            ),
            _tile(
              context,
              icon: Icons.privacy_tip_outlined,
              title: "Privacy Policy",
              subtitle: "Read privacy details",
              onTap: () {},
            ),

            const SizedBox(height: 18),
            _dangerTile(
              context,
              icon: Icons.delete_outline,
              title: "Clear All Data",
              subtitle: "Delete wallet + transactions",
              onTap: () {
                _showConfirmClearDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ProjectColor.lavenderPurple.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ProjectColor.lavenderPurple.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black12),
            ),
            child: const Icon(Icons.person_outline, size: 26),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Money Tracker",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 4),
                Text(
                  "Manage your income and expenses",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          color: ProjectColor.blackColor,
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _tile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: ProjectColor.lavenderPurple.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: ProjectColor.electricPurple),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  Widget _dangerTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: Colors.red),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  void _showConfirmClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Clear all data?"),
        content: const Text("This will delete wallet balance and all transactions."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: call clear database method
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
