import 'package:flutter/material.dart';
import 'package:notes/helper.dart';
import 'package:notes/register.dart';
import 'package:sqflite/sqflite.dart';
import 'screen.dart';

import 'add_contacts.dart';

class FormScreen extends StatefulWidget {
  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final userController = TextEditingController();
  final passController = TextEditingController();
  Map userData = {};
  bool passToggle = true;
  bool error = false;

  Future<void> _loginUser() async {
    Database db = await DBHElper.initDB();
    var user = userController.text.trim();
    try {
      var result = await db.rawQuery(
          "SELECT * FROM user WHERE username = '$user' OR email = '$user'");
      if (result.isEmpty) {
        debugPrint("Error");
        setState(() {
          error = true;
        });
      } else {
        if (passController.text != result[0]['password']) {
          debugPrint(passController.text);
          debugPrint(result[0]['password'].toString());
          debugPrint(result.toString());
          setState(() {
            error = true;
          });
        } else {
          setState(() {
            userData = result[0];
          });
          _formKey.currentState!.reset();
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ListScreen(userData: userData)),
            );
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Student Login'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Register()));
              },
              child: const Text(
                'Register',
                style: TextStyle(
                  color: Colors.blueGrey,
                ),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: userController,
                  decoration: const InputDecoration(
                    labelText: 'Email / Username',
                    hintText: 'Enter Username or Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter Username or Email";
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: passToggle,
                  controller: passController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter password',
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                    suffix: InkWell(
                      onTap: () {
                        setState(() {
                          passToggle = !passToggle;
                        });
                      },
                      child: Icon(
                          passToggle ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter Password";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      // Remove focus from any input field
                      _loginUser();
                    }
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                    visible: error,
                    child: const Text(
                      'Login Failed',
                      style: TextStyle(color: Colors.red),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
