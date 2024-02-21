import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key, required this.userData});
  final Map userData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('User profile'),
        ),
        body: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.person_add_outlined),
              title: const Text('Full Name',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle:
                  Text("${userData['first_name']} ${userData['last_name']}"),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Username',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text(userData['username']),
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text(userData['email']),
            ),
          ],
        ));
  }
}
