import 'package:flutter/material.dart';
import 'package:tiketkonser_mobile/model/concert.dart';
import 'beliTiketPage.dart';

class ConcertPage extends StatelessWidget {
  final Concert concert;
  final String userId;

  const ConcertPage({super.key, required this.userId, required this.concert});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(concert.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                concert.title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                '${concert.date} • ${concert.artists} • ${concert.city}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                concert.description ?? '',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BeliTiketPage(userId: userId, concert: concert),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2FA7EA),
                  minimumSize: const Size(112, 48),
                ),
                child: const Text(
                  'Beli Tiket',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _showConcertDetails(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  minimumSize: const Size(112, 48),
                ),
                child: const Text(
                  'Informasi Lanjut',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  void _showConcertDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1F2937),
          title: const Text('Informasi Konser',
              style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Artists: ${concert.artists}',
                  style: const TextStyle(color: Colors.white)),
              Text('Date: ${concert.date}',
                  style: const TextStyle(color: Colors.white)),
              Text('City: ${concert.city}',
                  style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 10),
              const Text('Description:', style: TextStyle(color: Colors.white)),
              Text(concert.description ?? '',
                  style: const TextStyle(color: Colors.white)),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
