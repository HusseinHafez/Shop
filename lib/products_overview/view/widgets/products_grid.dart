import 'package:flutter/material.dart';
import 'package:myshop/products_overview/controller/products_controller.dart';
import 'package:provider/provider.dart';

import 'product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;
  const ProductsGrid({super.key,required this.showFavs,});
  @override
  Widget build(BuildContext context) {
     final productsData=Provider.of<ProductsController>(context);
     final products=showFavs? productsData.favoritesItems:productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        childAspectRatio: 3 / 2,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: const ProductItem(
         /* id: products[index].id,
          title: products[index].title,
          imageUrl: products[index].imageUrl,*/
        ),
      ),
      itemCount: products.length,
    );
  }
}
