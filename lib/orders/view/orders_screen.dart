import 'package:flutter/material.dart';
import 'package:myshop/orders/controller/order_controller.dart';
import 'package:myshop/orders/view/widgets/orders_list_item.dart';
import 'package:myshop/products_overview/view/widgets/app_drawer.dart';
import 'package:myshop/size_config.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  static const String routeName = '/orders_screen';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Orders',
          style: TextStyle(
            fontSize: getFont(
              30,
            ),
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
          future:
              Provider.of<OrdersController>(context,listen: false).fetchAndSetOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.error != null) {
              return const Center(
                child: Text('An Error Occurred'),
              );
            } else {
              return Consumer<OrdersController>(
                builder: (context, ordersData, child) => ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemBuilder: (context, i) =>
                      OrdersListItem(orderItem: ordersData.orders[i]),
                  itemCount: ordersData.orders.length,
                ),
              );
            }
          }),
    );
  }
}
