import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_notifier.dart';
import 'core/services/services.dart';
import 'presentation/pages/splash_screen.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/criar_ficha_page.dart';
import 'presentation/pages/lista_fichas_page.dart';

// Instância global do gerenciador de tema
final themeNotifier = ThemeNotifier();

void main() async {
  // Garante que o Flutter esteja inicializado
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o tema
  await themeNotifier.initTheme();

  // Inicializa a estrutura da aplicação
  try {
    final appInit = AppInitializationService();
    await appInit.initialize();
    debugPrint('🚀 Aplicação inicializada com sucesso');
  } catch (e) {
    debugPrint('❌ Erro na inicialização: $e');
  }

  runApp(const QualityFruitApp());
}

class QualityFruitApp extends StatefulWidget {
  const QualityFruitApp({super.key});

  @override
  State<QualityFruitApp> createState() => _QualityFruitAppState();
}

class _QualityFruitAppState extends State<QualityFruitApp> {
  @override
  void initState() {
    super.initState();
    // Escuta mudanças no tema
    themeNotifier.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QualityFruit App - Pura Fruta Exportadora',

      // === LOCALIZAÇÃO ===
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR'), Locale('en', 'US')],
      locale: const Locale('pt', 'BR'),

      // === APLICANDO TEMA CONTROLADO ===
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeNotifier.themeMode, // Usa o tema controlado

      home: const SplashScreen(nextRoute: '/home'),

      // === ROTAS ===
      routes: {
        '/home': (context) => const HomePage(),
        '/criar-ficha': (context) => const CriarFichaPage(),
        '/lista-fichas': (context) => const ListaFichasPage(),
      },

      // === CONFIGURAÇÕES ADICIONAIS ===
      debugShowCheckedModeBanner: false,
    );
  }
}
