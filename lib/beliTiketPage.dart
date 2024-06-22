import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiketkonser_mobile/model/concert.dart';
import 'package:tiketkonser_mobile/model/seat.dart';
import 'seat_selection_controller.dart';

import 'package:http/http.dart' as http;

class BeliTiketPage extends StatefulWidget {
  final Concert concert;
  String userId = '';
  BeliTiketPage({super.key, required this.concert, required this.userId});

  @override
  _BeliTiketPage createState() => _BeliTiketPage();
}

class _BeliTiketPage extends State<BeliTiketPage> {
  Concert get concert => widget.concert;
  final SeatSelectionController controller = Get.put(SeatSelectionController());
  void fetchOccupiedSeats({
    required String concertId,
    String userId = '',
    required String seatType,
  }) async {
    print('Fetching occupied seats');
    try {
      final response = await http.get(
        Uri.parse(
            'http://localhost:8000/api/seats?concert_id=$concertId&user_id=$userId&seat_type=$seatType'),
      );
      if (response.statusCode == 200) {
        final List<Seat> data = json
            .decode(response.body)['data']
            .map<Seat>((e) => Seat.fromJson(e))
            .toList();
        print(data);

        List<String> occupiedSeats = data.map((e) => e.seatNo).toList();
        controller.updateOccupiedSeats(occupiedSeats);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchOccupiedSeats(
      concertId: widget.concert.id.toString(),
      seatType: 'VIP',
    );
  }

  @override
  Widget build(BuildContext context) {
    // Initialize controller inside the build method if you're using GetX for state management

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beli Tiket'),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(concert.imageURL),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.7),
                BlendMode.dstATop,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                Text(
                  concert.title,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${concert.date} • ${concert.artists} • ${concert.city}',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Jenis Tiket',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              ChoiceChip(
                                label: const Text(
                                  'VIP',
                                  style: TextStyle(color: Colors.white),
                                ),
                                selected: controller.ticketType == 'vip',
                                onSelected: (selected) async {
                                  controller.updateTicketType('vip');
                                  fetchOccupiedSeats(
                                    concertId: widget.concert.id.toString(),
                                    seatType: 'VIP',
                                  );
                                },
                                backgroundColor: Colors.grey[700],
                                selectedColor: Colors.pink[500],
                              ),
                              const SizedBox(width: 10),
                              ChoiceChip(
                                label: const Text(
                                  'Regular',
                                  style: TextStyle(color: Colors.white),
                                ),
                                selected: controller.ticketType == 'regular',
                                onSelected: (selected) {
                                  controller.updateTicketType('regular');
                                  fetchOccupiedSeats(
                                    concertId: widget.concert.id.toString(),
                                    seatType: 'Regular',
                                  );
                                },
                                backgroundColor: Colors.grey[700],
                                selectedColor: Colors.pink[500],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Obx(() {
                        return Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: controller.availableSeats.map((seat) {
                            Color seatColor = controller.seatColor(seat);
                            return GestureDetector(
                              onTap: () {
                                if (!controller.occupiedSeats.contains(seat)) {
                                  controller.toggleSeatSelection(seat);
                                }
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: seatColor,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Center(
                                  child: Text(
                                    seat,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total:',
                                style: TextStyle(color: Colors.white),
                              ),
                              Obx(() {
                                return Text(
                                  '\$${controller.totalPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                );
                              }),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Get.toNamed('/checkoutPage', arguments: {
                                'userId': widget.userId,
                                'ticketDetails': {
                                  'id': concert.id,
                                  'imageURL': concert.imageURL,
                                  'title': concert.title,
                                  'date': concert.date,
                                  'artists': concert.artists,
                                  'city': concert.city,
                                  'totalPrice': controller.totalPrice,
                                },
                                'seatNumbers':
                                    controller.selectedSeats.toList(),
                                'seatType': controller.ticketType,
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                            ),
                            child: const Text('Dapatkan Tiket'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
