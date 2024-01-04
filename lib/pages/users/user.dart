import 'package:bacabox/pages/users/user_create.dart';
import 'package:bacabox/pages/users/user_detail.dart';
import 'package:bacabox/theme/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserPage extends StatefulWidget {
  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  var refreshFlag = false;
  var searchQuery = '';

  void queryUsers(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colour.secondary,
      appBar: AppBar(
        backgroundColor: Colour.secondary,
        title: Center(
          child: Text(
            'Users',
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (value) {
                queryUsers(value);
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
            Text(
              'All Users',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: usersCollection.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final List<DocumentSnapshot> users = snapshot.data!.docs;

                  final filteredusers = searchQuery.isEmpty
                      ? users
                      : users.where((users) {
                          final name = users['name'].toString().toLowerCase();
                          return name.contains(searchQuery);
                        }).toList();
                  if (filteredusers.isEmpty) {
                    return Center(
                      child: Text(
                        'Users tidak ditemukan',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredusers.length,
                    itemBuilder: (context, index) {
                      var usersData =
                          filteredusers[index].data() as Map<String, dynamic>;
                      String name = usersData['name'];
                      String username = usersData['username'];
                      String role = usersData['role'];

                      return GestureDetector(
                          child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage('images/user.png'),
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
                                      color: Colors.black,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        username,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        role,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            IconButton(
                              onPressed: () {
                                Get.to(() => UserDetail(), arguments: {
                                  'id': filteredusers[index].id,
                                  'name': name,
                                  'role': usersData['role'],
                                  'password': usersData['password'],
                                  'username': usersData['username'],
                                });
                              },
                              icon: Icon(Icons.more_vert),
                              color: Colour.primary,
                              iconSize: 40,
                            ),
                          ],
                        ),
                      ));
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colour.primary,
        onPressed: () {
          Get.to(() => UserCreate());
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
