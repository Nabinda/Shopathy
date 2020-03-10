import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopathy/models/product.dart';
import 'package:shopathy/provider/cart_provider.dart';
import 'package:shopathy/screen/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final selectedProduct = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0)),
      child: GridTile(
        child: GestureDetector(
          child: Hero(
            tag: 'product${selectedProduct.id}',
            child: Image.network(
              selectedProduct.imageURL,
              fit: BoxFit.cover,
            ),
          ),
          onTap: () {
            Navigator.pushNamed(context, ProductDetailScreen.routeName,
                arguments: selectedProduct.id);
          },
        ),
        footer: GridTileBar(
          //backgroundColor: Colors.orange.withOpacity(0.7),
          backgroundColor: Colors.black87,
          title: Text(
            selectedProduct.title,
            textAlign: TextAlign.center,
          ),
          leading: Consumer<Product>(
            builder: (ctx, builder, _) {
              return IconButton(
                icon: Icon(selectedProduct.isFavourite
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  selectedProduct.toggleIsFavourite();
                },
                color: Theme.of(context).accentColor,
              );
            },
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              cart.addItem(selectedProduct.id, selectedProduct.price,
                  selectedProduct.title);
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
