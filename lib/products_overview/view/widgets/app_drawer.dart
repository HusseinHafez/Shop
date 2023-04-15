import 'package:flutter/material.dart';
import 'package:myshop/auth/controller/auth_controller.dart';
import 'package:myshop/orders/view/orders_screen.dart';
import 'package:myshop/products_overview/view/products_overview_screen.dart';
import 'package:myshop/size_config.dart';
import 'package:myshop/user_products/view/user_products_screen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text(
              'Hello Friends',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: getFont(30),
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.shop,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text(
              'Shop',
              style: TextStyle(
                fontSize: getFont(25),
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.payments,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text(
              'Orders',
              style: TextStyle(
                fontSize: getFont(25),
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ), const Divider(),
          ListTile(
            leading: Icon(
              Icons.edit,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text(
              'Your Products',
              style: TextStyle(
                fontSize: getFont(25),
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text(
              'Log Out',
              style: TextStyle(
                fontSize: getFont(25),
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(ProductsOverviewScreen.routeName);
              Provider.of<AuthController>(context,listen: false).logOut();
            },
          )
        ],
      ),
    );
  }
}
