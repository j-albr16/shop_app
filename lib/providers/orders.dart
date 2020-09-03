import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.dateTime,
    @required this.products,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Order(this.authToken, this._orders, this.userId);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = 'https://shop-app-79b44.firebaseio.com/orders/$userId.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final List<OrderItem> loadedOrders = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
        extractedData.forEach((orderId, orderData) {
          loadedOrders.add(OrderItem(
            id: orderId,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
            products: (orderData['products'] as List<dynamic>).map((item) {
              return CartItem(
                id: item['id'],
                title: item['title'],
                price: item['price'],
                quantitiy: item['quantitiy'],
              );
            }).toList(),
          ));
        });
        _orders = loadedOrders;
        notifyListeners();
      } catch (error) {
      print(error);
      throw error;
    }
  }




  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = 'https://shop-app-79b44.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timestamp = DateTime.now().toIso8601String();
    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': timestamp,
            'products': cartProducts.map((e) {
              return {
                'id': e.id,
                'title': e.title,
                'price': e.price,
                'quantity': e.quantitiy,
              };
            }).toList(),
          }));
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body),
          amount: total,
          dateTime: DateTime.now(),
          products: cartProducts,
        ),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}

