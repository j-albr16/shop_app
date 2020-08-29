import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/cart_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // use .value if you dont have a new class and u use an already existing methode
      providers: [
        ChangeNotifierProvider(
          create: (context) => Products(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (context) => Order(),
        )
      ],
      child: MaterialApp(
        title: 'shopping App',
        home: ProductsOverviewScreen(),
        theme: ThemeData(
          primarySwatch: Colors.orange,
          primaryColorBrightness: Brightness.light,
          accentColor: Colors.blueGrey,
          accentColorBrightness: Brightness.light,
        ),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
        },
      ),
    );
  }
}
