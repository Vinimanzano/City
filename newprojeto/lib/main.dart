import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:newprojeto/screens/login_screen.dart';
import 'package:newprojeto/screens/registrar.dart';
import 'package:newprojeto/screens/TelaSolicitacaoSenha.dart';
import 'package:newprojeto/screens/navigation_bar_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const MyApp({super.key, this.savedThemeMode});

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
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'Minha Aplicação',
        theme: theme,
        darkTheme: darkTheme,
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => LoginScreen(onToggleTheme: () {
            final currentThemeMode = AdaptiveTheme.of(context).mode;
            final newThemeMode = currentThemeMode == AdaptiveThemeMode.light
                ? AdaptiveThemeMode.dark
                : AdaptiveThemeMode.light;
            AdaptiveTheme.of(context).setThemeMode(newThemeMode);
          }),
          '/registrar': (context) => Registrar(onToggleTheme: () {
            final currentThemeMode = AdaptiveTheme.of(context).mode;
            final newThemeMode = currentThemeMode == AdaptiveThemeMode.light
                ? AdaptiveThemeMode.dark
                : AdaptiveThemeMode.light;
            AdaptiveTheme.of(context).setThemeMode(newThemeMode);
          }),
          '/TelaSolicitacaoSenha': (context) => TelaSolicitacaoSenha(),
          '/NavigationBarApp': (context) => NavigationBarApp(username: 'user'),
        },
      ),
    );
  }
}
