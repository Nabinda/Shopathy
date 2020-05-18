import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopathy/models/product.dart';
import 'package:shopathy/provider/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit_product_screen";
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageURLFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  bool _isInit = true;

  var _editedProduct = Product(
    id: null,
    title: "",
    price: 0,
    description: "",
    imageURL: "",
  );
  var initValues = {
    "title": "",
    "price": "",
    "description": "",
    "imageURL": "",
  };
  @override
  void initState() {
    super.initState();
    _imageUrlController.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final String productId = ModalRoute.of(context).settings.arguments;
      if (productId != null) {
        _editedProduct = Provider.of<Products>(context).findById(productId);
        initValues = {
          "title": _editedProduct.title,
          "price": _editedProduct.price.toString(),
          "description": _editedProduct.description,
          "imageURL": _editedProduct.imageURL,
        };
        _imageUrlController.text = _editedProduct.imageURL;
      }
    }
    _isInit = false;
  }

  //========to update image on container
  void _updateImageUrl() {
    if (!_imageURLFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageURLFocusNode.dispose();
    _imageUrlController.dispose();
  }

  //save form and validate
  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              _saveForm();
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: initValues['title'],
                decoration: InputDecoration(labelText: "Title"),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return 'The Title must not be Empty';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    title: value.trim(),
                    description: _editedProduct.description,
                    id: _editedProduct.id,
                    imageURL: _editedProduct.imageURL,
                    price: _editedProduct.price,
                  );
                },
              ),
              TextFormField(
                initialValue: initValues['price'],
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: "Price"),
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'The Price must not be Empty';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Price must be in number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Price should not be less then 0';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    id: _editedProduct.id,
                    imageURL: _editedProduct.imageURL,
                    price: double.parse(value),
                  );
                },
              ),
              TextFormField(
                initialValue: initValues['description'],
                maxLines: 4,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(labelText: "Description"),
                focusNode: _descriptionFocusNode,
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return 'Description must not be Empty';
                  }
                  if (value.length < 10) {
                    return 'Description should not be less then 10 characters';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    description: value.trim(),
                    id: _editedProduct.id,
                    imageURL: _editedProduct.imageURL,
                    price: _editedProduct.price,
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.only(top: 15, right: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: _imageUrlController.text.isEmpty
                        ? FittedBox(
                            child: Text("Enter a image URL"),
                          )
                        : Image.network(
                            _imageUrlController.text,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Expanded(
                      child: TextFormField(
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    focusNode: _imageURLFocusNode,
                    decoration: InputDecoration(labelText: "Image URL"),
                    controller: _imageUrlController,
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'Link must not be Empty';
                      }
                      if (!value.startsWith("http") &&
                          !value.startsWith("https")) {
                        return 'URL is not valid';
                      }
                      if (!value.endsWith("png") &&
                          (!value.endsWith("jpeg") &&
                              (!value.endsWith("jpg")))) {
                        return 'Invalid image format';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        id: _editedProduct.id,
                        imageURL: value.trim(),
                        price: _editedProduct.price,
                      );
                    },
                  )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
