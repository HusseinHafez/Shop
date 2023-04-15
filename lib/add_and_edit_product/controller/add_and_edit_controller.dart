
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../products_overview/controller/products_controller.dart';
import '../../products_overview/model/product_model.dart';
import '../../size_config.dart';

class AddAndEditController with ChangeNotifier {
  final imageUrlController = TextEditingController();
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Product product = Product(
    imageUrl: '',
    description: '',
    price: 0,
    title: '',
    id: null,
  );
  bool _init = true;

  /* Map<String, String> _initValues = {
    'title': '',
    'id': '',
    'imageUrl': '',
    'description': '',
    'price': ''
  };*/

  void didChangeDependencies(BuildContext context) {
    if (_init) {
      final productId = ModalRoute.of(context)?.settings.arguments as String?;
      if (productId != null) {
        product = Provider.of<ProductsController>(context, listen: false)
            .findById(productId);

        /* _initValues = {
          'title': product.title,
          'id': product.id!,
          'description': product.description,
          'price': product.price.toString(),
        };*/
        titleController.text = product.title;
        priceController.text = product.price.toString();
        descriptionController.text = product.description;
        imageUrlController.text = product.imageUrl;
        notifyListeners();
      }
    }

    _init = false;
  }

  String? validatorPrice(String? value) {
    if (value!.isEmpty) {
      return 'Enter Price !';

      // ignore: unnecessary_null_comparison
    } else if (double.parse(value.toString()) == null) {
      return 'Please enter a valid number';
    } else {
      if (double.parse(value.toString()) <= 0) {
        return 'Please Enter Positive Price';
      }
    }
    return null;
  }

  String? validatorDescription(String? value) {
    if (value!.isEmpty) {
      return 'Enter Description!';
    } else if (value.length < 9) {
      return 'Description should be more than 9 letters';
    }
    return null;
  }

  String? validatorImageUrl(String? value) {
    if (value!.isEmpty) {
      return 'Enter Image Url!';
    } else if (!value.startsWith('http') && !value.startsWith('https')) {
      return 'This is a wrong url';
    } else if (!value.endsWith('.jpg') &&
        !value.endsWith('.jpeg') &&
        !value.endsWith('.png')) {
      return 'This is not a image!';
    }
    return null;
  }

  String? validatorTitle(String? value) {
    if (value!.isEmpty) {
      return 'this is wrong';
    }
    return null;
  }

  void onSavedPrice(String? value) {
    product = Product(
        imageUrl: product.imageUrl,
        description: product.description,
        price: double.parse(value.toString()),
        title: product.title,
        isFavorite: product.isFavorite,
        id: product.id);
    notifyListeners();
  }

  void onSavedDescription(String? value) {
    product = Product(
        imageUrl: product.imageUrl,
        description: value.toString(),
        price: product.price,
        title: product.title,
        isFavorite: product.isFavorite,
        id: product.id);
    notifyListeners();
  }

  void onSavedImageUrl(String? value) {
    product = Product(
        imageUrl: value.toString(),
        description: product.description,
        price: product.price,
        title: product.title,
        isFavorite: product.isFavorite,
        id: product.id);
    notifyListeners();
  }

  void onSavedTitle(String? value) {
    product = Product(
      imageUrl: product.imageUrl,
      description: product.description,
      price: product.price,
      title: value.toString(),
      id: product.id,
      isFavorite: product.isFavorite,
    );
    notifyListeners();
  }

  void onChanged(String value) {
    imageUrlController.text = value;
    notifyListeners();
  }

  bool isLoading = false;

  Future<void> saveForm(BuildContext context) async {
    final navi= Navigator.of(context);
    final isValid = formKey.currentState?.validate();
    if (!isValid!) {
      return;
    }
    formKey.currentState?.save();
    isLoading = true;
    if (product.id != null) {
     await Provider.of<ProductsController>(context, listen: false)
          .updateProduct(product.id!, product);
    //  isLoading = false;
     navi.pop();
    } else {
      try {
        await Provider.of<ProductsController>(context, listen: false)
            .addProduct(product);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: Text(
              'An Error Occurred!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: getFont(25),
              ),
            ),
            content: Text(
              'Something is wrong.',
              style: TextStyle(
                fontSize: getFont(22),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.of(ctx).pop();
                },
                child: Text(
                  'Okay',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: getFont(20),
                  ),
                ),
              )
            ],
          ),
        );
      } finally {
        isLoading = false;
        notifyListeners();
        Navigator.of(context).pop();
      }
    /*  Navigator.of(context).pop();
      notifyListeners();*/
     /* isLoading = false;
      notifyListeners();
      Navigator.of(context).pop();*/
    }

    notifyListeners();
  }
}
