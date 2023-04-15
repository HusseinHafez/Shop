import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../orders/controller/order_controller.dart';
import '../model/cart_model.dart';

class CartController with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemsCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItemToCart(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
            (existingCartItem) =>
            CartItem(
              title: existingCartItem.title,
              id: existingCartItem.id,
              price: existingCartItem.price,
              quantity: existingCartItem.quantity + 1,
            ),
      );
    } else {
      _items.putIfAbsent(
        productId,
            () =>
            CartItem(
              title: title,
              id: productId,
              price: price,
              quantity: 1,
            ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(productId, (existingCartItem) =>
          CartItem(title: existingCartItem.title,
              id: existingCartItem.id,
              price: existingCartItem.price,
              quantity: existingCartItem.quantity-1,));
    }else{
      _items.remove(productId);
    }
    notifyListeners();
  }
  bool isLoading=false;
  void setIsLoadingTrue(){
    isLoading=true;
    notifyListeners();
  }
  void setIsLoadingFalse(){
    isLoading=false;
    notifyListeners();
  }
  Future<void> onTap(BuildContext context) async{
    isLoading=true;
    await Provider.of<OrdersController>(context, listen: false)
        .addOrder(
      items.values.toList(),
      totalAmount,
    );
    isLoading=false;
    notifyListeners();
    clear();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
