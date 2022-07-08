import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sem/workingwidgets/locationfinder.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class calenderwork extends StatefulWidget {
  final toggler;
  const calenderwork({Key? key, this.toggler}) : super(key: key);

  @override
  State<calenderwork> createState() => _calenderworkState();
}

class _calenderworkState extends State<calenderwork> {
  DateTime _selected = DateTime.now();
  List today = [];
  @override
  Widget build(BuildContext context) {
    print(_selected);
    return SafeArea(
        child: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('requests')
              .where('Reciever',
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .where('accepted', isEqualTo: true)
              .get(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState != ConnectionState.waiting) {
              today = [];
              for (var i in snapshot.data!.docs) {
                if (i.get('date') ==
                    DateFormat('yyyy-MM-dd').format(_selected)) {
                  today.add(i);
                }
              }
            }
            return Column(children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.lightGreen[400],
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(50)),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 5.0,
                    ),
                    IconButton(
                        onPressed: () {
                          widget.toggler();
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 30,
                        )),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      "Schedule",
                      style: TextStyle(fontSize: 25.0, color: Colors.white),
                    ),
                    Expanded(child: SizedBox()),
                  ],
                ),
              ),
              TableCalendar(
                  firstDay: DateTime.utc(DateTime.now().year - 1,
                      DateTime.now().month, DateTime.now().day),
                  lastDay: DateTime.utc(DateTime.now().year + 1,
                      DateTime.now().month, DateTime.now().day),
                  focusedDay: DateTime.now(),
                  calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                          color: Colors.green[900], shape: BoxShape.circle),
                      selectedDecoration: BoxDecoration(
                          color: Colors.lightGreen, shape: BoxShape.circle)),
                  selectedDayPredicate: (day) {
                    return isSameDay(_selected, day);
                  },
                  onDaySelected: (selected, day) {
                    _selected = day;
                    setState(() {});
                  }),
              Expanded(
                  child: Container(
                padding: EdgeInsets.all(10),
                child: ListView.builder(
                    itemCount: today.length,
                    itemBuilder: (context, k) {
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.assignment),
                                Text(
                                  "  " + today[k]['title'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Expanded(child: SizedBox()),
                                (today[k]['completed'])
                                    ? Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      )
                                    : (today[k]['date'] ==
                                            DateFormat('yyyy-MM-dd')
                                                .format(DateTime.now()))
                                        ? ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.green),
                                            icon: Icon(Icons.timer),
                                            onPressed: () {
                                              Map directions = {
                                                'lat': today[k]['lat'],
                                                'long': today[k]['long']
                                              };
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          locationfind(
                                                            locationdetails:
                                                                directions,
                                                          )));
                                            },
                                            label: Text("Start"),
                                          )
                                        : Icon(
                                            Icons.upcoming,
                                            color: Colors.green,
                                          )
                              ],
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Row(
                              children: [
                                Icon(Icons.payment),
                                Text("   Payment  : " +
                                    today[k]['payment'].toString()),
                                Expanded(child: SizedBox()),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.person),
                                Text("   Name  : " +
                                    today[k]['Name'].toString()),
                                Expanded(child: SizedBox()),
                              ],
                            ),
                            Divider(
                              height: 5,
                              thickness: 2,
                              color: Colors.black26,
                            )
                          ],
                        ),
                      );
                    }),
              ))
            ]);
          })),
    ));
  }
}
