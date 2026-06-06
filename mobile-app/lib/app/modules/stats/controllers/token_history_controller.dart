import 'package:get/get.dart';

class TokenHistoryController extends GetxController {
  final selectedFilterIndex = 0.obs; // 0 for Last 6 Months, 1 for All to Date

  final earnedTokens = 2500.obs;
  final spentTokens = 1250.obs;

  final monthlyTrendData = <ChartData>[
    ChartData('Jun', 40, 340),
    ChartData('July', 450, 480),
    ChartData('Aug', 210, 230),
    ChartData('Sep', 200, 500),
    ChartData('Oct', 100, 90),
    ChartData('Nov', 450, 150),
  ].obs;

  final recentTransactions = <TokenTransaction>[
    TokenTransaction(
      title: 'Sold an item',
      date: 'Nov 28, 2024',
      time: '2:30 PM',
      amount: 150,
      isEarned: true,
    ),
    TokenTransaction(
      title: 'Purchase discount',
      date: 'Nov 28, 2024',
      time: '2:30 PM',
      amount: -100,
      isEarned: false,
    ),
    TokenTransaction(
      title: 'Sold an item',
      date: 'Nov 28, 2024',
      time: '2:30 PM',
      amount: 150,
      isEarned: true,
    ),
  ].obs;

  void onFilterChanged(int index) {
    selectedFilterIndex.value = index;
    // Update data based on filter if needed
  }

  void onBackTap() {
    Get.back();
  }
}

class ChartData {
  ChartData(this.month, this.spent, this.earned);
  final String month;
  final double spent;
  final double earned;
}

class TokenTransaction {
  final String title;
  final String date;
  final String time;
  final int amount;
  final bool isEarned;

  TokenTransaction({
    required this.title,
    required this.date,
    required this.time,
    required this.amount,
    required this.isEarned,
  });
}
