import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopathy/provider/products_provider.dart';
import 'package:shopathy/screen/edit_product_screen.dart';
import 'package:shopathy/widgets/app_drawer.dart';
import 'package:shopathy/widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = "/user_product_screen";
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, EditProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () => _refreshProducts(context),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Consumer<Products>(
                      builder: (ctx, products, _) {
                        return ListView.builder(
                          itemBuilder: (ctx, index) => UserProductItem(
                            products.items[index].id,
                            products.items[index].title,
                            products.items[index].imageURL,
                          ),
                          itemCount: products.items.length,
                        );
                      },
                    ),
                  ),
                );
        },
      ),
    );
  }
}
