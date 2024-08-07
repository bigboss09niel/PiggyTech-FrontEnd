import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'services/user.dart';
import 'admin/admin_drawer_list.dart';
import 'sales/sales_drawer_list.dart';
import 'services/user_all.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool isPasswordVisible = false;
  bool isLoading = false;

  Future<Map<String, dynamic>> login(User user) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/api/v1/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          'usernameOrEmail': user.email,
          'password': user.password
        }),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw Exception('Incorrect email or password. Please try again.');
    }
  }

  void _login() async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      setState(() {
        isLoading = true;
      });

      User user = User(
        username: '',
        email: email,
        password: password,
      );

      try {
        Map<String, dynamic> loginResponse = await login(user);
        print('Login response: $loginResponse');
        setState(() {
          isLoading = false;
        });

        if (loginResponse.containsKey('roles')) {
          List<dynamic> roles = loginResponse['roles'];
          String username = loginResponse['username'] ?? '';
          String address = loginResponse['address'] ?? '';
          String phone = loginResponse['phone'] ?? '';
          String gender = loginResponse['gender'] ?? '';
          DateTime createdAt = DateTime.parse(loginResponse['createdAt'] ?? DateTime.now().toIso8601String());

          User_all userAll = User_all(
            username: username,
            email: email,
            password: password,
            address: address,
            phone: phone,
            gender: gender,
            createdAt: createdAt,
          );

          if (roles.contains('ROLE_ADMIN')) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AdminDrawerList(userAll: userAll),
              ),
            );
          } else if (roles.contains('ROLE_USER')) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SalesDrawerList(userAll: userAll),
              ),
            );
          } else {
            showErrorDialog('User role not recognized');
          }
        } else {
          showErrorDialog('Roles not found in the response');
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print('Error during login processing: $e');
        showErrorDialog(e.toString());
      }
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Failed'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.yellow,
        body: Stack(
          children: [
            Container(
              margin: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Spacer(flex: 1),
                  _header(context),
                  Spacer(flex: 1),
                  _inputField(context),
                  Spacer(flex: 3),
                ],
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  _header(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/logo.png',
          height: 200,
        ),
        Text(
          "Welcome to PiggyTech",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        Text("Enter your credentials to login"),
      ],
    );
  }

  Widget _inputField(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
              fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
              filled: true,
              prefixIcon: Icon(Icons.email),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please provide an email';
              }
              return null;
            },
            onSaved: (value) {
              email = value ?? '';
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
              fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
              filled: true,
              prefixIcon: Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              ),
            ),
            obscureText: !isPasswordVisible,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 8) {
                return 'Password should be at least 8 characters long';
              }
              return null;
            },
            onSaved: (value) {
              password = value ?? '';
            },
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: isLoading ? null : _login,
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Don\'t have an account?',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 5.0,),
              InkWell(
                child: Text(
                  'Signup Here',
                  style: TextStyle(
                    color: Colors.pink[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignupScreen()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}