import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppointmentRepository {
  final _db = FirebaseFirestore.instance;

  /// Creates an appointment with per-slot locks to avoid double booking.
  /// Locks are created under: businesses/{biz}/locks/{employeeId}_{millis}
  /// for each 30-minute slot between [startAt, endAt).
  Future<void> createAppointment({
    required String businessId,
    required String employeeId,
    required String customerId,
    required String serviceId,
    required Timestamp startAt,
    required Timestamp endAt,
    required int priceCents,
    Duration slotStep = const Duration(minutes: 30),
  }) async {
    final apptRef = _db
        .collection('businesses')
        .doc(businessId)
        .collection('appointments')
        .doc();

    final start = startAt.toDate();
    final end = endAt.toDate();
    final lockRefs = <DocumentReference>[];
    for (var t = start; t.isBefore(end); t = t.add(slotStep)) {
      final lockId = '${employeeId}_${t.millisecondsSinceEpoch}';
      final lockRef = _db
          .collection('businesses')
          .doc(businessId)
          .collection('locks')
          .doc(lockId);
      lockRefs.add(lockRef);
    }

    await _db.runTransaction((txn) async {
      // Check all locks
      for (final ref in lockRefs) {
        final snap = await txn.get(ref);
        if (snap.exists) {
          throw Exception('Selected time is no longer available');
        }
      }
      // Create locks
      for (final ref in lockRefs) {
        txn.set(ref, {
          'employeeId': employeeId,
          'appointmentId': apptRef.id,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      // Create appointment
      txn.set(apptRef, {
        'employeeId': employeeId,
        'customerId': customerId,
        'serviceId': serviceId,
        'startAt': startAt,
        'endAt': endAt,
        'status': 'confirmed',
        'priceCents': priceCents,
        'createdBy': FirebaseAuth.instance.currentUser?.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Stream<QuerySnapshot> watchDaily({
    required String businessId,
    required DateTime day,
  }) {
    final start = Timestamp.fromDate(DateTime(day.year, day.month, day.day));
    final end = Timestamp.fromDate(start.toDate().add(const Duration(days: 1)));
    return _db
        .collection('businesses')
        .doc(businessId)
        .collection('appointments')
        .where('startAt', isGreaterThanOrEqualTo: start)
        .where('startAt', isLessThan: end)
        .orderBy('startAt')
        .snapshots();
  }
}
