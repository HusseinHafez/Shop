import 'package:flutter/material.dart';
import 'package:myshop/add_and_edit_product/view/widget/text_field_item.dart';
import 'package:myshop/auth/controller/auth_controller.dart';
import 'package:myshop/size_config.dart';
import 'package:provider/provider.dart';

import '../../model/auth_model.dart';

class AuthCard extends StatelessWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Consumer<AuthController>(
      builder: (context, AuthController controller, child) => Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        elevation: 8.0,
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(25)),
          height: controller.authMode == AuthMode.signup
              ? getHeight(380)
              : getHeight(300),
          constraints: BoxConstraints(
              minHeight: controller.authMode == AuthMode.signup
                  ? getHeight(380)
                  : getHeight(300)),
          width: getWidth(deviceSize.width * 0.75),
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFieldItem(
                    controller: controller.emailController,
                    hint: 'E-Mail',
                    textInputType: TextInputType.emailAddress,
                    validator: (value) => controller.validatorEmail(value),
                    onSaved: (value) => controller.onSavedEmail(value),
                  ),
                  TextFieldItem(
                    hint: 'Password',
                    suffixIcon: GestureDetector(
                        onTap:controller.onPressedSuffixPassword,
                        child: const Icon(Icons.remove_red_eye,color: Colors.white,)),
                    scure: controller.securePassword!,
                    controller: controller.passwordController,
                    validator: (value) => controller.validatorPassword(value),
                    onSaved: (value) => controller.onSavedPassword(value),
                  ),
                  if (controller.authMode == AuthMode.signup)
                    TextFieldItem(
                      controller: controller.confirmPasswordController,
                      suffixIcon: GestureDetector(
                          onTap:controller.onPressedSuffixConfirmPassword,
                          child: const Icon(Icons.remove_red_eye,color: Colors.white,)),
                      enabled: controller.authMode == AuthMode.signup,
                      hint: 'Confirm Password',
                      scure: controller.secureConfirmPassword!,
                      validator: controller.authMode == AuthMode.signup
                          ? (value) =>
                              controller.validatorConfirmPassword(value)
                          : null,
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (controller.isLoading)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton(
                      onPressed: () => controller.submit(context: context),
                      style: ButtonStyle(
                          overlayColor: const MaterialStatePropertyAll(
                              Colors.transparent),
                          textStyle: const MaterialStatePropertyAll(TextStyle(
                            color: Colors.white,
                          )),
                          padding: const MaterialStatePropertyAll(
                            EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 8.0),
                          ),
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(.5),
                          )),
                      child: Text(
                        controller.authMode == AuthMode.login
                            ? 'Log In'
                            : 'Sign Up',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  TextButton(
                    style: ButtonStyle(
                        overlayColor:
                            const MaterialStatePropertyAll(Colors.transparent),
                        textStyle: MaterialStatePropertyAll(TextStyle(
                            color: Theme.of(context).colorScheme.primary)),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: const MaterialStatePropertyAll(
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                        )),
                    onPressed: controller.switchAuthMode,
                    child: Text(
                      '${controller.authMode == AuthMode.login ? 'SIGNUP' : 'LOGIN'} INSTEAD',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
