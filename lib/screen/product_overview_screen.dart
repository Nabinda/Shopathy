//---------Initial Display Screen--------

import 'dart:wasm';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopathy/provider/cart_provider.dart';
import 'package:shopathy/provider/products_provider.dart';
import 'package:shopathy/screen/cart_screen.dart';
import 'package:shopathy/widgets/app_drawer.dart';
import 'package:shopathy/widgets/badge.dart';
import 'package:shopathy/widgets/custom_search_deligate.dart';
import 'package:shopathy/widgets/product_grid.dart';

enum FilterOptions { Favourites, All }

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = "/product_overview";
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool showFavourites = false;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context, listen: false)
          .fetchAndSetProduct()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopathy"),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (FilterOptions selectedOption) {
              setState(() {
                if (selectedOption == FilterOptions.Favourites) {
                  showFavourites = true;
                } else
                  showFavourites = false;
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Show Favourites"),
                value: FilterOptions.Favourites,
              ),
              PopupMenuItem(
                child: Text("Show All"),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (ctx, cart, child) {
              return Badge(
                child: child,
                value: cart.itemCount.toString(),
              );
            },
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(showFavourites),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showSearch(context: context, delegate: CustomSearchDelegate());
        },
        child: Icon(Icons.search),
      ),
    );
  }
}
