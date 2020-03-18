import 'package:flutter/material.dart';
import 'package:shopathy/screen/order_screen.dart';
import 'package:shopathy/screen/product_overview_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail: Text("nabindangol2@gmail.com"),
            accountName: Text("Nabin Dangol"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(""),
            ),
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Shop'),
            onTap: () {
              Navigator.pushReplacementNamed(context, "/");
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              Navigator.pushReplacementNamed(context, OrderScreen.routeName);
            },
          )
        ],
      ),
    );
  }
}
