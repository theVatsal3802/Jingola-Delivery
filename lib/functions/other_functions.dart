import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OtherFunctions {
  static Future<void> acceptDelivery(
    String orderId,
    BuildContext context,
  ) async {
    try {
      await FirebaseFirestore.instance.collection("orders").doc(orderId).update(
        {"status": "In Delivery"},
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Something went wrong, please try again.",
            textScaleFactor: 1,
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  static Future<void> completeDelivery(
    String orderId,
    BuildContext context,
  ) async {
    try {
      await FirebaseFirestore.instance.collection("orders").doc(orderId).update(
        {"status": "Delivered"},
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Something went wrong, please try again.",
            textScaleFactor: 1,
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
