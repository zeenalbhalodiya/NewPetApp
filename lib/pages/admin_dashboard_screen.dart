import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import '../components/colors.dart';
import '../controller/adminController.dart';
import 'dart:math';


class AdminDashboardPage extends StatefulWidget {
  @override
  _AdminDashboardPageState createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  var controller = Get.put(AdminController());
  List<PieChartSectionData> _userSections = [];
  // Static map to map titles to colors
  static const Map<String, Color> titleToColor = {
    'Users': Colors.blue,
    'Cats': Colors.green,
    'Dogs': Colors.orange,
    'Sold Cats': Colors.pink,
    'Sold Dogs': Colors.purple,

  };

  @override
  void initState() {
    refreshPage().whenComplete(() {
    });
    super.initState();
  }

  Future refreshPage() async {
    await controller.getUserList();
    await controller.getPetList();
    _userSections = [

      PieChartSectionData(
        color: titleToColor['Users']!,
        value: controller.allUserList.value.length.toDouble(),
        title: 'Users',
        radius: 50,
        titleStyle: TextStyle(fontSize: 14, color: Colors.white),
      ),
      PieChartSectionData(
        color: titleToColor['Cats']!,
        value: controller.allCatList.value.length.toDouble(),
        title: 'Cats',
        radius: 50,
        titleStyle: TextStyle(fontSize: 14, color: Colors.white),
      ),
      PieChartSectionData(
        color: titleToColor['Dogs']!,
        value: controller.allDogList.value.length.toDouble(),
        title: 'Dogs',
        radius: 50,
        titleStyle: TextStyle(fontSize: 14, color: Colors.white),
      ),

      PieChartSectionData(
        color: titleToColor['Sold Cats']!,
        value: controller.allCatSoldList.value.length.toDouble(),
        title: 'Sold Cats',
        radius: 50,
        titleStyle: TextStyle(fontSize: 14, color: Colors.white),
      ),

      PieChartSectionData(
        color: titleToColor['Sold Dogs']!,
        value: controller.allDogSoldList.value.length.toDouble(),
        title: 'Sold Dogs',
        radius: 50,
        titleStyle: TextStyle(fontSize: 14, color: Colors.white),
      ),
    ];
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pie Charts',
          style: TextStyle(color: Colors.white),),
        backgroundColor: appColor,
        actions: [],
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Expanded(
            child: Center(
              child: PieChart(
                PieChartData(
                  sections:  _userSections ,
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  startDegreeOffset: 180,
                  pieTouchData: PieTouchData(enabled: false),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          UserLegendTable(),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}

class UserLegendTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.shade200,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _AdminDashboardPageState.titleToColor.entries.map((entry) {
            Color color = entry.value;
            String title = entry.key;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  AnimatedShape(color: color),
                  SizedBox(width: 10),
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class AnimatedShape extends StatefulWidget {
  final Color color;

  AnimatedShape({required this.color});

  @override
  _AnimatedShapeState createState() => _AnimatedShapeState();
}

class _AnimatedShapeState extends State<AnimatedShape>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
    AnimationController(duration: Duration(seconds: 2), vsync: this)
      ..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _animation.value,
          child: CustomPaint(
            size: Size(30, 30),
            painter: ShapePainter(widget.color),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ShapePainter extends CustomPainter {
  final Color color;

  ShapePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();

    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(0, size.height / 2);
    path.close();

    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
