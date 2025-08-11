import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

const RESEND_API_KEY = process.env.RESEND_API_KEY as string | undefined;

type Role = 'admin' | 'employee' | 'client';

interface Appointment {
  startAt: admin.firestore.Timestamp;
  priceCents?: number;
  customerEmail?: string;
}

export const setUserRole = functions.https.onCall(
  async (
    data: { uid: string; businessId: string; role: Role },
    context: functions.https.CallableContext
  ) => {
    if (context.auth?.token?.role !== 'admin') {
      throw new functions.https.HttpsError('permission-denied', 'Admins only');
    }
    const { uid, businessId, role } = data ?? ({} as any);
    if (!uid || !businessId) {
      throw new functions.https.HttpsError('invalid-argument', 'Missing args');
    }
    if (!['admin', 'employee', 'client'].includes(role)) {
      throw new functions.https.HttpsError('invalid-argument', 'Invalid role');
    }
    await admin.auth().setCustomUserClaims(uid, { businessId, role });
    return { ok: true };
  }
);

export const onAppointmentCreated = functions.firestore
  .document('businesses/{businessId}/appointments/{appointmentId}')
  .onCreate(async (snap: functions.firestore.QueryDocumentSnapshot) => {
    const appt = snap.data() as Appointment;
    const customerEmail = appt.customerEmail;

    if (RESEND_API_KEY && customerEmail) {
      await fetch('https://api.resend.com/emails', {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${RESEND_API_KEY}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          from: 'Bookings <noreply@yourdomain.com>',
          to: [customerEmail],
          subject: 'Appointment Confirmation',
          html: `<p>Your appointment is confirmed for ${appt.startAt
            .toDate()
            .toLocaleString()}</p>`
        })
      });
    }
  });

export const onAppointmentWrite = functions.firestore
  .document('businesses/{businessId}/appointments/{appointmentId}')
  .onWrite(
    async (
      change: functions.Change<functions.firestore.DocumentSnapshot>,
      ctx: functions.EventContext<{ businessId: string; appointmentId: string }>
    ) => {
      const { businessId } = ctx.params;
      const before = change.before.exists
        ? (change.before.data() as Appointment)
        : null;
      const after = change.after.exists
        ? (change.after.data() as Appointment)
        : null;

      const dateKey = (ts: admin.firestore.Timestamp) =>
        ts.toDate().toISOString().slice(0, 10);

      const inc = (
        ref: admin.firestore.DocumentReference,
        countDelta: number,
        revenueDelta: number
      ) =>
        ref.set(
          {
            appointmentsCount: admin.firestore.FieldValue.increment(countDelta),
            revenueCents: admin.firestore.FieldValue.increment(revenueDelta),
            updatedAt: admin.firestore.FieldValue.serverTimestamp()
          },
          { merge: true }
        );

      const db = admin.firestore();

      if (!before && after) {
        const ref = db.doc(
          `businesses/${businessId}/metrics_daily/${dateKey(after.startAt)}`
        );
        await inc(ref, 1, after.priceCents || 0);
      } else if (before && !after) {
        const ref = db.doc(
          `businesses/${businessId}/metrics_daily/${dateKey(before.startAt)}`
        );
        await inc(ref, -1, -(before.priceCents || 0));
      } else if (
        before &&
        after &&
        before.startAt.toMillis() !== after.startAt.toMillis()
      ) {
        await inc(
          db.doc(
            `businesses/${businessId}/metrics_daily/${dateKey(before.startAt)}`
          ),
          -1,
          -(before.priceCents || 0)
        );
        await inc(
          db.doc(
            `businesses/${businessId}/metrics_daily/${dateKey(after.startAt)}`
          ),
          1,
          after.priceCents || 0
        );
      }
    }
  );