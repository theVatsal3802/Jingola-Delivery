import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/order_tile.dart';
import '../models/order_model.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = "/home";
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("orders")
                .where(
                  "status",
                  isEqualTo: "Out for Delivery",
                  isNotEqualTo: "In Delivery"
                )
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    "No new Deliveries",
                    textScaleFactor: 1,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                );
              }
              return ListView.builder(
                itemBuilder: (context, index) {
                  return OrderTile(
                    order: Order.fromSnapshot(
                      snapshot.data!.docs[index],
                    ),
                  );
                },
                itemCount: snapshot.data!.docs.length,
              );
            }),
      ),
    );
  }
}
