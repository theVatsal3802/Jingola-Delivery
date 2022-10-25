import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String id;
  final Map<String, dynamic> items;
  final String location;
  final String status;
  final String total;
  final String userId;

  const Order({
    required this.id,
    required this.items,
    required this.location,
    required this.status,
    required this.total,
    required this.userId,
  });

  factory Order.fromSnapshot(DocumentSnapshot snapshot) {
    return Order(
      id: snapshot.id,
      items: snapshot["items"] as Map<String, dynamic>,
      location: snapshot["location"],
      status: snapshot["status"],
      total: snapshot["total"],
      userId: snapshot["userId"],
    );
  }
}
