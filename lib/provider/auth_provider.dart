import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shopathy/exception/http_exception.dart';
import 'dart:async';

class Auth with ChangeNotifier {
  String _token; //expires after one hour
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;
  bool get isAuth {
    return _token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _token != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyC8Ys8JBRdA-sGTpySUSt0XUR-0uYESLkA";
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email.trim(),
            'password': password,
            'returnSecureToken': true
          }));
      print(json.decode(response.body));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(Duration(
        seconds: int.parse(responseData['expiresIn']),
      ));
      _autoLogout();
      notifyListeners();
    } catch (error) {
      print(error.message);
      throw (error);
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> logIn(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }

  void logout() {
    _token = null;
    _expiryDate = null;
    _userId = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
  }

  void _autoLogout() {
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
