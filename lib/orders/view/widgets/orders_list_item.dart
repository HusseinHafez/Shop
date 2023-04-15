import 'package:flutter/material.dart';
import 'package:myshop/orders/model/order_model.dart';
import 'package:myshop/size_config.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class OrdersListItem extends StatefulWidget {
  final OrderItem orderItem;

  const OrdersListItem({
    Key? key,
    required this.orderItem,
  }) : super(key: key);

  @override
  State<OrdersListItem> createState() => _OrdersListItemState();
}

class _OrdersListItemState extends State<OrdersListItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Material(
        borderRadius: BorderRadius.circular(15),
        elevation: 5,
        shadowColor: Theme.of(context).colorScheme.secondary,
        child: Column(
          children: [
            ListTile(
              title: Text(
                '\$${widget.orderItem.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: getFont(25),
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm')
                    .format(widget.orderItem.dateTime),
                style: TextStyle(
                  fontSize: getFont(20),
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
                icon: Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            if (_expanded)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                height: min(
                  widget.orderItem.products.length * 20 + getHeight(20),
                  getHeight(100),
                ),
                child: ListView(
                  children: widget.orderItem.products
                      .map((e) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                e.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: getFont(24),
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              Text(
                                '${e.quantity}x \$${e.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: getFont(20),
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ],
                          ))
                      .toList(),
                ),
              )
          ],
        ),
      ),
    );
  }
}
