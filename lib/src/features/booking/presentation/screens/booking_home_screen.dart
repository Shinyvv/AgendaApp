import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/booking_calendar.dart';

class BookingHomeScreen extends ConsumerWidget {
  const BookingHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book an appointment')),
      body: const Padding(
        padding: EdgeInsets.all(12),
        child: BookingCalendar(),
      ),
    );
  }
}
