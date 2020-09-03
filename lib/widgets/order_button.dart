import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';

class OrderButton extends StatefulWidget {
  final cart;

  OrderButton(this.cart);

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              try{
                await Provider.of<Order>(context, listen: false).addOrder(
                  widget.cart.item.values.toList(),
                  widget.cart.totalAmount,
                );
              }finally{
                setState(() {
                  _isLoading = false;
                });
                widget.cart.clear();
              }
            },
      textColor: Theme.of(context).primaryColor,
    );
  }
}
