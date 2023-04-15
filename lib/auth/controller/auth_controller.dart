import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myshop/products_overview/model/http_exception.dart';
import 'package:myshop/size_config.dart';
import 'dart:convert';
import 'dart:async';
import '../model/auth_model.dart';

class AuthController with ChangeNotifier {
  String? _token;
  String? _userId;
  DateTime? _expiryDate;
  Timer? _authTimer;

  final GlobalKey<FormState> formKey = GlobalKey();
  AuthMode authMode = AuthMode.login;
  final Map<String, String> authData = {
    'email': '',
    'password': '',
  };
  var isLoading = false;
  final passwordController = TextEditingController();
  final emailController=TextEditingController();
  final confirmPasswordController=TextEditingController();

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  bool get isAuth {
    print(_token);
    print(_expiryDate.toString());
    print(_userId);
    print(token);
    return token != null;
  }

  String? get userId {
    return _userId;
  }

  Future<void> submit({required BuildContext context}) async {
    final isValid = formKey.currentState?.validate();
    if (!isValid!) {
      // Invalid!
      return;
    }
    formKey.currentState?.save();

    isLoading = true;
    notifyListeners();
    try {
      if (authMode == AuthMode.login) {
        await logIn(email:/* authData['email']!*/emailController.text.trim(), password: /*authData['password']!*/passwordController.text.trim());
        // Log user in
      } else {
        await signUp(
            /*email: authData['email']!*/email:emailController.text.trim(), password:/* authData['password']!*/passwordController.text.trim());
        // Sign user up
      }
    } on HttpException catch (error) {
      String errorMessage = 'Authenticate failed';
      if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could\'t find a user with that email';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'This is a wrong password';
      } else if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email is already used';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This is a weak password';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is a wrong email';
      }
      _showDialog(message: errorMessage, context: context);
    } catch (error) {
      const String errorMessage =
          'Could\'t authenticate you now please try again later';
      _showDialog(message: errorMessage, context: context);
    }
    isLoading = false;
    notifyListeners();
  }

  void switchAuthMode() {
    if (authMode == AuthMode.login) {
      authMode = AuthMode.signup;
      notifyListeners();

    } else {
      authMode = AuthMode.login;
      notifyListeners();

    }
  }

  void _showDialog({required String message, required BuildContext context}) {
    showDialog(
      context: context,
      builder: (ctx) =>
          AlertDialog(
            backgroundColor: Theme
                .of(context)
                .colorScheme
                .primary,
            title: Text(
              'An Error Occurred',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: getFont(25),
              ),
            ),
            content: Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: getFont(22),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                style: const ButtonStyle(
                    overlayColor: MaterialStatePropertyAll(
                      Colors.transparent,
                    )),
                child: Text('Okay',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: getFont(20),
                      fontWeight: FontWeight.bold,
                    )),
              )
            ],
          ),
    );
  }

  Future<void> authenticate({required String email,
    required String password,
    required String urlSegment}) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyClbShPafREWm6FwVJAPiHYlBnJAJ0XV78';
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      //print(json.decode(response.body));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(message: responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          )));
      _autoLogOut();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate?.toIso8601String(),
      });
      prefs.setString('userData', userData);
      print(prefs.getString('userData'));
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    await authenticate(email: email, password: password, urlSegment: 'signUp');
  }

  Future<void> logIn({required String email, required String password}) async {
    return authenticate(
        email: email, password: password, urlSegment: 'signInWithPassword');
  }

  String? validatorEmail(String? v) {
    if (v!.isEmpty || !v.contains('@')) {
      return 'Invalid email!';
    }
    return null;
  }
  bool? securePassword =true;
  bool? secureConfirmPassword=true;
  void onPressedSuffixPassword(){
    securePassword=!securePassword!;
    notifyListeners();
  }
  void onPressedSuffixConfirmPassword(){
    secureConfirmPassword=!secureConfirmPassword!;
    notifyListeners();
  }
  String? validatorPassword(String? v) {
    if (v!.isEmpty || v.length < 5) {
      return 'Password is too short!';
    }
    return null;
  }

  String? validatorConfirmPassword(String? v) {
    if (v != passwordController.text) {
      return 'Passwords do not match!';
    }
    return null;
  }

  void onSavedEmail(String? v) {
    emailController.text=v!;
 //   authData['email'] = v!;
    emailController.clear();
    notifyListeners();
  }

  void onSavedPassword(String? v) {
    passwordController.text=v!;
   // authData['password'] = v!;
    passwordController.clear();
    confirmPasswordController.clear();
    notifyListeners();
  }

  Future<bool> tryAutoLogIn() async{
    final prefs= await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')){
      return false;
    }
    final extractUserData=prefs.getString(json.decode('userData')) as Map<String,dynamic>;
    final expiryDate=DateTime.parse(extractUserData['expiryDate']);
    print(extractUserData.toString());
    print(expiryDate.toString());
    if(expiryDate.isBefore(DateTime.now())){
      return false;
    }else{
      _token=extractUserData['token'];
      _userId=extractUserData['userId'];
      _expiryDate=expiryDate;
      notifyListeners();
      _autoLogOut();
      return true;
    }
  }
  Future<void> logOut() async{
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer?.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs= await SharedPreferences.getInstance();
   // prefs.remove('userData');
    prefs.clear();
  }

  void _autoLogOut() {
    if (_authTimer != null) {
      _authTimer?.cancel();
    }
    int? time = _expiryDate
        ?.difference(DateTime.now())
        .inSeconds;
    _authTimer = Timer(Duration(seconds: time!), logOut);
    notifyListeners();
  }
}
