import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  int? todaysAppointments;
  num? todaysRevenueCents;
  String? error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      error = null;
      todaysAppointments = null;
      todaysRevenueCents = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Not signed in');
      final token = await user.getIdTokenResult();
      final bizId = token.claims?['businessId'] as String?;
      if (bizId == null) throw Exception('No businessId claim');

      final now = DateTime.now();
      final start = Timestamp.fromDate(DateTime(now.year, now.month, now.day));
      final end = Timestamp.fromDate(
        DateTime(now.year, now.month, now.day).add(const Duration(days: 1)),
      );

      final agg = await FirebaseFirestore.instance
          .collection('businesses')
          .doc(bizId)
          .collection('appointments')
          .where('startAt', isGreaterThanOrEqualTo: start)
          .where('startAt', isLessThan: end)
          .count()
          .get();

      final metricsDoc = await FirebaseFirestore.instance
          .doc(
            'businesses/$bizId/metrics_daily/${DateTime(now.year, now.month, now.day).toIso8601String().substring(0, 10)}',
          )
          .get();

      setState(() {
        todaysAppointments = agg.count;
        todaysRevenueCents = (metricsDoc.data()?['revenueCents'] as num?) ?? 0;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (error != null)
              Text(error!, style: const TextStyle(color: Colors.red)),
            Text('Today\'s appointments: ${todaysAppointments ?? '...'}'),
            Text(
              'Today\'s revenue: ${todaysRevenueCents != null ? (todaysRevenueCents! / 100).toStringAsFixed(2) : '...'}',
            ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _load, child: const Text('Refresh')),
          ],
        ),
      ),
    );
  }
}
