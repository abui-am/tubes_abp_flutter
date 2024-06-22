import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tiketkonser_mobile/model/concert.dart';
import 'concertPage.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final String userName;
  final String email;
  final String userId;

  const HomePage(
      {super.key,
      required this.userName,
      required this.email,
      required this.userId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Concert> concerts = [];

  @override
  late List<Concert> filteredConcerts;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredConcerts = concerts;
    searchController.addListener(_filterConcerts);
    _fetchDataConcert();
  }

  void _fetchDataConcert() async {
    try {
      final response =
          await http.get(Uri.parse('http://127.0.0.1:8000/api/concerts'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          concerts = data.map((e) => Concert.fromJson(e)).toList();
          filteredConcerts = concerts;
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void dispose() {
    searchController.removeListener(_filterConcerts);
    searchController.dispose();
    super.dispose();
  }

  void _filterConcerts() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredConcerts = concerts.where((concert) {
        final title = concert.title.toLowerCase();
        return title.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pemesanan Tiket Konser'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                '${widget.userName}, ${widget.email}',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[800],
                hintText: 'Masukkan nama konser',
                hintStyle: const TextStyle(color: Colors.white54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredConcerts.length,
                itemBuilder: (context, index) {
                  final concert = filteredConcerts[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConcertPage(
                                userId: widget.userId, concert: concert),
                          ),
                        );
                      },
                      child: Card(
                        color: Colors.grey[900],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(concert.imageURL),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4.0),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    concert.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    concert.date.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${concert.artists} • ${concert.city}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
