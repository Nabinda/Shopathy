import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopathy/provider/products_provider.dart';
import 'package:shopathy/screen/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageURL;
  final String id;

  UserProductItem(this.id, this.title, this.imageURL);

  @override
  Widget build(BuildContext context) {
    print("Title" + title);
    print(imageURL);
    print(id);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageURL),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.pushNamed(context, EditProductScreen.routeName,
                    arguments: id);
              },
            ),
            IconButton(
              color: Theme.of(context).errorColor,
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);
                } catch (error) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(error.message),
                  ));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
