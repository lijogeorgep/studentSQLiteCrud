import 'dart:async';
import 'package:flutter_sqlite/models/user.dart';


import 'login_ctr.dart';
class LoginRequest {
  LoginCtr con = new LoginCtr();
  Future<User> getLogin(String username, String password) {
    var result = con.getLogin(username,password);
    return result;
  }
}