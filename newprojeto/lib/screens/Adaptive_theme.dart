import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:newprojeto/screens/home_screen.dart';
import 'package:newprojeto/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatefulWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const MyApp({Key? key, this.savedThemeMode}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AdaptiveThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.savedThemeMode ?? AdaptiveThemeMode.light;
  }

  void _toggleTheme() {
    final theme = AdaptiveTheme.of(context);
    if (theme != null) {
      setState(() {
        _themeMode = _themeMode == AdaptiveThemeMode.light
            ? AdaptiveThemeMode.dark
            : AdaptiveThemeMode.light;
        theme.setThemeMode(_themeMode);
      });
    } else {
      print('AdaptiveTheme is not available');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blue,
      ),
      dark: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
      ),
      initial: _themeMode,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'Adaptive Theme',
        theme: theme,
        darkTheme: darkTheme,
        themeMode: _themeMode == AdaptiveThemeMode.light
            ? ThemeMode.light
            : ThemeMode.dark,
        home: LoginScreen(onToggleTheme: _toggleTheme),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
