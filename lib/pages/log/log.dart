import 'package:bacabox/theme/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Log extends StatefulWidget {
  const Log({super.key});

  @override
  State<Log> createState() => _LogState();
}

class _LogState extends State<Log> {
  final CollectionReference logsCollection =
      FirebaseFirestore.instance.collection('logs');
  var refreshFlag = false;
  var searchQuery = '';

  void queryProduk(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colour.secondary,
          title: Center(
            child: Text(
              "Log",
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        backgroundColor: Colour.secondary,
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(children: [
            TextField(
              onChanged: (value) {
                queryProduk(value);
              },
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
              ),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                labelText: 'Search',
                labelStyle: TextStyle(
                  color: Colour.primary,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: logsCollection.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final List<DocumentSnapshot> logs = snapshot.data!.docs;

                  final filteredlogs = searchQuery.isEmpty
                      ? logs
                      : logs.where((logs) {
                          final name =
                              logs['userName'].toString().toLowerCase();
                          return name.contains(searchQuery);
                        }).toList();
                  if (filteredlogs.isEmpty) {
                    return Center(
                      child: Text(
                        'Log tidak ditemukan',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredlogs.length,
                    itemBuilder: (context, index) {
                      var logsData =
                          filteredlogs[index].data() as Map<String, dynamic>;
                      String name = logsData['userName'];
                      String activity = logsData['activity'];

                      return GestureDetector(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(20),
                          height: 94,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage('images/history.png'),
                                width: 40,
                                height: 40,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      activity,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ]),
        ));
  }
}
