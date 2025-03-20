import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tasheha_app/Theme/colors.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final _emailController = TextEditingController();
  final _resetCodeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool isLoading = false;
  bool isResetCodeVisible = false;
  bool isPasswordFieldsVisible = false;

  bool isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(email);
  }

  Future<void> sendForgotPasswordRequest() async {
    final email = _emailController.text; 
    if (!isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid email address'))
      );
      return;
    }

    setState(() => isLoading = true); 

    final url = Uri.parse('http://127.0.0.1:8000/forgot_password');
    final body = json.encode({'email': email});

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message']))
        );
        setState(() => isResetCodeVisible = true); 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${responseData['detail'] ?? 'An error occurred, try again'}'))
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('There was a problem connecting to the server, please try again'))
      );
    }

    setState(() => isLoading = false); 
  }

  Future<void> checkResetCode() async {
    final resetCode = _resetCodeController.text;

    if (resetCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter the verification code')),
      );
      return;
    }

    setState(() => isLoading = true);
    final url = Uri.parse('http://127.0.0.1:8000/reset_password');
    final body = {
      'email': _emailController.text,
      'reset_code': resetCode,
      'new_password': _newPasswordController.text
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        setState(() => isPasswordFieldsVisible = true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification code is correct.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['detail'] ?? 'Invalid code')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('There is a problem, please try again')),
      );
    }

    setState(() => isLoading = false);
  }

  Future<void> sendResetPasswordRequest() async {
    final email = _emailController.text;
    final resetCode = _resetCodeController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Passwords do not match')));
      return;
    }

    setState(() => isLoading = true);
    final url = Uri.parse('http://127.0.0.1:8000/reset_password');
    final body = {'email': email, 'reset_code': resetCode, 'new_password': newPassword};

    try {
      final response = await http.post(url, headers: {'Content-Type': 'application/json'}, body: json.encode(body));
      final responseData = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseData['message'])));

      _emailController.clear();
      _resetCodeController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      setState(() {
        isResetCodeVisible = false;
        isPasswordFieldsVisible = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('There is a problem, please try again')));
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 150),
              Text('Reset Password', style: TextStyle(color: AppColors.blueC, fontSize: 35)),
              const SizedBox(height: 15),
              Text('Enter email and reset code', style: TextStyle(color: AppColors.brownC, fontSize: 15)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Column(
                  children: [
                    TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Enter your email', filled: true, fillColor: AppColors.blueC, border: OutlineInputBorder(borderRadius: BorderRadius.circular(40), borderSide: BorderSide.none)), keyboardType: TextInputType.emailAddress),
                    SizedBox(height: 20),
                    isLoading ? CircularProgressIndicator(): ElevatedButton(
                      onPressed: isLoading ? null : sendForgotPasswordRequest, 
                      child: Text('Send Reset Code'),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.brownC),
                    ),
                    
                    if (isResetCodeVisible) ...[
                      SizedBox(height: 20),
                      TextField(controller: _resetCodeController, decoration: InputDecoration(labelText: 'Enter Reset Code', filled: true, fillColor: AppColors.blueC, border: OutlineInputBorder(borderRadius: BorderRadius.circular(40), borderSide: BorderSide.none))),
                      SizedBox(height: 20),
                      isLoading ? CircularProgressIndicator() : ElevatedButton(onPressed: checkResetCode, child: Text('Check Code'), style: ElevatedButton.styleFrom(backgroundColor: AppColors.brownC)),
                    ],
                    if (isPasswordFieldsVisible) ...[
                      SizedBox(height: 20),
                      TextField(controller: _newPasswordController, decoration: InputDecoration(labelText: 'Enter New Password', filled: true, fillColor: AppColors.blueC, border: OutlineInputBorder(borderRadius: BorderRadius.circular(40), borderSide: BorderSide.none)), obscureText: true),
                      SizedBox(height: 20),
                      TextField(controller: _confirmPasswordController, decoration: InputDecoration(labelText: 'Confirm New Password', filled: true, fillColor: AppColors.blueC, border: OutlineInputBorder(borderRadius: BorderRadius.circular(40), borderSide: BorderSide.none)), obscureText: true),
                      SizedBox(height: 20),
                      isLoading ? CircularProgressIndicator() : ElevatedButton(onPressed: sendResetPasswordRequest, child: Text('Reset Password'), style: ElevatedButton.styleFrom(backgroundColor: AppColors.brownC)),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
