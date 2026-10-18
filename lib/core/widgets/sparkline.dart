import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pulse/core/theme/pulse_theme.dart';
import 'package:pulse/core/utils/context_ext.dart';

/// Minimal line chart without axes or touch.
class Sparkline extends StatelessWidget {
  const new({required this.values, required this.color, this.height = 34, super.key});

  final List<int> values;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (values.length < 2) return SizedBox(height: height);
    final minV = values.reduce((a, b) => a < b ? a : b).toDouble();
    final maxV = values.reduce((a, b) => a > b ? a : b).toDouble();
    final pad = (maxV - minV) * 0.1 + 1;
    return ExcludeSemantics(
      child: SizedBox(
        height: height,
        child: LineChart(
          LineChartData(
            minY: minV - pad,
            maxY: maxV + pad,
            minX: 0,
            maxX: (values.length - 1).toDouble(),
            gridData: const FlGridData(show: false),
            titlesData: const FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            lineTouchData: const LineTouchData(enabled: false),
            lineBarsData: [
              LineChartBarData(
                spots: [for (var i = 0; i < values.length; i++) FlSpot(i.toDouble(), values[i].toDouble())],
                color: color,
                barWidth: 2.5,
                isStrokeCapRound: true,
                isStrokeJoinRound: true,
                dotData: const FlDotData(show: false),
              ),
            ],
          ),
          duration: context.motion(Motion.chart),
        ),
      ),
    );
  }
}
