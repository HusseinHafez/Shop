import 'package:flutter/cupertino.dart';
import 'package:myshop/products_overview/controller/products_controller.dart';
import 'package:provider/provider.dart';

class UserProductsController with ChangeNotifier{
  Future<void> onRefresh (BuildContext context) async{
    await Provider.of<ProductsController>(context).fetchAndSetProducts();
    notifyListeners();
  }
}