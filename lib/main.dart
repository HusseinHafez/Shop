import 'package:flutter/material.dart';
import 'package:myshop/auth/controller/auth_controller.dart';
import 'package:myshop/cart/view/cart_screen.dart';
import 'package:myshop/orders/controller/order_controller.dart';
import 'package:myshop/orders/view/orders_screen.dart';
import 'package:myshop/splash_screen.dart';
import 'package:myshop/user_products/view/user_products_screen.dart';
import '/cart/controller/cart_controller.dart';
import '/product_details/view/product_details_screen.dart';
import '/products_overview/controller/products_controller.dart';
import '/products_overview/view/products_overview_screen.dart';
import 'package:provider/provider.dart';

import 'add_and_edit_product/view/add_and_edit_product.dart';
import 'auth/view/auth_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthController(),
        ),
        ChangeNotifierProxyProvider<AuthController, ProductsController>(
          create: (_) => ProductsController(),
          update: (context, auth, previousProducts) =>
              ProductsController.update(
            auth.token,
            auth.userId,
            previousProducts == null ? [] : previousProducts.items,
          )..didChangeDependencies(),
        ),
        ChangeNotifierProxyProvider<AuthController, OrdersController>(
          create: (_) => OrdersController(),
          update: (context, auth, previousOrders) => OrdersController.update(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.orders,
          )..didChangeDependencies(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartController(),
        ),
      ],
      child: Consumer<AuthController>(
        builder: (context, AuthController auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
                color: Color.fromARGB(255, 33, 111, 125),
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: .8,
                )),
            useMaterial3: true,
            colorScheme:
                ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey).copyWith(
              secondary: const Color.fromARGB(255, 29, 68, 73),
              background:
                  const Color.fromARGB(255, 157, 179, 190).withOpacity(.7),
              error: Colors.red,
            ),
            fontFamily: 'Lato',
          ),
          home: auth.isAuth
              ? const ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogIn(),
                  builder: (context,authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthScreen(),
                ),
          routes: {
          //  ProductsOverviewScreen.routeName:(_)=>const ProductsOverviewScreen(),
            ProductsDetailsScreen.routeName: (_) =>
                const ProductsDetailsScreen(),
            CartScreen.routeName: (_) => const CartScreen(),
            OrdersScreen.routeName: (_) => const OrdersScreen(),
            UserProductsScreen.routeName: (_) => const UserProductsScreen(),
            AddAndEditProduct.routeName: (_) => const AddAndEditProduct(),
          },
        ),
      ),
    );
  }
}
