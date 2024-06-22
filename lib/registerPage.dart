import 'package:flutter/material.dart';
import 'package:tiketkonser_mobile/homePage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Form:
  // Name
  // Email
  // Password
  // Confirm Password
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final String email = _emailController.text;
      final String name = _nameController.text;
      final String password = _passwordController.text;
      final String confirmPassword = _confirmPasswordController.text;
      try {
        final response = await http.post(
          Uri.parse('http://127.0.0.1:8000/api/register'),
          body: {
            'email': email,
            'name': name,
            'password': password,
            'password_confirmation': confirmPassword
          },
        );

        if (response.statusCode == 201) {
          // Handle success response
          final Map<String, dynamic> responseData = json.decode(response.body);
          print(responseData);
          print({
            'userName': responseData['user']['name'],
            'email': responseData['user']['email'],
            'userId': responseData['user']['id'].toString()
          });

          // Navigate to home and pass the user data
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                  userName: responseData['user']['name'],
                  email: responseData['user']['email'],
                  userId: responseData['user']['id'].toString()),
            ),
          );
          // Display success message and navigate to home
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Register success')));
        } else {
          // Handle error response
          print(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registration failed')));
        }
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Registration failed')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pemesanan Tiket Konser'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            color: Colors.grey[900],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Nama',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Masukkan nama';
                        }
                        if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                          return 'Inputan harus berupa huruf';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Masukkan email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Email tidak valid';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Masukkan password';
                        }
                        if (value.length < 6) {
                          return 'Password minimal 6 karakter';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                        controller: _confirmPasswordController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Konfirmasi Password',
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null;
                          }
                          return null;
                        }),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
