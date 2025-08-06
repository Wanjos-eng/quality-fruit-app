import 'package:flutter/material.dart';
import '../responsive/responsive.dart';
import '../core/theme/responsive_theme_extensions.dart';

/// Exemplo de como implementar uma tela responsiva usando o sistema global
/// Esta tela demonstra todas as funcionalidades do sistema de responsividade:
/// - Layout diferente para mobile e tablet
/// - Uso de widgets responsivos
/// - Aplicação de valores responsivos do tema
/// - Scaffold responsivo com configurações adequadas
class ExampleResponsivePage extends StatelessWidget {
  const ExampleResponsivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Exemplo Responsivo',

      // === BODY PADRÃO (USADO COMO FALLBACK) ===
      body: _buildMobileLayout(context),

      // === BODY RESPONSIVO ===
      // Layout específico para mobile
      mobileBody: _buildMobileLayout(context),

      // Layout específico para tablet
      tabletBody: _buildTabletLayout(context),

      // === CONFIGURAÇÕES DO SCAFFOLD ===
      centerContentOnTablet: true,
      tabletMaxContentWidth: 800.0,
      applySafeArea: true,

      // === FLOATING ACTION BUTTON ===
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showResponsiveDialog(context);
        },
        child: const Icon(Icons.info),
      ),
    );
  }

  /// Layout otimizado para dispositivos mobile
  Widget _buildMobileLayout(BuildContext context) {
    return ResponsivePage(
      child: ResponsiveSpacing(
        mobileSpacing: 16.0,
        children: [
          // Card de informações do dispositivo
          _buildDeviceInfoCard(context),

          // Lista de exemplos
          _buildExamplesList(context, isMobile: true),

          // Botões de ação
          _buildActionButtons(context, isRow: false),
        ],
      ),
    );
  }

  /// Layout otimizado para dispositivos tablet
  Widget _buildTabletLayout(BuildContext context) {
    return ResponsivePage(
      child: ResponsiveSpacing(
        tabletSpacing: 24.0,
        children: [
          // Card de informações do dispositivo
          _buildDeviceInfoCard(context),

          // Conteúdo em duas colunas para tablets
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Coluna esquerda - Lista de exemplos
              Expanded(
                flex: 2,
                child: _buildExamplesList(context, isMobile: false),
              ),

              SizedBox(width: ResponsiveThemeValues.sectionSpacing(context)),

              // Coluna direita - Informações adicionais
              Expanded(flex: 1, child: _buildSidePanel(context)),
            ],
          ),

          // Botões de ação em linha
          _buildActionButtons(context, isRow: true),
        ],
      ),
    );
  }

  /// Card que mostra informações sobre o dispositivo atual
  Widget _buildDeviceInfoCard(BuildContext context) {
    final theme = Theme.of(context);
    final deviceType = ResponsiveUtils.getDeviceType(context);
    final orientation = ResponsiveUtils.getOrientation(context);
    final screenSize = MediaQuery.of(context).size;

    return Card(
      elevation: theme.responsiveElevation(context, 2.0),
      child: ResponsivePadding(
        mobile: const EdgeInsets.all(16.0),
        tablet: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informações do Dispositivo',
              style: theme.responsiveTextStyle(
                context,
                theme.textTheme.titleLarge,
              ),
            ),

            SizedBox(height: ResponsiveThemeValues.elementSpacing(context)),

            _buildInfoRow('Tipo:', deviceType.name),
            _buildInfoRow('Orientação:', orientation.name),
            _buildInfoRow(
              'Tamanho:',
              '${screenSize.width.toInt()} x ${screenSize.height.toInt()}',
            ),
            _buildInfoRow(
              'É Mobile:',
              ResponsiveUtils.isMobile(context) ? 'Sim' : 'Não',
            ),
            _buildInfoRow(
              'É Tablet:',
              ResponsiveUtils.isTablet(context) ? 'Sim' : 'Não',
            ),
          ],
        ),
      ),
    );
  }

  /// Linha de informação com label e valor
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8.0),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  /// Lista de exemplos de uso do sistema responsivo
  Widget _buildExamplesList(BuildContext context, {required bool isMobile}) {
    return Card(
      child: ResponsivePadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Exemplos de Responsividade',
              style: Theme.of(context).textTheme.titleMedium,
            ),

            SizedBox(height: ResponsiveThemeValues.elementSpacing(context)),

            // Lista de cards de exemplo
            ...List.generate(
              isMobile ? 3 : 5, // Menos itens em mobile
              (index) => _buildExampleItem(context, index),
            ),
          ],
        ),
      ),
    );
  }

  /// Item individual da lista de exemplos
  Widget _buildExampleItem(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.only(
        bottom: ResponsiveThemeValues.elementSpacing(context),
      ),
      padding: ResponsiveThemeValues.cardPadding(context),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(
          Theme.of(context).responsiveBorderRadius(context, 8.0),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            size: ResponsiveThemeValues.iconSize(context),
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(width: ResponsiveThemeValues.elementSpacing(context)),
          Expanded(child: Text('Exemplo de item responsivo ${index + 1}')),
        ],
      ),
    );
  }

  /// Painel lateral (apenas para tablets)
  Widget _buildSidePanel(BuildContext context) {
    return Card(
      child: ResponsivePadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Painel Lateral',
              style: Theme.of(context).textTheme.titleMedium,
            ),

            SizedBox(height: ResponsiveThemeValues.elementSpacing(context)),

            const Text(
              'Este painel só aparece em tablets, demonstrando como '
              'criar layouts específicos para diferentes dispositivos.',
            ),

            SizedBox(height: ResponsiveThemeValues.elementSpacing(context)),

            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Center(child: Text('Conteúdo adicional')),
            ),
          ],
        ),
      ),
    );
  }

  /// Botões de ação com layout responsivo
  Widget _buildActionButtons(BuildContext context, {required bool isRow}) {
    final buttons = [
      ElevatedButton(
        onPressed: () => _showResponsiveSnackBar(context),
        child: const Text('Teste Mobile'),
      ),
      ElevatedButton(
        onPressed: () => _showResponsiveDialog(context),
        child: const Text('Teste Tablet'),
      ),
      OutlinedButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Voltar'),
      ),
    ];

    if (isRow) {
      return ResponsiveSpacing(
        direction: Axis.horizontal,
        mobileSpacing: 12.0,
        tabletSpacing: 16.0,
        children: buttons,
      );
    } else {
      return ResponsiveSpacing(
        direction: Axis.vertical,
        mobileSpacing: 12.0,
        children: buttons
            .map(
              (button) => SizedBox(
                width: double.infinity,
                height: ResponsiveThemeValues.buttonHeight(context),
                child: button,
              ),
            )
            .toList(),
      );
    }
  }

  /// Mostra SnackBar responsivo
  void _showResponsiveSnackBar(BuildContext context) {
    final deviceInfo = ResponsiveUtils.isMobile(context) ? 'Mobile' : 'Tablet';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Você está usando um $deviceInfo!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Mostra dialog responsivo
  void _showResponsiveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ResponsiveWidget(
        mobile: (context) => _buildMobileDialog(context),
        tablet: (context) => _buildTabletDialog(context),
      ),
    );
  }

  /// Dialog otimizado para mobile
  Widget _buildMobileDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Dialog Mobile'),
      content: const Text(
        'Este dialog foi otimizado para dispositivos mobile com '
        'menos espaço na tela.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }

  /// Dialog otimizado para tablet
  Widget _buildTabletDialog(BuildContext context) {
    return Dialog(
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Dialog Tablet',
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            const SizedBox(height: 16.0),

            const Text(
              'Este dialog foi projetado especificamente para tablets, '
              'com mais espaço e melhor aproveitamento da tela maior.',
            ),

            const SizedBox(height: 24.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
