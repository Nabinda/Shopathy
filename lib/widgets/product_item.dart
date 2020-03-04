import 'package:flutter/material.dart';
import 'package:shopathy/screen/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  String imageUrl;
  String title;
  String id;
  ProductItem({this.id, this.imageUrl, this.title});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0)),
      child: GridTile(
        child: GestureDetector(
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.pushNamed(context, ProductDetailScreen.routeName);
          },
        ),
        footer: GridTileBar(
          //backgroundColor: Colors.orange.withOpacity(0.7),
          backgroundColor: Colors.black87,
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
          leading: IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {},
            color: Theme.of(context).accentColor,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {},
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
