import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exceptions.dart';

class CartItem {
  final String id;
  final String title;
  final int quantitiy;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.quantitiy,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  final String authToken;
  final userId;


  Cart(this.authToken, this._items, this.userId);



  Map<String, CartItem> get item {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantitiy;
    });
    return total;
  }


  Future<void> fetchAndSetProducts() async {
    final url = 'https://shop-app-79b44.firebaseio.com/cart/$userId.json?auth=$authToken';
    try{
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final Map<String, CartItem> loadedData = {};
      if(extractedData == null){
        return;
      }
      extractedData.forEach((productId, prodData) {
        loadedData .putIfAbsent(
          productId, () {
          return CartItem(
            id: productId,
            price: prodData['price'],
            title: prodData['title'],
            quantitiy: prodData['quantity'],
          );
        }
        );
      });
      _items = loadedData;
      notifyListeners();
    } catch (error){
      print(error);
      throw error;
    }
  }

  Future<void> addItem(String productId, double price, String title) async{
    if (_items.containsKey(productId)) {
      final url = 'https://shop-app-79b44.firebaseio.com/cart/$userId/$productId.json?auth=$authToken';
      try{
        final response = await http.patch(url, body: json.encode({
          'title': _items[productId].title,
          'price': _items[productId].price,
          'quantity': _items[productId].quantitiy + 1,
        }));
         _items.update(
            productId,
                (existingCartItem) => CartItem(
              id: json.decode(response.body)['name'],
              title: existingCartItem.title,
              price: existingCartItem.price,
              quantitiy: existingCartItem.quantitiy + 1,
            ));
       // print(_items);
            } catch (error){
        print(error);
        throw error;
      }finally{
        notifyListeners();
        print(_items);
      }
    } else{
      final url = 'https://shop-app-79b44.firebaseio.com/cart/$userId/$productId.json?auth=$authToken';
      try{
        final response = await http.post(url,
        body: json.encode({
          'title': title,
          'price': price,
          'quantity':  1,
        }));
        _items.putIfAbsent(
            productId,
                () => CartItem(
              id: json.decode(response.body)['name'],
              title: title,
              price: price,
              quantitiy: 1,
            ));
        print(_items);
      }catch (error){
        print(error);
        throw error;
      }finally{
        notifyListeners();
      }
    }
  }

  Future<void> removeItem(String productId) async{
    final url = 'https://shop-app-79b44.firebaseio.com/cart/$userId/$productId.json?auth=$authToken';
    var loadedItem = _items[productId];
    _items.remove(productId);
    notifyListeners();

      final response = await http.delete(url);

    if (response.statusCode >= 400){
      _items.putIfAbsent(productId, () => loadedItem);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    loadedItem = null;
  }

  Future<void> clear() async{
    final url = 'https://shop-app-79b44.firebaseio.com/cart/$userId.json?auth=$authToken';
    final loadedItems = _items;
    _items = {};
    try{
      final response = await http.delete(url);
      if (response.statusCode >= 400 )
        _items = loadedItems;
      print('deleting didnt work');
    }catch (error){
      print(error);
      throw error;
      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> removeSingeItem(String productId) async{
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantitiy > 1) {
      final url = 'https://shop-app-79b44.firebaseio.com/cart/$userId/$productId.json?auth=$authToken';
      try{
        final response = await http.patch(url, body: json.encode({
          'title': _items[productId].title,
          'price': _items[productId].price,
          'quantity': _items[productId].quantitiy - 1,
        }));
        _items.update(
            productId,
                (existingCartItem) => CartItem(
              id: json.decode(response.body)['name'],
              title: existingCartItem.title,
              price: existingCartItem.price,
              quantitiy: existingCartItem.quantitiy - 1,
            ));
      } catch (error){
        print(error);
        throw error;
      }
    }else{
      removeItem(productId);
    }
    notifyListeners();
  }
}
