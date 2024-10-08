import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:newprojeto/screens/login_screen.dart';
import 'package:newprojeto/screens/bairros_screen.dart';
import 'package:newprojeto/screens/messages_screen.dart';
import 'package:newprojeto/screens/profile_screen.dart';
import 'package:newprojeto/screens/homescreen.dart';

class NavigationBarApp extends StatefulWidget {
  final String username;

  const NavigationBarApp({required this.username, Key? key}) : super(key: key);

  @override
  _NavigationBarAppState createState() => _NavigationBarAppState();
}

class _NavigationBarAppState extends State<NavigationBarApp> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(username: 'User'),
    BairrosScreen(),
    ProfileScreen(),
    MessagesScreen(),
  ];

  Future<bool> _checkForUnsavedChanges() async {
    return true;
  }

  Future<void> _onItemTapped(int index) async {
    if (index == 4) {
      _confirmLogout();
    } else {
      final hasUnsavedChanges = await _checkForUnsavedChanges();
      if (hasUnsavedChanges) {
        setState(() {
          _selectedIndex = index;
        });
      }
    }
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Saída'),
          content: Text('Você realmente deseja sair do aplicativo?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Sair'),
              onPressed: () {
                Navigator.of(context).pop();
                _logout();
              },
            ),
          ],
        );
      },
    );
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen(onToggleTheme: () {})),
      (Route<dynamic> route) => false,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Você saiu do aplicativo.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_city),
            label: 'Bairros',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Mensagens',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Sair',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: brightness == Brightness.dark ? Colors.white : Colors.black,
        unselectedItemColor: brightness == Brightness.dark ? Colors.grey : Colors.black54,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final currentThemeMode = AdaptiveTheme.of(context).mode;
          final newThemeMode = currentThemeMode == AdaptiveThemeMode.light
              ? AdaptiveThemeMode.dark
              : AdaptiveThemeMode.light;
          AdaptiveTheme.of(context).setThemeMode(newThemeMode);
        },
        child: Icon(Icons.brightness_6),
        tooltip: 'Alternar Tema',
      ),
    );
  }
}
