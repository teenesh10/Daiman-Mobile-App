const { onRequest } = require("firebase-functions/v2/https");
const { initializeApp } = require("firebase-admin/app");
const Stripe = require("stripe");

initializeApp();

const stripe = Stripe(
  "sk_test_51QXxohJMi70xUkuHPH0EqLy0PLI2sR8xJAXfxq6iiTY18I9el4Y1bwIJ7wHrCbr5n64jedOaAniV285Tipu6HIvE00axPlmvQ0"
);

exports.createPaymentIntent = onRequest(
  { region: "us-central1" },
  async (req, res) => {
    try {
      const { amount, currency, email } = req.body;

      if (!amount || !currency) {
        res.status(400).send("Missing required parameters: amount or currency");
        return;
      }

      const paymentIntent = await stripe.paymentIntents.create({
        amount,
        currency,
        receipt_email: email,
        payment_method_types: ["card", "fpx", "grabpay"],
      });

      res.status(200).send({
        clientSecret: paymentIntent.client_secret,
      });
    } catch (error) {
      console.error("Error creating payment intent:", error);
      res.status(500).send("Internal Server Error");
    }
  }
);

exports.createCheckoutSession = onRequest(
  { region: "us-central1" },
  async (req, res) => {
    try {
      const { amount, currency, email, paymentMethod } = req.body;

      if (!amount || !currency || !paymentMethod) {
        res.status(400).send("Missing required parameters");
        return;
      }

      const session = await stripe.checkout.sessions.create({
        payment_method_types: [paymentMethod], // 'fpx' or 'grabpay'
        line_items: [
          {
            price_data: {
              currency,
              product_data: {
                name: `Daiman Booking - ${paymentMethod.toUpperCase()}`,
              },
              unit_amount: amount,
            },
            quantity: 1,
          },
        ],
        mode: "payment",
        customer_email: email,
        success_url: "https://daiman-stripe.netlify.app/payment-success.html",
        cancel_url: "https://daiman-stripe.netlify.app/payment-cancel.html",
      });

      res.status(200).send({ sessionUrl: session.url });
    } catch (error) {
      console.error("Error creating checkout session:", error);
      res.status(500).send("Internal Server Error");
    }
  }
);
