import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

import '../components/colors.dart';
import '../controller/adminController.dart';


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
        actions: [

        ],
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
          UserLegendTable()
        ],
      ),
    );
  }
}

class UserLegendTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder.all(color: Colors.grey),
        children:

        _AdminDashboardPageState.titleToColor.entries.map((entry) => TableRow(
          children: [
            Container(
              color: entry.value,
              width: 30,
              height: 30,
              margin: EdgeInsets.all(5),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                entry.key,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        )).toList()


      ),
    );
  }
}

