import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:tasheha_app/Theme/colors.dart';
import 'dart:io';

class RegisterOwnerPage extends StatefulWidget {
  @override
  _RegisterOwnerPageState createState() => _RegisterOwnerPageState();
}

class _RegisterOwnerPageState extends State<RegisterOwnerPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _placeNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  List<XFile> _images = [];
  String? city;
  String? type;
  bool _isLoading = false;

  final List<String> cityOptions = [
    "Amman", "Irbid", "Balqa", "Zarqa", "Mafraq",
    "Jerash", "Ajloun", "Madaba", "Karak",
    "Tafilah", "Ma'an", "Aqaba"
  ];

  final List<String> typeOptions = [
    "Restaurant", "Cafe", "Gaming Place", "Shopping Mall",
    "Park", "Museum", "Art Gallery", "Theater/Cinema", "Zoo"
  ];

  Future<void> _pickImages() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile>? selectedImages = await picker.pickMultiImage(
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (selectedImages != null && selectedImages.isNotEmpty) {
        setState(() {
          _images.addAll(selectedImages);
          if (_images.length > 10) {
            _images = _images.sublist(0, 10);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Maximum 10 images allowed')),
            );
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick images: $e')),
      );
    }
  }

  Future<void> _registerOwner() async {
    if (!_formKey.currentState!.validate()) return;
    if (_images.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must upload at least 5 images')),
      );
      return;
    }
    if (city == null || type == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select city and place type')),
      );
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      var url = Uri.parse('http://127.0.0.1:8000/register/owner/');
      var request = http.MultipartRequest('POST', url);

      
      request.fields.addAll({
        'Fname': _firstNameController.text.trim(),
        'Lname': _lastNameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'password': _passwordController.text,
        'place_name': _placeNameController.text.trim(),
        'city': city!,
        'type': type!,
        'description': _descriptionController.text.trim(),
      });

      // Add images
      for (var image in _images) {
        var file = await http.MultipartFile.fromPath(
          'images', 
          image.path,
          filename: image.name,
        );
        request.files.add(file);
      }

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful!')),
        );
        Navigator.pop(context);
      } else {
        var error = jsonDecode(responseData)['error'] ?? 'Registration failed';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColors.blueC,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required List<String> options,
    required String? value,
    required Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.blueC,
        borderRadius: BorderRadius.circular(40),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: DropdownButtonFormField<String>(
        value: value,
        hint: Text(hint),
        isExpanded: true,
        items: options.map((option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _placeNameController.dispose();
    _descriptionController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Owner Registration'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 80),
                Text(
                  'Welcome to TripJO',
                  style: TextStyle(
                    color: AppColors.blueC,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'RadioCanadaBig'
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Add your and your place information to join us',
                  style: TextStyle(
                    color: AppColors.brownC,
                    fontSize: 16,
                    fontFamily: 'RadioCanadaBig'
                  ),
                ),
                const SizedBox(height: 40),
              SizedBox(height: 20),
              _buildTextField(
                label: 'First Name',
                controller: _firstNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              _buildTextField(
                label: 'Last Name',
                controller: _lastNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              _buildTextField(
                label: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              _buildTextField(
                label: 'Phone Number',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              _buildTextField(
                label: 'Password',
                controller: _passwordController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              _buildTextField(
                label: 'Confirm Password',
                controller: _confirmPasswordController,
                obscureText: true,
              ),
              SizedBox(height: 15),
              _buildTextField(
                label: 'Place Name',
                controller: _placeNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your place name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              _buildDropdown(
                hint: 'Select City',
                options: cityOptions,
                value: city,
                onChanged: (value) => setState(() => city = value),
              ),
              SizedBox(height: 15),
              _buildDropdown(
                hint: 'Select Place Type',
                options: typeOptions,
                value: type,
                onChanged: (value) => setState(() => type = value),
              ),
              SizedBox(height: 15),
              _buildTextField(
                label: 'Description (Optional)',
                controller: _descriptionController,
               
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImages,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(Icons.upload,color: AppColors.blueC,),
                    SizedBox(width: 8),
                    Text('Upload Images (${_images.length})',style: TextStyle(color: AppColors.blueC),),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 12),
                ),
              ),
              SizedBox(height: 15),
              if (_images.isNotEmpty)
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _images.map((image) {
                    return Stack(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: FileImage(File(image.path)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.close, size: 18),
                            onPressed: () {
                              setState(() => _images.remove(image));
                            },
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                          onPressed: _isLoading ? null : _registerOwner,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brownC,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Sign Up'),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}