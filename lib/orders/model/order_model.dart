import '../../cart/model/cart_model.dart';

class OrderItem {
  final String id;
  final double amount;
  final DateTime dateTime;
  final List<CartItem> products;

  OrderItem({
    required this.dateTime,
    required this.id,
    required this.products,
    required this.amount,
  });
}
