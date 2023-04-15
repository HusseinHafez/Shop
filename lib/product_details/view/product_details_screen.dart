import 'package:flutter/material.dart';
import 'package:myshop/products_overview/controller/products_controller.dart';
import 'package:myshop/size_config.dart';
import 'package:provider/provider.dart';

class ProductsDetailsScreen extends StatelessWidget {
  static const String routeName = '/product_details';

  const ProductsDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    final productData = Provider.of<ProductsController>(
      context,
      listen: false,
    ).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          productData.title,
          style: TextStyle(
            fontSize: getFont(
              30,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: getHeight(300),
              width: double.infinity,
              child: Image.network(
                productData.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: getHeight(10),
            ),
            Text(
              '\$${productData.price.toStringAsFixed(2)}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
                fontSize: getFont(25),
              ),
            ),
            SizedBox(
              height: getHeight(10),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                productData.description,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: getFont(20),
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
