import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopathy/provider/cart_provider.dart' show Cart;
import 'package:shopathy/provider/order_provider.dart';
import 'package:shopathy/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart_screen";
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Text(
                      '\$ ${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  OrderButton(cart)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (ctx, index) => CartItem(
              cart.items.values.toList()[index].title,
              cart.items.values.toList()[index].id,
              cart.items.values.toList()[index].price,
              cart.items.keys.toList()[index],
              cart.items.values.toList()[index].quantity,
            ),
            itemCount: cart.itemCount,
          ))
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  final cart;
  OrderButton(this.cart);
  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final order = Provider.of<Orders>(context, listen: false);
    return FlatButton(
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Text(
              "Order Now",
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Nunito',
                  color: Theme.of(context).accentColor),
            ),
      onPressed: widget.cart.totalAmount <= 0
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await order.addOrder(
                  widget.cart.items.values.toList(), widget.cart.totalAmount);
              widget.cart.clearCart();
              setState(() {
                _isLoading = false;
              });
            },
    );
  }
}
