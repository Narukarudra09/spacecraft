import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spacecraft/provider/auth_provider.dart';

import '../main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLogin = true;
  final _formKey = GlobalKey<FormState>();
  late bool _isLoading = false;
  DateTime? _selectedDate;
  String _selectedGender = 'Male';
  File? _image;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      if (_isLogin) {
        // Handle login
        final email = _emailController.text;
        final password = _passwordController.text;
        final success =
            await Provider.of<AuthProvider>(context, listen: false).login(
          email: email,
          password: password,
        );
        if (success) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const MainScreen()));
        } else {
          // Handle login failure
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Login failed: ${Provider.of<AuthProvider>(context, listen: false).error}')),
          );
        }
      } else {
        // Handle sign up
        final fullName = _nameController.text;
        final email = _emailController.text;
        final password = _passwordController.text;
        final dateOfBirth = _selectedDate!;
        final gender = _selectedGender;
        final profilePicture = _image != null ? _image!.path : '';
        final success = await context.read<AuthProvider>().signUp(
              fullName: fullName,
              email: email,
              password: password,
              dateOfBirth: dateOfBirth,
              gender: gender,
              profilePicture: profilePicture,
            );
        if (success) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()));
        } else {
          // Handle sign up failure
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Sign up failed: ${Provider.of<AuthProvider>(context, listen: false).error}')),
          );
        }
      }

      setState(() => _isLoading = false);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      final File file = File(image.path);
      await Provider.of<AuthProvider>(context, listen: false)
          .saveImageToLocalStorage(file);
      setState(() {
        _image = file;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _isLogin ? 'Welcome Back' : 'Create Account',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  if (!_isLogin) ...[
                    // Profile Picture
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: _image != null
                                ? FileImage(_image!)
                                : const AssetImage('assets/profile.jpeg'),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons.camera),
                                        title: const Text('Camera'),
                                        onTap: () {
                                          _pickImage(ImageSource.camera);
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        leading:
                                            const Icon(Icons.photo_library),
                                        title: const Text('Gallery'),
                                        onTap: () {
                                          _pickImage(ImageSource.gallery);
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: const CircleAvatar(
                                radius: 20,
                                backgroundColor:
                                    Color.fromARGB(255, 21, 27, 31),
                                child: Icon(Icons.camera_alt,
                                    color: Color(0xFFF5F5DC)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (!_isLogin) ...[
                    // Name field
                    TextFormField(
                      style: GoogleFonts.montserrat(
                        color: const Color(0xFFF5F5DC),
                      ),
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Color(0xFFF5F5DC),
                        ),
                        labelStyle: GoogleFonts.montserrat(
                          color: const Color(0xFFF5F5DC),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 21, 27, 31)),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 21, 27, 31)),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 21, 27, 31)),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 21, 27, 31),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Email field
                  TextFormField(
                    style: GoogleFonts.montserrat(
                      color: const Color(0xFFF5F5DC),
                    ),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(
                        Icons.email_rounded,
                        color: Color(0xFFF5F5DC),
                      ),
                      labelStyle: GoogleFonts.montserrat(
                        color: const Color(0xFFF5F5DC),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 21, 27, 31)),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 21, 27, 31)),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 21, 27, 31)),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 21, 27, 31),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  if (!_isLogin) ...[
                    // Date of Birth
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Date of Birth',
                          labelStyle: GoogleFonts.montserrat(
                            color: const Color(0xFFF5F5DC),
                          ),
                          prefixIcon: const Icon(
                            Icons.date_range,
                            color: Color(0xFFF5F5DC),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 21, 27, 31)),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 21, 27, 31)),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 21, 27, 31)),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 21, 27, 31),
                        ),
                        child: Text(
                          _selectedDate == null
                              ? 'Select Date'
                              : DateFormat('MM/dd/yyyy').format(_selectedDate!),
                          style: GoogleFonts.montserrat(
                            color: const Color(0xFFF5F5DC),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Gender
                    DropdownButtonFormField<String>(
                      iconEnabledColor: const Color(0xFFF5F5DC),
                      iconDisabledColor: const Color(0xFFF5F5DC),
                      dropdownColor: const Color.fromARGB(255, 21, 27, 31),
                      value: _selectedGender,
                      style: GoogleFonts.montserrat(
                        color: const Color(0xFFF5F5DC),
                      ),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Color(0xFFF5F5DC),
                        ),
                        labelText: 'Gender',
                        labelStyle: GoogleFonts.montserrat(
                          color: const Color(0xFFF5F5DC),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 21, 27, 31)),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 21, 27, 31)),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 21, 27, 31)),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 21, 27, 31),
                      ),
                      items: ['Male', 'Female', 'Other']
                          .map((gender) => DropdownMenuItem(
                                value: gender,
                                child: Text(gender),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedGender = value);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Password field
                  TextFormField(
                    style: GoogleFonts.montserrat(
                      color: const Color(0xFFF5F5DC),
                    ),
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Color(0xFFF5F5DC),
                      ),
                      labelText: 'Password',
                      labelStyle: GoogleFonts.montserrat(
                        color: const Color(0xFFF5F5DC),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 21, 27, 31)),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 21, 27, 31)),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 21, 27, 31)),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 21, 27, 31),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  if (!_isLogin)
                    TextFormField(
                      style: GoogleFonts.montserrat(
                        color: const Color(0xFFF5F5DC),
                      ),
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: GoogleFonts.montserrat(
                          color: const Color(0xFFF5F5DC),
                        ),
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Color(0xFFF5F5DC),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 21, 27, 31)),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 21, 27, 31)),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 21, 27, 31)),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 21, 27, 31),
                      ),
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),

                  const SizedBox(height: 24),

                  FilledButton(
                    style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                            Color.fromARGB(255, 17, 24, 31)),
                        padding: WidgetStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 16))),
                    onPressed: _isLoading ? null : _handleSubmit,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            _isLogin ? 'Login' : 'Sign Up',
                            style: GoogleFonts.montserrat(
                              color: const Color(0xFFF5F5DC),
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      const Expanded(
                          child:
                              Divider(color: Color.fromARGB(255, 17, 24, 31))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'OR',
                          style: GoogleFonts.montserrat(
                            color: const Color(0xFFF5F5DC),
                          ),
                        ),
                      ),
                      const Expanded(
                          child:
                              Divider(color: Color.fromARGB(255, 17, 24, 31))),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() => _isLogin = !_isLogin);
                    },
                    child: Text(
                      _isLogin
                          ? 'Don\'t have an account? Sign Up'
                          : 'Already have an account? Login',
                      style: const TextStyle(
                          color: Color.fromARGB(255, 17, 24, 31)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
