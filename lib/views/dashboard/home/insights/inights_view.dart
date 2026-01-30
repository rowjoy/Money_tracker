import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../bloc/insights_bloc/insights_bloc.dart';
import '../../../../bloc/insights_bloc/insights_event.dart';
import '../../../../bloc/insights_bloc/insights_state.dart';
import '../../../../repo/insights_repo.dart';
import '../../../../utilis/colors.dart';


class InsightsView extends StatelessWidget {
  const InsightsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AnalyticsBloc(AnalyticsRepo())..add(AnalyticsInit()),
      child: const _AnalyticsBody(),
    );
  }
}

class _AnalyticsBody extends StatelessWidget {
  const _AnalyticsBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsBloc, AnalyticsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: ProjectColor.whiteColor,
          appBar: AppBar(
            backgroundColor: ProjectColor.whiteColor,
            elevation: 0,
            automaticallyImplyLeading: false,
            leading: IconButton(
              tooltip: "Back",
              onPressed: () => Navigator.of(context).pop(),
              icon: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: ProjectColor.lavenderPurple.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: ProjectColor.lavenderPurple.withOpacity(0.25)),
                ),
                child: const Icon(Icons.arrow_back_ios_new, color: ProjectColor.electricPurple),
              ),
            ),
            title: const Text(
              "Analytics",
              style: TextStyle(color: ProjectColor.blackColor, fontWeight: FontWeight.w900),
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
                    initialDate: state.anchor,
                  );
                  if (picked != null && context.mounted) {
                    context.read<AnalyticsBloc>().add(AnalyticsChangeDate(picked));
                  }
                },
                icon: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: ProjectColor.lavenderPurple.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: ProjectColor.lavenderPurple.withOpacity(0.25)),
                  ),
                  child: const Icon(Icons.calendar_month, color: ProjectColor.electricPurple),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _periodTabs(context, state),
                const SizedBox(height: 12),

                _summaryCards(state),
                const SizedBox(height: 12),

                _sectionHeader("Wallet (Add vs Cash Out)"),
                const SizedBox(height: 8),
                _chartCard(
                  child: state.loading
                      ? const SizedBox(height: 220, child: Center(child: CircularProgressIndicator()))
                      : barChart(rows: state.walletSeries),
                ),

                const SizedBox(height: 14),
                _sectionHeader("Daily Bazaar Report"),
                const SizedBox(height: 8),
                _chartCard(
                  child: state.loading
                      ? const SizedBox(height: 220, child: Center(child: CircularProgressIndicator()))
                      : barChart(rows: state.bazaarSeries),
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------- UI Pieces ----------
  Widget _periodTabs(BuildContext context, AnalyticsState state) {
    Widget tab(String text, AnalyticsPeriod p) {
      final active = state.period == p;
      return Expanded(
        child: InkWell(
          onTap: () => context.read<AnalyticsBloc>().add(AnalyticsChangePeriod(p)),
          borderRadius: BorderRadius.circular(999),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: active
                  ? ProjectColor.electricPurple.withOpacity(0.10)
                  : ProjectColor.lavenderPurple.withOpacity(0.06),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: active
                    ? ProjectColor.electricPurple.withOpacity(0.35)
                    : ProjectColor.lavenderPurple.withOpacity(0.25),
              ),
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: active ? ProjectColor.electricPurple : ProjectColor.blackColor,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        tab("Day", AnalyticsPeriod.day),
        const SizedBox(width: 8),
        tab("Week", AnalyticsPeriod.week),
        const SizedBox(width: 8),
        tab("Month", AnalyticsPeriod.month),
        const SizedBox(width: 8),
        tab("Year", AnalyticsPeriod.year),
      ],
    );
  }

  Widget _summaryCards(AnalyticsState s) {
    return Row(
      children: [
        Expanded(child: _miniCard(
           ["Add", "Cash Out", "Bazaar" ], 
           [s.income, s.expense, s.bazaarTotal], 
           icon: [Icons.add_circle_outline, Icons.remove_circle_outline, Icons.shopping_bag_outlined]
          ),
        ),
        // const SizedBox(width: 10),
        // Expanded(child: _miniCard("Cash Out", s.expense, icon: Icons.remove_circle_outline)),
        // const SizedBox(width: 10),
        // Expanded(child: _miniCard("Bazaar", s.bazaarTotal, icon: Icons.shopping_bag_outlined)),
      ],
    );
  }

  Widget _miniCard(List<String> title, List<double> value, {required List<IconData> icon}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
        boxShadow: const [
          BoxShadow(blurRadius: 10, offset: Offset(0, 8), color: Color(0x0F000000)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: MiniCarditems(
              title: title[0],
              value: value[0],
              icon: icon[0],
            ),
          ),
          Expanded(
            child: MiniCarditems(
              title: title[1],
              value: value[1],
              icon: icon[1],
            ),
          ),
          Expanded(
            child: MiniCarditems(
              title: title[2],
              value: value[2],
              icon: icon[2],
            ),
          ),

          
        ],
      ),
    );
  }





  Widget _sectionHeader(String text) {
    return Text(text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: ProjectColor.blackColor));
  }

  Widget _chartCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black12),
      ),
      child: child,
    );
  }

  // ---------- Charts ----------
  Widget barChart({required List<Map<String, dynamic>> rows}) {
    // series row: k, income, expense
    // Build bars: group x=0..n-1
    // final rows = s.walletSeries;
    if (rows.isEmpty) return const SizedBox(height: 220, child: Center(child: Text("No data")));

    final groups = <BarChartGroupData>[];
    for (int i = 0; i < rows.length; i++) {
      final income = ((rows[i]["income"] as num?)?.toDouble() ?? 0.0);
      final expense = ((rows[i]["expense"] as num?)?.toDouble() ?? 0.0);

      groups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            /*
            
            ProjectColor.electricPurple.withOpacity(0.10)
                  : ProjectColor.lavenderPurple.withOpacity(0.06),
            
             */
            BarChartRodData(toY: income, width: 8, color: ProjectColor.electricPurple),
            BarChartRodData(toY: expense, width: 8, color: ProjectColor.lavenderPurple,),
          ],
          barsSpace: 6,
        ),
      );
    }

    return SizedBox(
      height: 220,
      child: BarChart(
        BarChartData(
          
          barGroups: groups,
          gridData: const FlGridData(show: true),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 36)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i < 0 || i >= rows.length) return const SizedBox();
                  final k = "${rows[i]["k"]}";
                  // show last 2 chars of day or month
                  final label = k.length >= 10 ? k.substring(8, 10) : k;
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(label, style: TextStyle(color: ProjectColor.grey, fontSize: 10)),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
  /*
  Widget _bazaarLineChart(AnalyticsState s) {
    final rows = s.bazaarSeries;
    if (rows.isEmpty) return const SizedBox(height: 220, child: Center(child: Text("No data")));

    final spots = <FlSpot>[];
    for (int i = 0; i < rows.length; i++) {
      final total = ((rows[i]["total"] as num?)?.toDouble() ?? 0.0);
      spots.add(FlSpot(i.toDouble(), total));
    }

    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(show: false),
            ),
          ],
          gridData: const FlGridData(show: true),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize:50)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i < 0 || i >= rows.length) return const SizedBox();
                  final k = "${rows[i]["k"]}";
                  final label = k.length >= 10 ? k.substring(8, 10) : k;
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(label, style: TextStyle(color: ProjectColor.grey, fontSize: 10)),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
 */
}

class MiniCarditems extends StatelessWidget {
  final String title;
  final double value;
  final IconData icon;
  const MiniCarditems({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            color: ProjectColor.lavenderPurple.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: ProjectColor.lavenderPurple.withOpacity(0.25)),
          ),
          child: Icon(icon, color: ProjectColor.electricPurple, size: 14),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: ProjectColor.grey, fontSize: 11)),
              const SizedBox(height: 4),
              Text("\$${value.toStringAsFixed(2)}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}
