import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myshop/add_and_edit_product/view/add_and_edit_product.dart';
import 'package:myshop/products_overview/controller/products_controller.dart';
import 'package:myshop/size_config.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String title;

  const UserProductItem({
    Key? key,
    required this.id,
    required this.title,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffold=ScaffoldMessenger.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: Theme.of(context).colorScheme.secondary,
          elevation: 8,
          shadowColor: Theme.of(context).colorScheme.primary,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  imageUrl,
                  errorListener: () => Center(
                    child: Icon(
                      Icons.error,
                      color: Theme.of(context).colorScheme.primary,
                      size: getFont(40),
                    ),
                  ),
                ),
              ),
              title: Text(
                title,
                style: TextStyle(
                  fontSize: getFont(22),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              trailing: SizedBox(
                width: getWidth(100),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                            AddAndEditProduct.routeName,
                            arguments: id);
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        try {
                          await Provider.of<ProductsController>(context,
                                  listen: false)
                              .deleteProduct(id);
                        } catch (error) {
                          scaffold.showSnackBar(
                               const SnackBar(content: Text('Deleting Failing!',textAlign: TextAlign.center,),));
                        }
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
