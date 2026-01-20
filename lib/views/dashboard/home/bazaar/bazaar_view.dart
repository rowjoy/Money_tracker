


// =====================================================
// 5) PAGE 1: DAILY BAZAAR LIST (Premium UI)
// =====================================================
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moneytracker/bloc/bazaar/bazaar_bloc.dart';
import 'package:moneytracker/bloc/bazaar/bazaar_event.dart';
import 'package:moneytracker/bloc/bazaar/bazaar_states.dart';
import 'package:moneytracker/repo/bazaar_repo.dart';
import 'package:moneytracker/utilis/helpers.dart';
import 'package:moneytracker/views/dashboard/home/bazaar/add_bazaar_sheet.dart';
import 'package:moneytracker/views/dashboard/home/bazaar/receipt_preview_view.dart';

import '../../../../utilis/colors.dart';

class BazaarView extends StatelessWidget {
  const BazaarView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BazaarBloc(BazaarRepository())..add(BazaarLoadByDate(DateTime.now())),
      child: const _DailyBazaarView(),
    );
  }
}

class _DailyBazaarView extends StatelessWidget {
  const _DailyBazaarView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BazaarBloc, BazaarState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: ProjectColor.whiteColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(Icons.arrow_back_ios, color: ProjectColor.blackColor),
            ),
            backgroundColor: ProjectColor.whiteColor,
            elevation: 0,
            title: const Text(
              "Daily Bazaar",
              style: TextStyle(
                color: ProjectColor.blackColor,
                fontWeight: FontWeight.w900,
              ),
            ),
            actions: [
              IconButton(
                tooltip: "Pick date",
                onPressed: () async {
                  final now = DateTime.now();
                  final picked = await showDatePicker(
                    context: context,
                    firstDate: DateTime(now.year - 3),
                    lastDate: DateTime(now.year + 1),
                    initialDate: state.selectedDate,
                  );
                  if (picked != null && context.mounted) {
                    context.read<BazaarBloc>().add(BazaarLoadByDate(picked));
                  }
                },
                icon: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: ProjectColor.lavenderPurple.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: ProjectColor.lavenderPurple.withOpacity(0.25),
                    ),
                  ),
                  child: const Icon(Icons.calendar_month,
                      color: ProjectColor.electricPurple),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: ProjectColor.electricPurple,
            onPressed: () async {
              await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                // builder: (_) => const AddBazaarSheet(),
                builder: (_) => BlocProvider.value(
                  value: context.read<BazaarBloc>(),
                  child: const AddBazaarSheet(),
                ),
              );
            },
            child: const Icon(Icons.add, color: Colors.white),
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _headerCard(state, context),
                const SizedBox(height: 12),
                _totalCard(state),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Bazaar List",
                        style: TextStyle(fontWeight: FontWeight.w900)),
                    Text(
                      "${state.list.length}",
                      style: TextStyle(color: ProjectColor.grey),
                    )
                  ],
                ),
                const SizedBox(height: 8),

                if (state.loading)
                  _loadingCard()
                else if (state.list.isEmpty)
                  _emptyCard()
                else
                  ...state.list.map((row) => _bazaarTile(context, row)),
                const SizedBox(height: 90),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _headerCard(BazaarState state, BuildContext context) {
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
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black12),
            ),
            child: const Icon(Icons.shopping_bag_outlined,
                color: ProjectColor.electricPurple),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Daily Bazaar Tracker",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(
                  "Selected: ${Helpers.fmtDate(state.selectedDate)}",
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),

          InkWell(
            onTap: () {
              print("Download daily report");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ReceiptPreviewPage(
                    bazaarId: null,
                    reportDate: state.selectedDate ,
                  ),
                ),
              );
               
            },
            child: Container(
             // width: 100,
             // height: ,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black12),
              ),
              // child: const Icon(Icons.shopping_bag_outlined,
              //     color: ProjectColor.electricPurple),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "Today report",
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 12),
                      ),
                      const Icon(Icons.download,
                      color: ProjectColor.electricPurple),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _totalCard(BazaarState state) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: ProjectColor.lavenderPurple.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: ProjectColor.lavenderPurple.withOpacity(0.25),
              ),
            ),
            child: const Icon(Icons.paid_outlined,
                color: ProjectColor.electricPurple),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text("Total Amount",
                style: TextStyle(fontWeight: FontWeight.w900)),
          ),
          Text(
            "\$${state.total.toStringAsFixed(2)}",
            style: const TextStyle(
                fontWeight: FontWeight.w900, fontSize: 16),
          )
        ],
      ),
    );
  }

  Widget _bazaarTile(BuildContext context, Map<String, dynamic> row) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(0, 8),
            color: Color(0x0F000000),
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ReceiptPreviewPage(
                bazaarId: row["id"] as int ,
                // reportDate: DateTime.now() ,
              ),
            ),
          );
        },
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: ProjectColor.lavenderPurple.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
            border:
                Border.all(color: ProjectColor.lavenderPurple.withOpacity(0.25)),
          ),
          child: const Icon(Icons.receipt_long_outlined,
              color: ProjectColor.electricPurple),
        ),
        title: Text(
          "${row["bazaar_name"]}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        subtitle: Text(
          "${row["note"] ?? ""}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: ProjectColor.grey, fontSize: 12),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "\$${(row["amount"] as num).toDouble().toStringAsFixed(2)}",
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 2),
            Text(Helpers.fmtIso(row["created_at"] as String),
                style: TextStyle(color: ProjectColor.grey, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _loadingCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ProjectColor.lavenderPurple.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ProjectColor.lavenderPurple.withOpacity(0.20)),
      ),
      child: const Row(
        children: [
          SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
          SizedBox(width: 10),
          Expanded(child: Text("Loading...")),
        ],
      ),
    );
  }

  Widget _emptyCard() {
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
            child: Text(
              "No bazaar data found for this date.\nTap + to add new.",
              style: TextStyle(color: ProjectColor.grey),
            ),
          ),
        ],
      ),
    );
  }
}