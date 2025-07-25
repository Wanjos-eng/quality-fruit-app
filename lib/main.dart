import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/criar_ficha_page.dart';
import 'presentation/pages/lista_fichas_page.dart';

void main() {
  runApp(const QualityFruitApp());
}

class QualityFruitApp extends StatelessWidget {
  const QualityFruitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QualityFruit App - Pura Fruta Exportadora',

      // === APLICANDO NOVO TEMA ===
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Detecta automaticamente tema do sistema

      home: const HomePage(),

      // === ROTAS ===
      routes: {
        '/criar-ficha': (context) => const CriarFichaPage(),
        '/lista-fichas': (context) => const ListaFichasPage(),
      },

      // === CONFIGURAÇÕES ADICIONAIS ===
      debugShowCheckedModeBanner: false,
    );
  }
}
