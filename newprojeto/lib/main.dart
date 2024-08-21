import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './screens/bairros_screen.dart';
import './screens/home_screen.dart';
import './screens/navigation_bar_app.dart';
import './screens/thank_you_screen.dart';
import './screens/os_screen.dart';
import './screens/login_screen.dart';
import './screens/registrar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;
  
  runApp(MyApp(isDarkMode: isDarkMode));
}

class MyApp extends StatefulWidget {
  final bool isDarkMode;

  const MyApp({required this.isDarkMode, Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

  void _toggleTheme() async {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seu Aplicativo',
      theme: ThemeData(
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/login_screen',
      routes: {
        '/': (context) => LoginScreen(),
        '/login_screen': (context) => LoginScreen(),
        '/thank_you': (context) => ThankYouScreen(),
        '/os_screen': (context) => OsScreen(bairro: 'Exemplo'),
        '/bairros_screen': (context) => BairrosScreen(),
        '/navigation_bar_app': (context) => NavigationBarApp(username: 'UsuarioExemplo'),
        '/home_screen': (context) => HomeScreen(username: 'UsuarioExemplo'),
        '/registrar': (context) => Registrar(onToggleTheme: _toggleTheme),
      },
    );
  }
}
