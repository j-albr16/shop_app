import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier{
  final String id;
  final double price;
  final String title;
  final String description;
  final String imageUrl;
  bool isFavourite;

  Product({
    @required this.id,
  @required this.price,
  @required this.title,
  @required this.description,
  @required this.imageUrl,
  this.isFavourite = false,
  });

  Future<void> toggleFavouriteStatus(String token, String userId) async{
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();//euqivalent to set state in statefull widgets
    final url = 'https://shop-app-79b44.firebaseio.com/userFavourites/$userId/$id.json?auth=$token';
    try{
      final response = await http.put(url,body: json.encode(
         isFavourite  ,
      ),);
      if (response.statusCode >= 400){
        isFavourite = oldStatus;
        notifyListeners();
      }
    }catch (error){
      print(error);
      isFavourite = oldStatus;
      notifyListeners();
      throw error;
    }
  }
}
