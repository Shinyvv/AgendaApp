"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.onAppointmentWrite = exports.onAppointmentCreated = exports.setUserRole = void 0;
const functions = __importStar(require("firebase-functions"));
const admin = __importStar(require("firebase-admin"));
admin.initializeApp();
const RESEND_API_KEY = process.env.RESEND_API_KEY;
exports.setUserRole = functions.https.onCall(async (data, context) => {
    if (context.auth?.token?.role !== 'admin') {
        throw new functions.https.HttpsError('permission-denied', 'Admins only');
    }
    const { uid, businessId, role } = data ?? {};
    if (!uid || !businessId) {
        throw new functions.https.HttpsError('invalid-argument', 'Missing args');
    }
    if (!['admin', 'employee', 'client'].includes(role)) {
        throw new functions.https.HttpsError('invalid-argument', 'Invalid role');
    }
    await admin.auth().setCustomUserClaims(uid, { businessId, role });
    return { ok: true };
});
exports.onAppointmentCreated = functions.firestore
    .document('businesses/{businessId}/appointments/{appointmentId}')
    .onCreate(async (snap) => {
    const appt = snap.data();
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
exports.onAppointmentWrite = functions.firestore
    .document('businesses/{businessId}/appointments/{appointmentId}')
    .onWrite(async (change, ctx) => {
    const { businessId } = ctx.params;
    const before = change.before.exists
        ? change.before.data()
        : null;
    const after = change.after.exists
        ? change.after.data()
        : null;
    const dateKey = (ts) => ts.toDate().toISOString().slice(0, 10);
    const inc = (ref, countDelta, revenueDelta) => ref.set({
        appointmentsCount: admin.firestore.FieldValue.increment(countDelta),
        revenueCents: admin.firestore.FieldValue.increment(revenueDelta),
        updatedAt: admin.firestore.FieldValue.serverTimestamp()
    }, { merge: true });
    const db = admin.firestore();
    if (!before && after) {
        const ref = db.doc(`businesses/${businessId}/metrics_daily/${dateKey(after.startAt)}`);
        await inc(ref, 1, after.priceCents || 0);
    }
    else if (before && !after) {
        const ref = db.doc(`businesses/${businessId}/metrics_daily/${dateKey(before.startAt)}`);
        await inc(ref, -1, -(before.priceCents || 0));
    }
    else if (before &&
        after &&
        before.startAt.toMillis() !== after.startAt.toMillis()) {
        await inc(db.doc(`businesses/${businessId}/metrics_daily/${dateKey(before.startAt)}`), -1, -(before.priceCents || 0));
        await inc(db.doc(`businesses/${businessId}/metrics_daily/${dateKey(after.startAt)}`), 1, after.priceCents || 0);
    }
});
//# sourceMappingURL=index.js.map