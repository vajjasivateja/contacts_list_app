import 'dart:math';

import 'package:flutter/material.dart';

import '../res/colors.dart';
import 'PieChart.dart';

class CustomPieChart extends StatelessWidget {
  final List<PieChart> pieCharts;
  final String normalText;
  final double strokeWidth;

  const CustomPieChart({
    Key? key,
    required this.pieCharts,
    required this.normalText,
    required this.strokeWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalValue = 0.0;
    for (final pieChart in pieCharts) {
      totalValue += pieChart.value;
    }
    return Card(
      elevation: 2,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
      shadowColor: Colors.black54,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 120.0,
                      height: 120.0,
                      child: CustomPaint(
                        painter: CircularProgressBarPainterForList(
                          pieCharts: pieCharts,
                          strokeWidth: strokeWidth,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          totalValue.toInt().toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          normalText,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Spacer between the CircularProgressBar and the CustomListItem column
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomListItem(pieChart: pieCharts[0]),
                CustomListItem(pieChart: pieCharts[1]),
                CustomListItem(pieChart: pieCharts[2]),
                // Add more CustomListItem widgets as needed
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CircularProgressBarPainterForList extends CustomPainter {
  final List<PieChart> pieCharts;
  final double strokeWidth;

  CircularProgressBarPainterForList({
    required this.pieCharts,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    );

    final Paint backgroundPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(rect.center, rect.width / 2, backgroundPaint);

    double startPercentage = 0.0;

    for (final pieChart in pieCharts) {
      final double endPercentage = startPercentage + pieChart.percentage;
      final Paint fillPaint = Paint()
        ..color = pieChart.color
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = strokeWidth;
      _drawArc(canvas, rect, fillPaint, startPercentage, endPercentage);
      startPercentage = endPercentage;
    }
  }

  void _drawArc(Canvas canvas, Rect rect, Paint paint, double startPercentage, double endPercentage) {
    final double startRadians = 2 * pi * (startPercentage / 100);
    final double endRadians = 2 * pi * (endPercentage / 100);
    canvas.drawArc(rect, -pi / 2 + startRadians, endRadians - startRadians, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CustomListItem extends StatelessWidget {
  final PieChart pieChart;

  const CustomListItem({super.key, required this.pieChart});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: pieChart.color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 5),
              Text(
                pieChart.name,
                style: const TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.normal),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                pieChart.value.toInt().toString(),
                style: const TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),
              Text(
                "${pieChart.percentage.toInt()}%",
                style: const TextStyle(fontSize: 14.0, color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }
}
