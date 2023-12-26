import 'package:bacabox/pages/produk_create.dart';
import 'package:bacabox/pages/produk_detail.dart';
import 'package:bacabox/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ProdukPage extends StatefulWidget {
  @override
  State<ProdukPage> createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
  final CollectionReference booksCollection =
      FirebaseFirestore.instance.collection('books');
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
      backgroundColor: Colour.secondary,
      appBar: AppBar(
        backgroundColor: Colour.secondary,
        title: Center(
          child: Text(
            'Produk',
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Text(
                  'All Produk',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: booksCollection.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final List<DocumentSnapshot> books = snapshot.data!.docs;

                final filteredBooks = searchQuery.isEmpty
                    ? books
                    : books.where((book) {
                        final title = book['title'].toString().toLowerCase();
                        return title.contains(searchQuery);
                      }).toList();
                if (filteredBooks.isEmpty) {
                  return Center(
                    child: Text(
                      'Produk tidak ditemukan',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filteredBooks.length,
                  itemBuilder: (context, index) {
                    var bookData =
                        filteredBooks[index].data() as Map<String, dynamic>;
                    String title = bookData['title'];
                    double price = bookData['price']?.toDouble() ?? 0.0;
                    String formattedPrice = currencyFormatter.format(price);

                    return GestureDetector(
                      onTap: () {
                        Get.to(() => ProdukDetail(), arguments: {
                          'id': filteredBooks[index].id,
                          'title': title,
                          'price': price,
                        });
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                              image: AssetImage('images/package.png'),
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
                                    title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    formattedPrice,
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
                            SizedBox(width: 10),
                            IconButton(
                              onPressed: () {
                                Get.to(() => ProdukDetail(), arguments: {
                                  'id': filteredBooks[index].id,
                                  'title': title,
                                  'price': price,
                                });
                              },
                              icon: Icon(Icons.more_vert),
                              color: Colour.primary,
                              iconSize: 40,
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colour.primary,
        onPressed: () {
          Get.to(() => ProdukCreate());
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
