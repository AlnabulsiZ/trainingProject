import 'package:flutter/material.dart';
import 'package:tasheha_app/Theme/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tasheha_app/pages/register_option.dart';
import 'package:tasheha_app/pages/forget_password_page.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();

  //controllers
  Future<void> _loginFunction() async {
    final email = _emailcontroller.text;
    final password = _passwordcontroller.text;

    final url = Uri.parse('http://127.0.0.1:5000/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(responseData['message'])));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to submit login details')));
    }
  }

  void _goToRegisterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterOption()),
    );
  }

  void _forgetPasswordFunction() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForgetPasswordPage()),
    );
  }
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 150),
              Text(
                'Welcome back',
                style: TextStyle(
                  color: AppColors.blueC,
                  fontFamily: 'RadioCanadaBig',
                  fontSize: 40,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'login to your account',
                style: TextStyle(
                  color: AppColors.brownC,
                  fontFamily: 'RadioCanadaBig',
                  fontSize: 15,
                ),
              ),
              //text buttons
              Padding(
                padding: EdgeInsets.only(left: 40, right: 40, top: 40),
                child: Column(
                  children: [
                    TextField(
                      controller: _emailcontroller,
                      decoration: InputDecoration(
                        labelText: '  enter your email',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        filled: true,
                        fillColor: AppColors.blueC,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),

                    //email
                    SizedBox(height: 20),

                    TextField(
                      controller: _passwordcontroller,
                      decoration: InputDecoration(
                        labelText: '  enter password',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        filled: true,
                        fillColor: AppColors.blueC,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      obscureText: true,
                    ),
                  ],
                ),
              ),
              //text field
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _loginFunction,
                    child: Text('Login'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brownC,
                      foregroundColor: AppColors.backC,
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _forgetPasswordFunction,
                    child: Text('forget password'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brownC,
                      foregroundColor: AppColors.backC,
                    ),
                  ),
                ],
              ),

              Divider(color: AppColors.blueC, thickness: 1, height: 40),
              const SizedBox(height: 20),

                  SizedBox(width: 20),
              
              const SizedBox(height: 30),
              Text('you don\'t have an account'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _goToRegisterPage,
                child: Text('Sign up'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brownC,
                  foregroundColor: AppColors.backC,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
