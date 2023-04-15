import 'package:flutter/material.dart';
import 'package:myshop/cart/controller/cart_controller.dart';
import 'package:myshop/cart/view/widgets/cart_list_item.dart';
import 'package:myshop/cart/view/widgets/order_now_button.dart';

//import 'package:myshop/orders/controller/order_controller.dart';
import 'package:myshop/size_config.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = '/cart_screen';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Cart',
          style: TextStyle(
            fontSize: getFont(30),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Material(
              borderRadius: BorderRadius.circular(15),
              elevation: 5,
              shadowColor: Theme.of(context).colorScheme.primary,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: getFont(25)),
                    ),
                    const Spacer(),
                    Chip(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      label: Text(
                        '\$${cart.totalAmount.toStringAsFixed(1)}',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: getWidth(10),
                    ),
                   OrderNowButton(cart: cart,)/*async{
        await Provider.of<OrdersController>(context, listen: false)
            .addOrder()
          cart.items.values.toList(),
          cart.totalAmount,
        );
        cart.clear();
      }*/
                     /* ,
                      child: cart.isLoading
                          ? const CircularProgressIndicator()
                          : Text(
                              'ORDER NOW',
                              style: TextStyle(
                                color: cart.totalAmount <= 0
                                    ? Colors.grey
                                    : Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),*/
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: getHeight(20),
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (context, i) => CartListItem(
              quantity: cart.items.values.toList()[i].quantity,
              price: cart.items.values.toList()[i].price,
              title: cart.items.values.toList()[i].title,
              id: cart.items.values.toList()[i].id,
              productId: cart.items.keys.toList()[i],
            ),
            itemCount: cart.items.length,
          ))
        ],
      ),
    );
  }
}
