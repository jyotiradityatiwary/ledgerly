import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ledgerly/model/data_classes.dart';
import 'package:ledgerly/model/insights.dart';
import 'package:ledgerly/notifiers/login_notifier.dart';
import 'package:ledgerly/views/reusable/content_container.dart';
import 'package:provider/provider.dart';

class InsightsPage extends StatefulWidget {
  const InsightsPage({super.key});

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  int totalBalance = 0;
  List<FlSpot> dailyExpenditureData = [];
  List<FlSpot> monthlyIncomeData = [];
  List<FlSpot> monthlyExpenditureData = [];
  List<AmountByCategoryDataItem> expenditureByCategoryData = [];
  bool isLoaded = false;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) => _refreshIndicatorKey.currentState!.show());
    super.initState();
  }

  Future<void> refresh() async {
    setState(() {
      totalBalance = getTotalBalance();
      dailyExpenditureData = getDailyExpenditureData();
      monthlyIncomeData = getMonthlyIncomeData();
      monthlyExpenditureData = getMonthlyExpenditureData();
      expenditureByCategoryData = getExpenditureByCategoryData();
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<LoginNotifier>(context).user!;
    final String formattedBalance = user.formatIntMoney(totalBalance);
    final theme = Theme.of(context);
    final dateFormat = DateFormat.yMd();
    final monthFormat = DateFormat.yM();
    final moneyFormat = NumberFormat.compactCurrency(
      symbol: user.currency,
    );
    final dailyExpenditureLineChart = LineChart(LineChartData(
      lineBarsData: [
        LineChartBarData(
          spots: dailyExpenditureData,
        ),
      ],
      titlesData: FlTitlesData(
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: const Duration(days: 5).inMilliseconds.toDouble(),
            getTitlesWidget: (value, meta) => Text(dateFormat
                .format(DateTime.fromMillisecondsSinceEpoch(value.toInt()))),
            maxIncluded: false,
            minIncluded: false,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) => Text(
                moneyFormat.format(user.doubleFromIntMoney(value.toInt()))),
            reservedSize: 60.0,
          ),
        ),
      ),
    ));

    final monthlyIncomeAndExpenditureLineChart = LineChart(LineChartData(
      lineBarsData: [
        LineChartBarData(
          spots: monthlyIncomeData,
          color: Colors.green,
        ),
        LineChartBarData(
          spots: monthlyExpenditureData,
          color: Colors.red,
        )
      ],
      titlesData: FlTitlesData(
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: const Duration(days: 1).inMilliseconds.toDouble(),
            getTitlesWidget: (value, meta) {
              final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
              return date.day == 1
                  ? Text(monthFormat.format(date))
                  : const SizedBox();
            },
            maxIncluded: false,
            minIncluded: false,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) => Text(
                moneyFormat.format(user.doubleFromIntMoney(value.toInt()))),
            reservedSize: 60.0,
          ),
        ),
      ),
    ));

    final children = [
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Total Balance'),
              Text(
                formattedBalance,
                style: theme.textTheme.displaySmall,
              ),
            ],
          ),
        ),
      ),
      Card(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 32.0,
            vertical: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Daily Expenditure',
                style: theme.textTheme.titleLarge,
              ),
              SizedBox(height: 16.0),
              SizedBox(
                height: 500.0,
                width: 500.0,
                child: dailyExpenditureLineChart,
              ),
            ],
          ),
        ),
      ),
      Card(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 32.0,
            vertical: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Monthly Income & Expenditure',
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.0),
              ListView(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                children: [
                  _Indicator(color: Colors.green, label: 'Income'),
                  SizedBox(height: 2.0),
                  _Indicator(color: Colors.red, label: 'Expenditure'),
                ],
              ),
              SizedBox(height: 16.0),
              SizedBox(
                height: 500.0,
                width: 500.0,
                child: monthlyIncomeAndExpenditureLineChart,
              ),
            ],
          ),
        ),
      ),
      Card(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 32.0,
            vertical: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Expenditure by Category',
                style: theme.textTheme.titleLarge,
              ),
              SizedBox(height: 16.0),
              ListView.separated(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) => _Indicator(
                    color: expenditureByCategoryData[index].section.color,
                    label: expenditureByCategoryData[index].name),
                separatorBuilder: (context, index) => const SizedBox(
                  height: 2.0,
                ),
                itemCount: expenditureByCategoryData.length,
              ),
              SizedBox(height: 16.0),
              SizedBox(
                height: 200.0,
                width: 200.0,
                child: PieChart(PieChartData(
                  sections:
                      expenditureByCategoryData.map((e) => e.section).toList(),
                )),
              ),
            ],
          ),
        ),
      ),
    ];
    return RefreshIndicator.adaptive(
      key: _refreshIndicatorKey,
      onRefresh: refresh,
      child: isLoaded
          ? ContentList(children: children)
          : ContentContainer(child: Text('Loading....')),
    );
  }
}

class _Indicator extends StatelessWidget {
  final Color color;
  final String label;
  const _Indicator({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 20.0,
          width: 20.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: color,
          ),
        ),
        SizedBox(
          width: 8.0,
        ),
        Text(label),
      ],
    );
  }
}
