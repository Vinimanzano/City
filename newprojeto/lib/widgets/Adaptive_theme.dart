import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode() ?? AdaptiveThemeMode.light;
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode savedThemeMode;

  const MyApp({super.key, required this.savedThemeMode});

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
      initial: savedThemeMode,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'Adaptive Theme',
        theme: theme,
        darkTheme: darkTheme,
        home: const MyHomePage(),
      ),
      debugShowFloatingThemeButton: true,
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final adaptiveTheme = AdaptiveTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adaptive Theme'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Light'),
                  const SizedBox(width: 10),
                  Switch(
                    value: adaptiveTheme.mode.isDark,
                    onChanged: (value) {
                      if (value) {
                        adaptiveTheme.setDark();
                      } else {
                        adaptiveTheme.setLight();
                      }
                    },
                  ),
                  const SizedBox(width: 10),
                  const Text('Dark'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
