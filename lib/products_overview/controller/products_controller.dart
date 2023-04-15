import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/product_model.dart';

class ProductsController with ChangeNotifier {
  List<Product> _items = [
    /* Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'White Shirt',
      description: 'A White shirt - it is pretty white!',
      price: 39.45,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Black Shirt',
      description: 'A black shirt - it is pretty black!',
      price: 19.30,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p4',
      title: 'blue Shirt',
      description: 'A blue shirt - it is pretty blue!',
      price: 24.12,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),*/
  ];
  String? authToken;
  String?  userId;
  ProductsController();
  ProductsController.update( this.authToken,this.userId ,this._items);

  List<Product> get items {
    return [..._items];
  }

  bool showFavoritesOnly = false;

  List<Product> get favoritesItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  Product findById(String id) {
    return items.firstWhere((prod) => prod.id == id);
  }

  void onSelected(FilterOptions value) {
    if (value == FilterOptions.favorite) {
      showFavoritesOnly = true;
    } else {
      showFavoritesOnly = false;
    }
    notifyListeners();
  }

  bool init = false;
  bool isLoading = false;

  Future<void> didChangeDependencies() async{
    init = true;
    if (init) {
      isLoading = true;
      notifyListeners();
     await fetchAndSetProducts();
      isLoading = false;
      notifyListeners();
    }
    init = false;
    notifyListeners();
  }

  Future<void> fetchAndSetProducts([bool filter=false]) async {
    String filterString=filter?'orderBy="creatorId"&equalTo="$userId"':'';
    String url =
        'https://myshop-cd7ba-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(Uri.parse(url));
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      if(extractData==null){
        return;
      }
      url= 'https://myshop-cd7ba-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoritesResponse=await http.get(Uri.parse(url));
      final favoritesData=json.decode(favoritesResponse.body);
      List<Product> loadedProducts = [];
      extractData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          imageUrl: prodData['imageUrl'],
          description: prodData['description'],
          price: prodData['price'],
          title: prodData['title'],
          id: prodId,
          isFavorite: favoritesData ==null?false:favoritesData[prodId]??false
        ));
      });
      _items = loadedProducts;
    } catch (error) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://myshop-cd7ba-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'creatorId':userId,
          }));
      Product newProduct = Product(
        imageUrl: product.imageUrl,
        description: product.description,
        price: product.price,
        title: product.title,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product product) async{
    final productIndex = _items.indexWhere((element) => element.id == id);
    if (productIndex >= 0) {
      final  url =
          'https://myshop-cd7ba-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(Uri.parse(url),body: json.encode({
        'title':product.title,
        'price':product.price,
        'description':product.description,
        'imageUrl':product.imageUrl,
      }));
      _items[productIndex] = product;
    }
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async{
    final  url =
        'https://myshop-cd7ba-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex=_items.indexWhere((element) => element.id == id);
    Product? existingProduct=_items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response=await http.delete(Uri.parse(url));
    if(response.statusCode>=400){
       _items.insert(existingProductIndex,existingProduct);
       notifyListeners();
       throw const HttpException('Could\'t Delete this Product!');
    }
    existingProduct=null;
  }
}
