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
const stripe = Stripe('sk_test_51RG0vFQtpx6XeqJu4uL2xGWKexgEgRu7evsSTRNIQNnzz4o8J01oL3IM1FQD58by4I94SSfPpdrSWl1gbHOFc9UG00dTziWwT2'); // Replace with your Stripe secret key

exports.createPaymentIntent = functions.https.onRequest(async (req, res) => {
  try {
    const { amount, currency } = req.body;

    const paymentIntent = await stripe.paymentIntents.create({
      amount,
      currency,
    });

    res.status(200).send({
      clientSecret: paymentIntent.client_secret,
    });
  } catch (error) {
    console.error("Error creating payment intent:", error);
    res.status(500).send("Internal Server Error");
  }
});
