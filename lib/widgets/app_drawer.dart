import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopathy/helper/custom_route.dart';
import 'package:shopathy/provider/auth_provider.dart';
import 'package:shopathy/screen/auth_screen.dart';
import 'package:shopathy/screen/order_screen.dart';
import 'package:shopathy/screen/user_product_screen.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String email = "";
  bool isInit = true;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      getUserData();
    }
    isInit = false;
  }

  void getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final extractedData =
        json.decode(prefs.getString("userData")) as Map<String, Object>;
    setState(() {
      email = extractedData['email'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail: Text(email),
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
              //Navigator.pushReplacementNamed(context, OrderScreen.routeName);
              Navigator.of(context).pushReplacement(
                  CustomRoute(builder: (ctx) => OrderScreen()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('ManageProducts'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  CustomRoute(builder: (ctx) => UserProductScreen()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () async {
              Navigator.of(context).pop();
              await Provider.of<Auth>(context, listen: false).logout();

              Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
