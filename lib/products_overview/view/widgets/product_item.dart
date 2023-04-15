import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myshop/auth/controller/auth_controller.dart';
import 'package:myshop/cart/controller/cart_controller.dart';
import 'package:myshop/product_details/view/product_details_screen.dart';
import 'package:myshop/products_overview/model/product_model.dart';
import 'package:provider/provider.dart';

import '../../../size_config.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<CartController>(context, listen: false);
    final auth = Provider.of<AuthController>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          leading: Consumer<Product>(
            builder: (_, product, child) => IconButton(
              onPressed: () {
                product.toggleFavoriteStatu(authToken: auth.token,userId: auth.userId);
              },
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              cart.addItemToCart(
                product.id!,
                product.price,
                product.title,
              );
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text(
                  'Added An Item To Cart.',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                duration: const Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'UNDO',
                  textColor: Colors.white,
                  onPressed: () {
                    cart.removeSingleItem(product.id!);
                  },
                ),
              ));
            },
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductsDetailsScreen.routeName,
                arguments: product.id);
          },
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: product.imageUrl,
            errorWidget: (context, url, error) => Center(
              child: Text(
                'Error Occurred',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: getFont(23),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
