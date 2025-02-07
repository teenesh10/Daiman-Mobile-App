/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// const { onRequest } = require("firebase-functions/v2/https");
// const logger = require("firebase-functions/logger");
// const admin = require("firebase-admin");
// const stripe = require("stripe")("sk_test_51QXxohJMi70xUkuHPH0EqLy0PLI2sR8xJAXfxq6iiTY18I9el4Y1bwIJ7wHrCbr5n64jedOaAniV285Tipu6HIvE00axPlmvQ0");

// // Initialize Firebase Admin
// admin.initializeApp();

// exports.createPaymentIntent = onRequest(async (req, res) => {
//   try {
//     const { amount, currency } = req.body; // Get data from request

//     // Create a PaymentIntent with the specified payment methods
//     const paymentIntent = await stripe.paymentIntents.create({
//       amount,
//       currency,
//       payment_method_types: ["card", "fpx"],
//     });

//     res.status(200).send({
//       clientSecret: paymentIntent.client_secret,
//     });
//   } catch (error) {
//     logger.error("Error creating PaymentIntent:", error);
//     res.status(400).send({ error: error.message });
//   }
// });

const functions = require('firebase-functions');
const Stripe = require('stripe');
const stripe = Stripe('sk_test_51QXxohJMi70xUkuHPH0EqLy0PLI2sR8xJAXfxq6iiTY18I9el4Y1bwIJ7wHrCbr5n64jedOaAniV285Tipu6HIvE00axPlmvQ0');

exports.createPaymentIntent = functions.region('asia-southeast1').https.onRequest(async (req, res) => {
  if (req.method !== 'POST') {
    res.status(405).send('Method Not Allowed');
    return;
  }

  const { amount, currency } = req.body;

  try {
    const paymentIntent = await stripe.paymentIntents.create({
      amount,
      currency,
    });

    res.status(200).send({ clientSecret: paymentIntent.client_secret });
  } catch (error) {
    res.status(500).send({ error: error.message });
  }
});