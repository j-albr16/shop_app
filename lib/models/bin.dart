//import 'dart:convert';
//
//import 'package:flutter/material.dart';
//import 'package:uuid/uuid.dart';
//import 'package:http/http.dart' as http;
//
//import 'product.dart';
//
//class Products with ChangeNotifier {
//  List<Product> _items = [
//    Product(
//      id: 'p1',
//      title: 'Red Shirt',
//      description: 'A red shirt - it is pretty red!',
//      price: 29.99,
//      imageUrl:
//      'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
//    ),
//    Product(
//      id: 'p2',
//      title: 'Trousers',
//      description: 'A nice pair of trousers.',
//      price: 59.99,
//      imageUrl:
//      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
//    ),
//    Product(
//      id: 'p3',
//      title: 'Yellow Scarf',
//      description: 'Warm and cozy - exactly what you need for the winter.',
//      price: 19.99,
//      imageUrl:
//      'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
//    ),
//    Product(
//      id: 'p4',
//      title: 'A Pan',
//      description: 'Prepare any meal you want.',
//      price: 49.99,
//      imageUrl:
//      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
//    ),
//  ];
//  var _showFavouritesOnly = false;
//
//  List<Product> get items {
////    if (_showFavouritesOnly){
////      return _items.where((element) => element.isFavourite).toList();
////    } else{
//    return [..._items];
////    }
//  }
//
//  List<Product> get favoriteItems {
//    return _items.where((element) => element.isFavourite).toList();
//  }
//
//  Future<void> addProduct(Product product) async {// with async we automatically return the content as a future. -> so no return in front of http!!
//    const url =
//        'https://shop-app-79b44.firebaseio.com/products.json'; // .json because its firebase
//    await http
//        .post(url,
//        body: json.encode({
//          'title': product.title,
//          'description': product.description,
//          'imageUrl': product.imageUrl,
//          'isFavorite': product.isFavourite,
//        }))
//        .then((response) {
//      print(json.decode(response.body));
//      final newProduct = Product(
//        id: json.decode(response.body)['name'],
//        imageUrl: product.imageUrl,
//        description: product.description,
//        price: product.price,
//        title: product.title,
//      );
//      _items.insert(0, newProduct);
//      notifyListeners();
//    }).catchError((error){
//      print(error);
//      throw error;
//    });
//    //JSON = JavaScript Object Notation
//  }
//
//  void replaceProduct(Product product) {
//    final newProduct = Product(
//      id: product.id,
//      imageUrl: product.imageUrl,
//      description: product.description,
//      price: product.price,
//      title: product.title,
//    );
//    final prodIndex =
//    _items.indexWhere((element) => element.id == newProduct.id);
//    _items[prodIndex] = newProduct;
//    notifyListeners();
//  }
//
//  Product findById(String id) {
//    return _items.firstWhere((prod) => prod.id == id);
//  }
//
//  void deleteProduct(String id) {
//    _items.removeWhere((element) => element.id == id);
//    notifyListeners();
//  }
//}




//void _saveForm() {
//  final isValid = _form.currentState.validate();
//  if (!isValid) {
//    return;
//  }
//  _form.currentState.save();
//  setState(() {
//    _isLoading = true;
//  });
//  if (_editedProduct.id == null) {
//    Provider.of<Products>(
//      context,
//      listen: false,
//    ).addProduct(_editedProduct).catchError((error){
//      return showDialog(
//        context: context,
//        builder: (ctx) => AlertDialog(
//          title: Text('An error occurt'),
//          content: Text('Something went wrong!'),
//          actions: <Widget>[
//            FlatButton(onPressed: (){
//              Navigator.of(context).pop();
//            }, child: Text('Okay!'))
//          ],
//        ) ,
//      );
//    }).then((value) {
//      Navigator.of(context).pop();
//      setState(() {
//        _isLoading = false;
//      });
//    });
//  } else {
//    Provider.of<Products>(
//      context,
//      listen: false,
//    ).replaceProduct(_editedProduct);
//    setState(() {
//      _isLoading = false;
//    });
//  }
//}
