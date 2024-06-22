import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CheckoutPage extends StatelessWidget {
  final Map<String, dynamic> ticketDetails;
  final String userId;
  final List<String> seatNumbers;
  final String seatType;

  const CheckoutPage(
      {super.key,
      required this.ticketDetails,
      required this.userId,
      required this.seatType,
      required this.seatNumbers});

  Future<void> _confirm() async {
    // Create seats
    try {
      seatNumbers.forEach((seatNumber) async {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:8000/api/seats'),
          body: {
            'concert_id': ticketDetails['id'].toString(),
            'seat_no': seatNumber,
            'seat_type': seatType,
            'user_id': userId,
          },
        );

        if (response.statusCode == 201) {
          print('Seat created');
        }
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informasi Tiket:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                title: Text(ticketDetails['title']),
                subtitle: Text(
                    '${ticketDetails['date']} • ${ticketDetails['artists']} • ${ticketDetails['city']}'),
                leading: Image.network(
                  ticketDetails['imageURL'],
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Total Pembayaran:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '\$${ticketDetails['totalPrice'].toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implementasi untuk mengunggah bukti pembayaran
                // Misalnya dengan menampilkan dialog atau navigasi ke halaman unggah gambar
                // Contoh:
                // Navigator.push(context, MaterialPageRoute(builder: (context) => UploadPaymentPage()));
                // Atau menampilkan dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Upload Bukti Pembayaran'),
                    content: const Text('Fitur ini belum diimplementasikan.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Unggah Bukti Pembayaran'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _confirm();

                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Successfully buy seats')));

                // Back to previous page
                Navigator.pop(context);
              },
              child: const Text('Konfirmasi'),
            ),
          ],
        ),
      ),
    );
  }
}
