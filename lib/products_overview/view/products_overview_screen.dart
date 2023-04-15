import 'package:flutter/material.dart';
import 'package:myshop/cart/controller/cart_controller.dart';
import 'package:myshop/cart/view/cart_screen.dart';
import 'package:myshop/products_overview/controller/products_controller.dart';
import 'package:myshop/products_overview/view/widgets/app_drawer.dart';
import 'package:myshop/products_overview/view/widgets/badge.dart';
import 'package:myshop/products_overview/view/widgets/products_grid.dart';
import 'package:myshop/size_config.dart';
import 'package:myshop/products_overview/model/product_model.dart';
import 'package:provider/provider.dart';

class ProductsOverviewScreen extends StatelessWidget {
  static const String routeName='/';
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsController>(context, listen: false);
    SizeConfig().init(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'MyShop',
            style: TextStyle(fontSize: getFont(30)),
          ),
          actions: [
            PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: FilterOptions.favorite,
                  child: Text(
                    'Favorites only',
                  ),
                ),
                const PopupMenuItem(
                  value: FilterOptions.all,
                  child: Text(
                    'Show All',
                  ),
                ),
              ],
              icon: const Icon(Icons.more_vert),
              onSelected: products.onSelected,
            ),
            Consumer<CartController>(
              builder: (_, cart, ch) =>
                  Badge(value: cart.itemsCount.toString(), child: ch!),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
                icon: const Icon(
                  Icons.shopping_cart,
                ),
              ),
            )
          ],
        ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
          future: products.fetchAndSetProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Consumer<ProductsController>(
                  builder: (context, prod, child) =>
                      ProductsGrid(showFavs: prod.showFavoritesOnly));
            }
          },
        ));
  }
}
