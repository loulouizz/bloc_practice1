import 'package:bloc_practice_1/models.dart';
import 'package:flutter/material.dart' show immutable;

@immutable
abstract class LoginApiProtocol {
  const LoginApiProtocol();

  Future<LoginHandle?> login({
    required String email,
    required String password,
  });
}

@immutable
class LoginApi implements LoginApiProtocol {
  // create singleton
  // const LoginApi._sharedInstance();
  // static const LoginApi _shared =
  //     LoginApi._sharedInstance();
  // factory LoginApi.instance() => _shared;

  @override
  Future<LoginHandle?> login({
    required String email,
    required String password,
  }) =>
      Future.delayed(
        const Duration(seconds: 2),
        () =>
            email == 'foo@bar.com' && password == 'foobar',
      ).then(
        (isLoggedIn) =>
            isLoggedIn ? const LoginHandle.fooBar() : null,
      );
}
