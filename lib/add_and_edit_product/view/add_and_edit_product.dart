import 'package:flutter/material.dart';
import 'package:myshop/add_and_edit_product/controller/add_and_edit_controller.dart';
import 'package:myshop/add_and_edit_product/view/widget/text_field_item.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../size_config.dart';

class AddAndEditProduct extends StatelessWidget {
  static const String routeName = 'edit_and_add_product_screen';

  const AddAndEditProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddAndEditController()..didChangeDependencies(context),
      child: Consumer<AddAndEditController>(
        builder: (ctx, controller, _) => Scaffold(
          appBar: AppBar(
            title: Text(
              'Edit Product',
              style: TextStyle(
                fontSize: getFont(30),
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () => controller.saveForm(ctx),
                  icon: const Icon(
                    Icons.save,
                  ))
            ],
          ),
          body: controller.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Form(
                  key: controller.formKey,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    children: [
                      TextFieldItem(
                        controller: controller.titleController,
                        hint: 'Title',
                        textInputAction: TextInputAction.next,
                        validator: (v) => controller.validatorTitle(v),
                        onSaved: (v) => controller.onSavedTitle(v),
                      ),
                      SizedBox(
                        height: getHeight(5),
                      ),
                      TextFieldItem(
                        hint: 'Price',
                        controller: controller.priceController,
                        textInputAction: TextInputAction.next,
                        textInputType: TextInputType.number,
                        validator: (v) => controller.validatorPrice(v),
                        onSaved: (v) => controller.onSavedPrice(v),
                      ),
                      SizedBox(
                        height: getHeight(5),
                      ),
                      TextFieldItem(
                        controller: controller.descriptionController,
                        hint: 'Description',
                        maxlines: 3,
                        validator: (v) => controller.validatorDescription(v),
                        onSaved: (v) => controller.onSavedDescription(v),
                      ),
                      SizedBox(
                        height: getHeight(5),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              width: getWidth(150),
                              height: getHeight(150),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(.3),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  width: 2,
                                ),
                              ),
                              margin: const EdgeInsets.only(top: 5, right: 10),
                              child: controller.imageUrlController.text
                                      .trim()
                                      .isEmpty
                                  ? Center(
                                      child: Text(
                                        'Enter image url!',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: getFont(23),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  : CachedNetworkImage(
                                      imageUrl:
                                          controller.imageUrlController.text,
                                      errorWidget: (context, url, error) =>
                                          Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.error,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            size: getFont(50),
                                          ),
                                          Text(
                                            'Enter valid url!!',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              fontSize: getFont(23),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                      fit: BoxFit.cover,
                                    )),
                          Expanded(
                              child: TextFieldItem(
                            maxlines: 2,
                            hint: 'ImageUrl',
                            textInputAction: TextInputAction.done,
                            textInputType: TextInputType.url,
                            controller: controller.imageUrlController,
                            onChange: (v) => controller.onChanged(v),
                            validator: (v) => controller.validatorImageUrl(v),
                            onSaved: (v) => controller.onSavedImageUrl(v),
                          ))
                        ],
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
