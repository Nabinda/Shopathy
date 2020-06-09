import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopathy/provider/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = "/product_detail_screen";

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(id);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title),
              background: Hero(
                tag: 'product$id',
                child: Container(
                  height: 300,
                  width: double.infinity,
                  child: Image.network(
                    loadedProduct.imageURL,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 10,
              ),
              Text(
                "\$ ${loadedProduct.price}",
                style: TextStyle(
                    color: Theme.of(context).accentColor, fontSize: 28),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  loadedProduct.description,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
              SizedBox(
                height: 700,
              ),
            ]),
          )
        ],
      ),
    );
  }
}
