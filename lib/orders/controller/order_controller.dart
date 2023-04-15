import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../cart/model/cart_model.dart';
import '../model/order_model.dart';

class OrdersController with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  String? authToken;
  String? userId;

  OrdersController();

  OrdersController.update(this.authToken,this.userId, this._orders);

  bool init = false;

  Future<void> didChangeDependencies() async {
    init = true;
    notifyListeners();
    await fetchAndSetOrders();
    init = false;
    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://myshop-cd7ba-default-rtdb.firebaseio.com/Orders/$userId.json?auth=$authToken';
    final response = await http.get(Uri.parse(url));
    final Map<String, dynamic>? extractingData =
        json.decode(response.body) as Map<String, dynamic>?;
    if (extractingData == null) {
      return;
    }
    final List<OrderItem> loadedOrders = [];
    extractingData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
            dateTime: DateTime.parse(orderData['dateTime']),
            id: orderId,
            products: (orderData['products'] as List<dynamic>)
                .map((prod) => CartItem(
                    title: prod['title'],
                    id: prod['id'],
                    price: prod['price'],
                    quantity: prod['quantity']))
                .toList(),
            amount: orderData['amount']),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> products, double total) async {
    final url =
        'https://myshop-cd7ba-default-rtdb.firebaseio.com/Orders/$userId.json?auth=$authToken';
    final timeStamp = DateTime.now();
    final response = await http.post(Uri.parse(url),
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': products
              .map(
                (e) => {
                  'id': e.id,
                  'price': e.price,
                  'quantity': e.quantity,
                  'title': e.title,
                },
              )
              .toList()
        }));
    _orders.insert(
      0,
      OrderItem(
        dateTime: timeStamp,
        id: json.decode(response.body)['name'],
        products: products,
        amount: total,
      ),
    );
    notifyListeners();
  }
}
