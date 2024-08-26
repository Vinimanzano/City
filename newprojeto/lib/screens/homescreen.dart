import 'dart:io';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String username;
  final File? profileImage;

  const HomeScreen({required this.username, this.profileImage, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: profileImage != null
                ? FileImage(profileImage!)
                : NetworkImage('https://www.w3schools.com/w3images/avatar1.png') as ImageProvider,
          ),
          SizedBox(height: 16),
          // Exibe o nome do usuário
          Text(
            'Bem-vindo(a)',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text(
            username,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
