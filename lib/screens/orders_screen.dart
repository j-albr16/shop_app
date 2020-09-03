import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' as it;
import '../widgets/order_item.dart' as ord;
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders '),
      ),
      body: FutureBuilder(
          future:
              Provider.of<it.Order>(context, listen: false).fetchAndSetOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.error != null) {
                return Center(
                  child: Text('Error!!'),
                );
              } else {
                return Consumer<it.Order>(
                  builder: (context, orderData, child) {
                    return ListView.builder(
                        itemCount: orderData.orders.length,
                        itemBuilder: (context, index) {
                          return ord.OrderItem(orderData.orders[index]);
                        });
                  },
                );
              }
            }
          }),
      drawer: AppDrawer(),
    );
  }
}
