import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class MyPieChart extends StatefulWidget {
  const MyPieChart({super.key});

  @override
  State<MyPieChart> createState() => _MyPieChartState();
}

class _MyPieChartState extends State<MyPieChart> {
  late double totalcarvalue;
  late double totalbikevalue;
  late double totalvehiclevalue;

  @override
  void initState() {
    super.initState();
    addchartvalues();
  }

  void addchartvalues() {
    setState(() {
      totalcarvalue = Chart.carvalue;
      totalbikevalue = Chart.bikevalue;
      totalvehiclevalue = Chart.total;
    });
  }

  late Map<String, double> datas = {
    'Cars': totalcarvalue,
    'Bikes': totalbikevalue,
    'Total': totalvehiclevalue
  };
  List<Color> listColors = [Colors.black54, Colors.black38, Colors.black12];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PieChart(
            animationDuration: const Duration(seconds: 2),
            dataMap: datas,
            colorList: listColors,
            chartType: ChartType.ring,
            ringStrokeWidth: 30,
            centerText: 'PIECHART',
            chartLegendSpacing: 50,
            chartRadius: MediaQuery.of(context).size.width / 2,
            chartValuesOptions: const ChartValuesOptions(
                showChartValuesInPercentage: true,
                showChartValueBackground: false,
                showChartValuesOutside: true),
            legendOptions: const LegendOptions(
                showLegendsInRow: true,
                legendPosition: LegendPosition.bottom,
                legendShape: BoxShape.rectangle),
          ),
        ],
      ),
    );
  }
}
class Chart {
  static double carvalue = 0;
  static double bikevalue = 0;
  static double total = carvalue + bikevalue;
}
