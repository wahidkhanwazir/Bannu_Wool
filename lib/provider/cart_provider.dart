import 'package:flutter/cupertino.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void addToCart(CartItem item) {
    _cartItems.add(item);
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _cartItems.remove(item);
    notifyListeners();
  }

  double calculateTotal() {
    return _cartItems.fold(0.0, (total, item) => total + item.price * item.quantity);
  }

  bool isItemInCart(String clothColor) {
    return _cartItems.any((item) => item.imageUrl == clothColor);
  }
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}


class CartItem {
  final String title;
  final double price;
  int quantity;
  late String imageUrl;

  CartItem({
  required this.title,
  required this.price,
  this.quantity = 1,
  required this.imageUrl,
  });
}