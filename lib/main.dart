import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

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

      // === CONFIGURAÇÕES ADICIONAIS ===
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('QualityFruit App'),
            Text(
              'Pura Fruta Exportadora',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: <Widget>[
            // === LOGO E BOAS-VINDAS ===
            _buildWelcomeSection(context),

            const SizedBox(height: 48),

            // === BOTÕES PRINCIPAIS ===
            _buildMainActions(context),

            const SizedBox(height: 32),

            // === CARDS DE FICHAS RECENTES ===
            _buildRecentCards(context),
          ],
        ),
      ),
    );
  }

  /// Seção de boas-vindas com logo
  Widget _buildWelcomeSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Ícone principal com gradiente
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.agriculture,
            size: 64,
            color: theme.colorScheme.onPrimary,
          ),
        ),

        const SizedBox(height: 24),

        // Título principal
        Text(
          'Bem-vindo ao QualityFruit',
          style: theme.textTheme.headlineLarge,
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        // Subtítulo
        Text(
          'Avalie a qualidade das suas frutas de forma rápida e precisa',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Botões principais de ação
  Widget _buildMainActions(BuildContext context) {
    return Column(
      children: [
        // Botão principal - Nova Ficha
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🚧 Tela de Nova Ficha em desenvolvimento!'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Nova Ficha de Qualidade'),
          ),
        ),

        const SizedBox(height: 16),

        // Botão secundário - Histórico
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('📋 Histórico em desenvolvimento!'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            icon: const Icon(Icons.history),
            label: const Text('Ver Histórico'),
          ),
        ),
      ],
    );
  }

  /// Cards de fichas recentes
  Widget _buildRecentCards(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Fichas Recentes', style: theme.textTheme.headlineSmall),

        const SizedBox(height: 16),

        // Card de exemplo - Ficha Finalizada
        _buildRecentCard(
          context,
          title: 'Fazenda São José - Lote A',
          date: '20/07/2025',
          status: 'Finalizada',
          statusColor: theme.colorScheme.tertiary,
          varieties: ['Uva Itália', 'Uva Red Globe'],
        ),

        const SizedBox(height: 12),

        // Card de exemplo - Ficha em Andamento
        _buildRecentCard(
          context,
          title: 'Fazenda Vista Alegre - Lote B',
          date: '22/07/2025',
          status: 'Em Andamento',
          statusColor: theme.colorScheme.secondary,
          varieties: ['Uva Thompson', 'Uva Crimson'],
        ),
      ],
    );
  }

  /// Card individual de ficha recente
  Widget _buildRecentCard(
    BuildContext context, {
    required String title,
    required String date,
    required String status,
    required Color statusColor,
    required List<String> varieties,
  }) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Abrindo ficha: $title'),
              backgroundColor: statusColor,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Barra colorida de status
              Container(
                width: 4,
                height: 60,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(width: 16),

              // Conteúdo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      varieties.join(' • '),
                      style: theme.textTheme.bodyMedium,
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(date, style: theme.textTheme.bodySmall),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            status,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
