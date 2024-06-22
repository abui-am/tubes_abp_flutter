import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;

class SeatSelectionController extends GetxController {
  var selectedSeats = <String>[].obs;
  var occupiedSeats = <String>[].obs;

  List<String> vipSeats = ['F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7'];
  List<String> regularSeats =
      List.generate(42, (index) => (index + 1).toString());

  double vipTicketPrice = 500000;
  double regularTicketPrice = 350000;

  String ticketType = 'vip';

  void toggleSeatSelection(String seat) {
    if (selectedSeats.contains(seat)) {
      selectedSeats.remove(seat);
    } else {
      selectedSeats.add(seat);
    }
    update();
  }

  double get totalPrice {
    return ticketType == 'vip'
        ? selectedSeats.length * vipTicketPrice
        : selectedSeats.length * regularTicketPrice;
  }

  List<String> get availableSeats {
    return ticketType == 'vip' ? vipSeats : regularSeats;
  }

  Color seatColor(String seat) {
    if (occupiedSeats.contains(seat)) {
      return Colors.red; // Kursi yang sudah dibooking
    } else if (selectedSeats.contains(seat)) {
      return Colors.blue; // Kursi yang dipilih
    } else {
      return Colors.grey; // Kursi kosong/available
    }
  }

  void updateTicketType(String type) {
    ticketType = type;
    selectedSeats.clear();
    update();
  }

  void updateOccupiedSeats(List<String> seats) {
    occupiedSeats.clear();
    occupiedSeats.addAll(seats);
    update();
  }
}
