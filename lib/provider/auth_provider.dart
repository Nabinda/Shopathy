import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      if (urlSegment == "signUp") {
        final user = await addUserInfo(_token, _userId, email);
      } else {
        final user = await fetchUserInfo(_token, _userId);
      }
      _autoLogout();
      notifyListeners();
      //initialize shared preferences
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
        'email': email
      });
      prefs.setString("userData", userData);
    } catch (error) {
      throw (error);
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> logIn(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }

  Future<void> logout() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }

//clearing shared preferences
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  void _autoLogout() {
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    }
    final extractedData =
        json.decode(prefs.getString("userData")) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedData["expiryDate"]);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedData['token'];
    _expiryDate = expiryDate;
    _userId = extractedData['userId'];
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> addUserInfo(
      String authToken, String userId, String email) async {
    final url =
        "https://shopathy.firebaseio.com/users/$userId.json?auth=$authToken";
    try {
      final response = await http.put(url,
          body: json.encode({
            'userId': userId,
            'email': email,
          }));
      print(json.decode(response.body));
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchUserInfo(String authToken, String userId) async {
    final url =
        "https://shopathy.firebaseio.com/users/$userId.json?auth=$authToken";
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      print(extractedData.toString());
    } catch (error) {
      throw (error);
    }
  }
}
