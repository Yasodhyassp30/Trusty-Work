import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sem/userwidgets/viewworker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class searchedlist extends StatefulWidget {
  final QuerySnapshot? sreachedlist;
  final togglerfunction;
  const searchedlist({Key? key, this.sreachedlist, this.togglerfunction})
      : super(key: key);

  @override
  State<searchedlist> createState() => _searchedlistState();
}

class _searchedlistState extends State<searchedlist> {
  bool view = false;
  var selected = null;
  void toggler() {
    view = !view;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<DocumentSnapshot> workerlist = widget.sreachedlist!.docs;
    workerlist.sort((b, a) => (a.get('ratecount') != 0.0
            ? (a.get('Rating') / a.get('ratecount'))
            : 0.0)
        .compareTo(b.get('ratecount') != 0.0
            ? (b.get('Rating') / b.get('ratecount'))
            : 0.0));
    if (view) {
      return viewworker(workerdata: selected, toggler: toggler);
    } else {
      return SafeArea(
          child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Search Results",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {
                        widget.togglerfunction();
                      },
                      icon: Icon(Icons.clear))
                ]),
          ),
          Text(
            "Ordered by Highest Rating",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Expanded(
              child: Container(
            padding: EdgeInsets.all(10),
            child: (widget.sreachedlist!.docs.length != 0)
                ? ListView.builder(
                    itemCount: widget.sreachedlist!.docs.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 5.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selected = workerlist[index];
                              view = true;
                            });
                          },
                          child: Column(children: [
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      flex: 7,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          Text(
                                            workerlist[index]['Username'],
                                            style: TextStyle(fontSize: 15.0),
                                          ),
                                          Text(
                                            "Contact No :${workerlist[index]['Contact_No']}",
                                            style: TextStyle(fontSize: 15.0),
                                          ),
                                          RatingBarIndicator(
                                            rating: (workerlist[index]
                                                        ['ratecount'] >
                                                    0
                                                ? workerlist[index]['Rating'] /
                                                    workerlist[index]
                                                        ['ratecount']
                                                : 0),
                                            itemSize: 20.0,
                                            itemPadding: EdgeInsets.symmetric(
                                                horizontal: 0.0),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        flex: 3,
                                        child: Column(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor:
                                                  Colors.green[500],
                                              radius: 40.0,
                                              backgroundImage: AssetImage(
                                                  'assets/avatar.png'),
                                              foregroundImage: NetworkImage(
                                                  workerlist[index]
                                                      ['photoURL']),
                                            )
                                          ],
                                        ))
                                  ],
                                ),
                              ],
                            ),
                          ]),
                        ),
                      );
                    })
                : Center(
                    child: Text('No Employees Found!',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold))),
          ))
        ]),
      ));
    }
  }
}
