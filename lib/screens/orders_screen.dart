import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' as it;
import '../widgets/order_item.dart' as ord;
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<it.Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders '),
      ),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (context, index) {
          return ord.OrderItem(orderData.orders[index]);
      } ,),
      drawer: AppDrawer(),
    );
  }
}
