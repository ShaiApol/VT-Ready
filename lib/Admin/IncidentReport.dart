import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_ngo/Admin/EditIIncidentReport.dart';
import 'package:project_ngo/Admin/AdminHome.dart';
import 'package:project_ngo/components.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'AddIncidentReport.dart';

class IncidentReport extends StatefulWidget {
  @override
  _IncidentReportState createState() => _IncidentReportState();
}

class _IncidentReportState extends State<IncidentReport> {
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: AdminTheme,
        child: Scaffold(
            body: SafeArea(
          child: Column(
            children: [
              AdminUpBar(),
              Expanded(
                  child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  Text("Natural Accidents Occurred"),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("incident_report")
                          .doc("natural_accidents")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = snapshot.data!.data() as Map;
                          NaturalAccidents accidents = NaturalAccidents(
                            data['big_waves'],
                            data['coastal_erosion'],
                            data['continuous_rains'],
                            data['disease_outbreak'],
                            data['drought'],
                            data['earthquake'],
                            data['el_nino'],
                            data['flashflood'],
                            data['ground_movement'],
                            data['landslide'],
                            data['lightning_strike'],
                            data['lpa'],
                            data['northeast_monsoons'],
                            data['sea_swellings'],
                            data['sinkhole'],
                            data['southwest_monsoon'],
                            data['tall_end_of_a_coldfront'],
                            data['thunderstorms'],
                            data['tornadoes'],
                            data['volcanic_activity'],
                            data['wildfire'],
                          );
                          return SfCartesianChart(
                            primaryXAxis: CategoryAxis(
                                interval: 0.4,
                                labelStyle: TextStyle(fontSize: 11)),
                            primaryYAxis: NumericAxis(
                                minimum: 0, maximum: 40, interval: 10),
                            series: <ChartSeries<_ChartData, String>>[
                              BarSeries<_ChartData, String>(
                                  dataSource:
                                      accidents.serializeIntoChartData(),
                                  xValueMapper: (_ChartData data, _) => data.x,
                                  yValueMapper: (_ChartData data, _) => data.y,
                                  name: 'Gold',
                                  color: Color.fromRGBO(8, 142, 255, 1))
                            ],
                          );
                        } else
                          return Center(child: CircularProgressIndicator());
                      })
                ],
              )),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Expanded(
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("incident_report")
                                .doc("natural_accidents")
                                .collection("incidents")
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Table(
                                  children: [
                                    TableRow(children: [
                                      TableCell(child: Text("Incident")),
                                      TableCell(child: Text("Location")),
                                      TableCell(child: Text("Date")),
                                      TableCell(child: Text("Victims")),
                                      TableCell(child: Text("Solved?"))
                                    ]),
                                    ...snapshot.data!.docs.map((e) {
                                      var data = e.data() as Map;
                                      return TableRow(children: [
                                        TableCell(
                                            child: TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditIncidentReport(
                                                            data: e)));
                                          },
                                          child: Text(data['name']),
                                        )),
                                        TableCell(
                                            child: Text(data['location'])),
                                        TableCell(
                                            child: Text(DateTime
                                                    .fromMicrosecondsSinceEpoch(
                                                        (data['date_time']
                                                                as Timestamp)
                                                            .microsecondsSinceEpoch)
                                                .toString())),
                                        TableCell(
                                            child: Text(
                                                data['victims'].toString())),
                                        TableCell(
                                            child:
                                                Text(data['solved'].toString()))
                                      ]);
                                    })
                                  ],
                                );
                              }
                              return CircularProgressIndicator();
                            })),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddIncidentReport()));
                        },
                        child: Row(
                          children: [
                            Expanded(child: Text("Add New Incident Report"))
                          ],
                        ))
                  ],
                ),
              )),
              AdminBottomBar()
            ],
          ),
        )));
  }
}

class NaturalAccidents {
  int big_waves,
      coastal_erosion,
      continuous_rains,
      disease_outbreak,
      drought,
      earthquake,
      el_nino,
      flashflood,
      ground_movement,
      landslide,
      lightning_strike,
      lpa,
      northeast_monsoons,
      sea_swellings,
      sinkhole,
      southwest_monsoon,
      tall_end_of_a_coldfront,
      thunderstorms,
      tornadoes,
      volcanic_activity,
      wildfire;

  NaturalAccidents(
      this.big_waves,
      this.coastal_erosion,
      this.continuous_rains,
      this.disease_outbreak,
      this.drought,
      this.earthquake,
      this.el_nino,
      this.flashflood,
      this.ground_movement,
      this.landslide,
      this.lightning_strike,
      this.lpa,
      this.northeast_monsoons,
      this.sea_swellings,
      this.sinkhole,
      this.southwest_monsoon,
      this.tall_end_of_a_coldfront,
      this.thunderstorms,
      this.tornadoes,
      this.volcanic_activity,
      this.wildfire);

  List<_ChartData> serializeIntoChartData() {
    List<_ChartData> chartData = [];
    chartData.add(_ChartData("Big Waves", big_waves));
    chartData.add(_ChartData("Coastal Erosion", coastal_erosion));
    chartData.add(_ChartData("Continuous Rains", continuous_rains));
    chartData.add(_ChartData("Disease Outbreak", disease_outbreak));
    chartData.add(_ChartData("Drought", drought));
    chartData.add(_ChartData("Earthquake", earthquake));
    chartData.add(_ChartData("El Nino", el_nino));
    chartData.add(_ChartData("Flashflood", flashflood));
    chartData.add(_ChartData("Ground Movement", ground_movement));
    chartData.add(_ChartData("Landslide", landslide));
    chartData.add(_ChartData("Lightning Strike", lightning_strike));
    chartData.add(_ChartData("LPA", lpa));
    chartData.add(_ChartData("Northeast Monsoons", northeast_monsoons));
    chartData.add(_ChartData("Sea Swellings", sea_swellings));
    chartData.add(_ChartData("Sinkhole", sinkhole));
    chartData.add(_ChartData("Southwest Monsoon", southwest_monsoon));
    chartData
        .add(_ChartData("Tall End of a Coldfront", tall_end_of_a_coldfront));
    chartData.add(_ChartData("Thunderstorms", thunderstorms));
    chartData.add(_ChartData("Tornadoes", tornadoes));
    chartData.add(_ChartData("Volcanic Activity", volcanic_activity));
    chartData.add(_ChartData("wildfire", wildfire));
    return chartData;
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final int y;
}
