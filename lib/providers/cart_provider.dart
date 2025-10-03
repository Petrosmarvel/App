import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];
  double _taxRate = 0.16;

  List<CartItem> get items => _items;
  double get taxRate => _taxRate;

  double get subtotal {
    return _items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  double get taxAmount {
    return subtotal * _taxRate;
  }

  double get total {
    return subtotal + taxAmount;
  }

  int get totalItems {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  void addToCart(Product product, {List<String> modifications = const [], String? notes}) {
    final existingIndex = _items.indexWhere((item) =>
    item.product.id == product.id &&
        listEquals(item.modifications, modifications) &&
        item.notes == notes
    );

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += 1;
    } else {
      _items.add(CartItem(
        product: product,
        quantity: 1,
        modifications: modifications,
        notes: notes,
      ));
    }
    notifyListeners();
  }

  void updateQuantity(int index, int newQuantity) {
    if (newQuantity > 0) {
      _items[index].quantity = newQuantity;
    } else {
      _items.removeAt(index);
    }
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  Future<Map<String, dynamic>> checkout() async {
    try {
      final orderResponse = await ApiService.createOrder(_items);
      final invoiceResponse = await ApiService.submitInvoice(orderResponse['id']);
      clearCart();

      return {
        'success': true,
        'order': orderResponse,
        'invoice': invoiceResponse,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }
}