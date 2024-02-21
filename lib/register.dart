import 'package:flutter/material.dart';
import 'package:notes/helper.dart';
import 'package:sqflite/sqflite.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool success = false;

  Future<void> _registerUser() async {
    final String firstName = _firstNameController.text.trim();
    final String lastName = _lastNameController.text.trim();
    final String username = _usernameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    Database db = await DBHElper.initDB();
    try {
      await db.insert('user', {
        "first_name": firstName,
        "last_name": lastName,
        "username": username,
        "email": email,
        "password": password
      });
      setState(() {
        success = true;
      });
      _firstNameController.clear();
      _lastNameController.clear();
      _usernameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _formKey.currentState!.reset();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Register',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildTextField(_firstNameController, "First Name"),
                const SizedBox(height: 10),
                _buildTextField(_lastNameController, "Last Name"),
                const SizedBox(height: 10),
                _buildTextField(_usernameController, "Username"),
                const SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter Email";
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return "Enter valid email";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                _buildTextField(_passwordController, "Password",
                    isPassword: true),
                const SizedBox(height: 10),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Confirm your Password";
                    } else if (value != _passwordController.text) {
                      return "Passwords do not Match";
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Confirm Password",
                    hintText: "Confirm Password",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _registerUser();
                    }
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                if (success)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Registration Success',
                      style: TextStyle(color: Colors.green),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your $hint";
        }
        return null;
      },
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: hint,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
