import 'package:flutter/material.dart';
import 'package:tasheha_app/Theme/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tasheha_app/pages/register_option.dart';
import 'package:tasheha_app/pages/forget_password_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>(); // => Input validation
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isLoggedIn = false;

  Future<void> _saveUserLogin(bool isLoggedIn) async {

    final pre= await SharedPreferences.getInstance();
    await pre.setBool('isLoggedIn', isLoggedIn);

  }

  Future<void> _loginFunction() async {
    if (!_formKey.currentState!.validate()) return; //as stop button 
    setState(() => _isLoading = true);
    
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        _showSnackBar(responseData['message'] ?? 'Login successful'); 
        setState(() => _isLoggedIn = true);
        await _saveUserLogin(_isLoggedIn);
      } 
      else {
        final error = json.decode(response.body)['error'] ?? 'Login failed';
        _showSnackBar(error, isError: true);
      }
    }
     on http.ClientException // => If Server Down
      catch (e) {
      _showSnackBar('Error: ${e.message}', isError: true);
    } 
    catch (e) {
      _showSnackBar('Error: ${e.toString()}', isError: true);
    } 
    finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.blueC : AppColors.brownC,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _goToRegisterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterOption()),
    );
  }

  void _goToforgetPasswordPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ForgetPasswordPage()),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 100),
               
                Text(
                  'Welcome back',
                  style: TextStyle(
                    color: AppColors.blueC,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'RadioCanadaBig'
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Login to your account',
                  style: TextStyle(
                    color: AppColors.brownC,
                    fontSize: 16,
                    fontFamily: 'RadioCanadaBig'
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          filled: true,
                          fillColor: AppColors.blueC,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, 
                            vertical: 15,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          filled: true,
                          fillColor: AppColors.blueC,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, 
                            vertical: 15,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _goToforgetPasswordPage,
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(color: AppColors.blueC),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _loginFunction,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brownC,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text('Login'),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Divider(
                        color: AppColors.blueC,
                        thickness: 1,
                        height: 1,
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'Don\'t have an account?',
                        style: TextStyle(color: AppColors.brownC),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: _goToRegisterPage,
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                            color: AppColors.blueC,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
