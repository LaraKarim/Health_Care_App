import 'package:flutter_test/flutter_test.dart';
import 'package:healthapp/signup.dart';

void main() {
  test('validateEmail should return null for valid email', () {
    final signupPage = SignupPage();
    expect(signupPage.validateEmail('example@example.com'), null);
  });

  test('validateEmail should return error message for empty email', () {
    final signupPage = SignupPage();
    expect(signupPage.validateEmail(''), 'Please enter a correct email');
  });
  test('validateEmail should return error message for incorrect email format',
      () {
    final signupPage = SignupPage();
    expect(signupPage.validateEmail('invalidemail'),
        'Please enter a correct email');
  });

  test('validatePassword should return null for valid password', () {
    final signupPage = SignupPage();
    expect(signupPage.validatePassword('password123'), null);
  });

  test('validatePassword should return error message for empty password', () {
    final signupPage = SignupPage();
    expect(signupPage.validatePassword(''), 'Please enter your password');
  });

  test(
      'validatePassword should return error message for password less than 6 characters',
      () {
    final signupPage = SignupPage();
    expect(signupPage.validatePassword('pass'),
        'Password should be at least 6 characters long');
  });

  test('validateUsername should return null for valid username', () {
    final signupPage = SignupPage();
    expect(signupPage.validateUsername('john_doe'), null);
  });

  test('validateUsername should return error message for empty username', () {
    final signupPage = SignupPage();
    expect(signupPage.validateUsername(''), 'Please enter your username');
  });

  test('validateConfirmPassword should return null for matching passwords', () {
    final signupPage = SignupPage();
    expect(signupPage.validateConfirmPassword('password', 'password'), null);
  });

  test(
      'validateConfirmPassword should return error message for mismatched passwords',
      () {
    final signupPage = SignupPage();
    expect(signupPage.validateConfirmPassword('password', 'password123'),
        'Passwords do not match');
  });
}
