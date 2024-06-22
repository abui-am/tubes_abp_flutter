import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiketkonser_mobile/beliTiketPage.dart';
import 'package:tiketkonser_mobile/checkoutPage.dart';
import 'package:tiketkonser_mobile/homePage.dart';
import 'package:tiketkonser_mobile/loginPage.dart';
import 'package:tiketkonser_mobile/model/concert.dart';
import 'package:tiketkonser_mobile/registerPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark().copyWith(
          secondary: Colors.white,
          primary: Colors.blue,
        ),
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const LoginPage()),
        GetPage(
          name: '/belitiketPage',
          page: () => BeliTiketPage(
              userId: '1',
              concert: Concert(
                  id: 1,
                  title: 'Concert Title',
                  date: DateTime.now(),
                  artists: 'Artist 1, Artist 2',
                  city: 'City',
                  description: 'Description',
                  imageURL: 'https://via.placeholder.com/150',
                  videoURL: 'https://www.youtube.com/watch?v=6n3pFFPSlW4',
                  additionalInformation: 'Additional Information',
                  venueAddress: 'Venue Address',
                  venue: 'Venue',
                  ticketPriceInRupiah: 20000)),
        ),
        GetPage(
          name: '/register',
          page: () => const RegisterPage(),
        ),
        GetPage(
          name: '/checkoutPage',
          page: () {
            final args = Get.arguments;
            if (args is Map<String, dynamic>) {
              return CheckoutPage(
                  userId: args['userId'],
                  seatNumbers: args['seatNumbers'],
                  seatType: args['seatType'],
                  ticketDetails: args['ticketDetails']);
            } else {
              return const Scaffold(
                body: Center(
                  child: Text('Invalid arguments for /checkoutPage'),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
