import 'package:flutter_test/flutter_test.dart';
import 'package:healthapp/login.dart';

void main() {
  test('check Validation', () {
    final loginpage = LoginPage();
    expect(loginpage.validateEmail(''), 'Please enter your email');
  });

  test('validateEmail should return null for valid email', () {
    final loginPage = LoginPage(); // Instantiate LoginPage
    expect(loginPage.validateEmail('example@example.com'), null);
  });

  test('validatePassword should return null for valid password', () {
    final loginPage = LoginPage(); // Instantiate LoginPage
    expect(loginPage.validatePassword('123456'), null);
  });

  test('validatePassword should return error message for empty password', () {
    final loginPage = LoginPage(); // Instantiate LoginPage
    expect(loginPage.validatePassword(''), 'Please enter your password');
  });
}
