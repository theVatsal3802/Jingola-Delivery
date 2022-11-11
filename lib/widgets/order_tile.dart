import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/order_model.dart';
import '../functions/other_functions.dart';

class OrderTile extends StatefulWidget {
  final Order order;
  const OrderTile({
    super.key,
    required this.order,
  });

  @override
  State<OrderTile> createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  String name = "";
  String phone = "";
  Future<String> getStatus() async {
    var result = await FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.order.id)
        .get();
    final res = result.get("status");
    return res;
  }

  Future<void> getUserData() async {
    final user = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.order.userId)
        .get();
    name = user["name"];
    phone = user["phoneNumber"];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center();
        }
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  "Status: ${snapshot.data}",
                  textScaleFactor: 1,
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: snapshot.data == "Out for Delivery"
                            ? Theme.of(context).colorScheme.primary
                            : snapshot.data == "In Delivery"
                                ? Theme.of(context).colorScheme.secondary
                                : Colors.green,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  "Items",
                  textScaleFactor: 1,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    List itemName = widget.order.items.keys.toList();
                    List itemQuantity = widget.order.items.values.toList();
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          itemName[index],
                          textScaleFactor: 1,
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                        Text(
                          itemQuantity[index],
                          textScaleFactor: 1,
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                      ],
                    );
                  },
                  itemCount: widget.order.items.keys.length,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      child: Text(
                        widget.order.location,
                        softWrap: true,
                        textScaleFactor: 1,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Amount:",
                      softWrap: true,
                      textScaleFactor: 1,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Chip(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      label: Text(
                        "₹${widget.order.total}",
                        softWrap: true,
                        textScaleFactor: 1,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              FutureBuilder(
                future: getUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  }
                  return Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          softWrap: true,
                          textScaleFactor: 1,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        Chip(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          label: SelectableText(
                            phone,
                            textScaleFactor: 1,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (snapshot.data == "Out for Delivery")
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () async {
                        await OtherFunctions.acceptDelivery(
                          widget.order.id,
                          context,
                        ).then(
                          (_) {
                            setState(() {});
                          },
                        );
                      },
                      child: const Text(
                        "Accept Delivery",
                        textScaleFactor: 1,
                      ),
                    ),
                  if (snapshot.data == "In Delivery")
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () async {
                        await OtherFunctions.completeDelivery(
                          widget.order.id,
                          context,
                        ).then(
                          (_) {
                            setState(() {});
                          },
                        );
                      },
                      child: const Text(
                        "Complete Delivery",
                        textScaleFactor: 1,
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
