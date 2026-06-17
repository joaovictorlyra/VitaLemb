import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'state/app_state.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const VitaLembApp());
}

class VitaLembApp extends StatelessWidget {
  const VitaLembApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Reconstrói o app quando as preferências de acessibilidade mudam
    // (ex.: aumento de fonte aplicado globalmente via textScaler).
    return ListenableBuilder(
      listenable: settingsStore,
      builder: (context, _) => MaterialApp(
        title: 'VitaLemb',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(settingsStore.textScale),
          ),
          child: child!,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
