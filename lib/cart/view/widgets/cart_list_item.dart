import 'package:flutter/material.dart';
import 'package:myshop/cart/controller/cart_controller.dart';
import 'package:myshop/size_config.dart';
import 'package:provider/provider.dart';

class CartListItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  const CartListItem({
    Key? key,
    required this.quantity,
    required this.price,
    required this.title,
    required this.id,
    required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.only(right: 10),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: getFont(40),
        ),
      ),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
              title: Text(
                'Are you sure?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: getFont(25),
                ),
              ),
              content: Text(
                'Do you want to remove this item from cart?',
                style: TextStyle(
                  fontSize: getFont(22),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              actions: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(ctx).pop(true);
                  },
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: getFont(20),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(ctx).pop(false);
                  },
                  child: Text(
                    'No',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: getFont(20),
                    ),
                  ),
                )
              ]),
        );
      },
      onDismissed: (direction) {
        Provider.of<CartController>(context, listen: false)
            .removeItem(productId);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Material(
          borderRadius: BorderRadius.circular(15),
          elevation: 5,
          shadowColor: Theme.of(context).colorScheme.secondary,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: FittedBox(
                    child: Text(
                      '\$${price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              title: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: getFont(22),
                ),
              ),
              subtitle: Text(
                'Total: \$${(price * quantity).toStringAsFixed(1)}',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                '$quantity x',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: getFont(20)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
