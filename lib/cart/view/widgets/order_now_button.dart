import 'package:flutter/material.dart';
import 'package:myshop/cart/controller/cart_controller.dart';
import 'package:provider/provider.dart';

import '../../../orders/controller/order_controller.dart';

class OrderNowButton extends StatefulWidget {
  final CartController cart;

  const OrderNowButton({Key? key, required this.cart}) : super(key: key);

  @override
  State<OrderNowButton> createState() => _OrderNowButtonState();
}

class _OrderNowButtonState extends State<OrderNowButton> {
   bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.totalAmount <= 0 || isLoading)
          ? null
          : () async{
       setState(() {
         isLoading=true;
       });
        await Provider.of<OrdersController>(context, listen: false)
            .addOrder(
        widget.cart.items.values.toList(),
        widget.cart.totalAmount,
        );
        setState(() {
          isLoading=false;
        });
        widget.cart.clear();
      },
      child: isLoading
          ? const CircularProgressIndicator()
          : Text(
        'ORDER NOW',
        style: TextStyle(
          color: widget.cart.totalAmount <= 0
              ? Colors.grey
              : Theme.of(context).colorScheme.secondary,
          fontWeight: FontWeight.bold,
        ),
      ),

    );

    /*GestureDetector(
      onTap: (cart.totalAmount <= 0 || cart.isLoading)
          ? null
          :()=> cart.onTap(context),
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
    );*/
  }
}
