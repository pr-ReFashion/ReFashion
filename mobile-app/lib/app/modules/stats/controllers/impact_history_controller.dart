import 'package:get/get.dart';

class ImpactHistoryController extends GetxController {
  final selectedFilterIndex = 0.obs; // 0 for Last 6 Months, 1 for All to Date

  final monthlyImpactData = <ImpactChartData>[
    ImpactChartData('Jun', 140, 150, 40),
    ImpactChartData('July', 100, 70, 60),
    ImpactChartData('Aug', 200, 160, 50),
    ImpactChartData('Sep', 120, 300, 60),
    ImpactChartData('Oct', 90, 150, 140),
    ImpactChartData('Nov', 40, 90, 90),
  ].obs;

  void onFilterChanged(int index) {
    selectedFilterIndex.value = index;
  }

  void onBackTap() {
    Get.back();
  }
}

class ImpactChartData {
  ImpactChartData(this.month, this.co2, this.water, this.landfill);
  final String month;
  final double co2;
  final double water;
  final double landfill;
}
