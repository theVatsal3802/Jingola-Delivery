import 'package:cloud_firestore/cloud_firestore.dart';

class OtherFunctions {
  static Future<void> acceptDelivery(String orderId) async {
    await FirebaseFirestore.instance.collection("orders").doc(orderId).update(
      {"status": "In Delivery"},
    );
  }

  static Future<void> completeDelivery(String orderId) async {
    await FirebaseFirestore.instance.collection("orders").doc(orderId).update(
      {"status": "Delivered"},
    );
  }
}
