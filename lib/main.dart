import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/orders_screen.dart';
import './screens/products_overview_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';
import './screens/cart_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/auth.dart';
import './providers/orders.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash-screen.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // use .value if you dont have a new class and u use an already existing methode
        providers: [
          ChangeNotifierProvider(
            builder: (context) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            builder: (context, auth, previousProduct) =>
                Products(auth.token,
                    previousProduct == null ? [] : previousProduct.items,
                    auth.userId),
          ),
          ChangeNotifierProxyProvider<Auth, Cart>(
              builder: (context, auth, previousCarts) {
                return Cart(
                    auth.token, previousCarts == null ? {} : previousCarts.item,
                    auth.userId);
              }),
          ChangeNotifierProxyProvider<Auth, Order>(
              builder: (context, auth, previousOrders) {
                return Order(auth.token,
                    previousOrders == null ? [] : previousOrders.orders,
                    auth.userId);
              })
        ],
        child: Consumer<Auth>(
          builder: (context, auth, child) {
            return MaterialApp(
              title: 'shopping App',
              home: auth.isAuth ? ProductsOverviewScreen() : FutureBuilder(
                future: auth.tryAutoLogin(),
                builder: (context, authResultSnapshot) {
                  return authResultSnapshot.connectionState == ConnectionState.waiting ? SplashScreen() : AuthScreen();
                },),
              theme: ThemeData(
                primarySwatch: Colors.orange,
                primaryColorBrightness: Brightness.light,
                accentColor: Colors.blueGrey,
                accentColorBrightness: Brightness.light,
              ),
              initialRoute: '/',
              routes: {
                ProductsOverviewScreen.routeName: (ctx) =>
                    ProductsOverviewScreen(),
                ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                CartScreen.routeName: (ctx) => CartScreen(),
                OrdersScreen.routeName: (ctx) => OrdersScreen(),
                UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
                EditProductScreen.routeName: (ctx) => EditProductScreen(),
              },
            );
          },
        ));
  }
}
