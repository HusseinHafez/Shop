import 'package:flutter/material.dart';
import 'package:myshop/add_and_edit_product/view/add_and_edit_product.dart';
import 'package:myshop/products_overview/controller/products_controller.dart';
import 'package:myshop/products_overview/view/widgets/app_drawer.dart';
import 'package:myshop/size_config.dart';
import 'package:myshop/user_products/view/widgets/user_products_item.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const String routeName = '/user_products_screen';

  const UserProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsController>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Products',
          style: TextStyle(fontSize: getFont(30)),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddAndEditProduct.routeName);

              },
              icon: const Icon(
                Icons.add,
              ))
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: productsData.fetchAndSetProducts(true),
        builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }else{
            return Consumer<ProductsController>(
              builder: (context, prodData, child) => RefreshIndicator(
                onRefresh: ()=>prodData.fetchAndSetProducts(true),
                child: ListView.builder(
                  itemBuilder: (_, i) => UserProductItem(
                    id: prodData.items[i].id!,
                    title: prodData.items[i].title,
                    imageUrl: prodData.items[i].imageUrl,
                  ),
                  itemCount: prodData.items.length,
                ),
              ),
            );
          }
        },

      ),

    );
  }
}
