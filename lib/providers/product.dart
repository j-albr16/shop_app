import 'package:flutter/material.dart';

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
  this.isFavourite = false, isFavorite,
  });

  void toggleFavouriteStatus(){
    isFavourite = !isFavourite;
        notifyListeners();//euqivalent to set state in statefull widgets
  }
}
