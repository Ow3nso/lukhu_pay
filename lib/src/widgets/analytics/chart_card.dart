import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show
        AxisTitles,
        CustomColors,
        FlBorderData,
        FlDotData,
        FlGridData,
        FlSpot,
        FlTitlesData,
        LineChart,
        LineChartBarData,
        LineChartData,
        LineTouchData,
        LineTouchTooltipData,
        SideTitleWidget,
        SideTitles,
        StyleColors,
        TitleMeta;
import 'package:lukhu_pay/util/app_util.dart';

class ChartCard extends StatelessWidget {
  ChartCard({super.key});

  // Generate some dummy data for the cahrt
  // This will be used to draw the red line
  final List<FlSpot> dummyData1 = List.generate(8, (index) {
    return FlSpot(index.toDouble(), index * Random().nextDouble());
  });

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyle(
      color: StyleColors.lukhuGrey80,
      fontWeight: FontWeight.w400,
      fontSize: 16,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = 'Mon';
        break;
      case 2:
        text = 'Tue';
        break;
      case 3:
        text = 'Wed';
        break;
      case 4:
        text = 'Thur';
        break;
      case 5:
        text = 'Fri';
        break;
      case 6:
        text = 'Sat';
        break;
      case 7:
        text = 'Sun';
        break;

      default:
        text = '';
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(
        text,
        style: style,
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: StyleColors.lukhuGrey80);
    String text;
    switch (value.toInt()) {
      case 0:
        text = "0";
        break;
      case 1:
        text = '1,000';
        break;
      case 2:
        text = '2,000';
        break;
      case 3:
        text = '3,000';
        break;
      case 4:
        text = '4,000';
        break;
      case 5:
        text = '5,000';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            // The red line
            LineChartBarData(
              spots: dummyData1,
              isCurved: true,
              barWidth: 4,
              isStrokeJoinRound: false,
              preventCurveOverShooting: true,
              color: Theme.of(context).extension<CustomColors>()?.utilitygreen,
              dotData: FlDotData(
                show: false,
              ),
            ),
          ],
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval: 1,
                getTitlesWidget: bottomTitleWidgets,
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                getTitlesWidget: leftTitleWidgets,
                showTitles: true,
                interval: 1,
                reservedSize: 40,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom:
                  BorderSide(color: StyleColors.lukhuDividerColor, width: 2),
              left: const BorderSide(color: Colors.transparent),
              right: const BorderSide(color: Colors.transparent),
              top: const BorderSide(color: Colors.transparent),
            ),
          ),
          lineTouchData: LineTouchData(
            handleBuiltInTouches: true,
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
            ),
          ),
          maxX: 7,
          minX: 0,
          maxY: 5,
          minY: 0,
        ),
        swapAnimationDuration: AppUtil.animationDuration, // Optional
        swapAnimationCurve: Curves.linear, // Optional
      ),
    );
  }
}
