import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'product.dart';
import '../models/http_exceptions.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  final String authToken;
  final String userId;

  Products(this.authToken, this._items, this.userId);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavourite).toList();
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    print('Start Fetching Products');
    final filterString =
        filterByUser ? 'orderBy="userId"&equalTo="$userId"' : '';
    var url =
        'https://shop-app-79b44.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      print('Fetching Products');
      final extractedData =
          await json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if (extractedData == null) {
        print('couldnt load Data - No Data available');
        return;
      }
      if (extractedData ['error'] != null) {
        print('Ithrew');
        throw HttpException(extractedData ['error']['message']);
      }
      url =
          'https://shop-app-79b44.firebaseio.com/userFavourites/$userId.json?auth=$authToken';
      final favouriteResponse = await http.get(url);
      final favouriteData =
          json.decode(favouriteResponse.body);
      if (favouriteData['error'] != null) {
        print('Ithrew');
        throw HttpException(favouriteData['error']['message']);
      }
      extractedData.forEach(
        (prodId, prodData) {
//          print(prodId);
//          print(prodData['price']);
//          print(prodData['imageUrl']);
//          print(prodData['title']);
          print(favouriteData);
          loadedProducts.add(
              Product(
            id: prodId,
            title: (prodData['title']),
            description: prodData['description'],
            price: prodData['price'].toDouble(),
            imageUrl: prodData['imageUrl'],
            isFavourite:
                favouriteData == null ? false : favouriteData[prodId] ?? false,
          ));
//          print(prodId);
//          print(prodData['price']);
//          print(prodData['imageUrl']);
//          print(prodData['title']);
        },
      );
      _items = loadedProducts;
      notifyListeners();
      print('finished loading Products');
//      print(_items);

    }
    catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    // with async we automatically return the content as a future. -> so no return in front of http!!
    final url =
        'https://shop-app-79b44.firebaseio.com/products.json?auth=$authToken';
    try {
      // .json because its firebase
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'userId': userId,
        }),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        imageUrl: product.imageUrl,
        description: product.description,
        price: product.price,
        title: product.title,
      );
      _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

//JSON = JavaScript Object Notation

  Future<void> replaceProduct(Product newProduct) async {
    final prodIndex =
        _items.indexWhere((element) => element.id == newProduct.id);
    if (prodIndex >= 0) {
      final url =
          'https://shop-app-79b44.firebaseio.com/products/${newProduct.id}.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://shop-app-79b44.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }
}
