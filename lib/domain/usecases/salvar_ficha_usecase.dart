import '../entities/entities.dart';
import '../repositories/repositories.dart';

/// Use case para salvar uma ficha completa com validações
class SalvarFichaUseCase {
  final FichaRepository _fichaRepository;

  const SalvarFichaUseCase(this._fichaRepository);

  /// Salva uma ficha com validações de negócio
  Future<Ficha> call(Ficha ficha) async {
    // SEMPRE gerar numeroFicha automaticamente (fazenda + data + ano)
    final fichaComNumero = _gerarNumeroFicha(ficha);

    // Validação: número da ficha deve ser único
    if (await _fichaRepository.existeNumero(fichaComNumero.numeroFicha)) {
      final fichaExistente = await _fichaRepository.buscarPorNumero(
        fichaComNumero.numeroFicha,
      );
      if (fichaExistente != null && fichaExistente.id != fichaComNumero.id) {
        throw Exception(
          'Número da ficha já existe: ${fichaComNumero.numeroFicha}',
        );
      }
    }

    // Validação: data de avaliação não pode ser futura
    if (fichaComNumero.dataAvaliacao.isAfter(DateTime.now())) {
      throw Exception('Data de avaliação não pode ser futura');
    }

    // Garantir que criadoEm seja sempre a data atual do sistema
    final fichaFinal = fichaComNumero.copyWith(
      criadoEm: DateTime.now(),
      atualizadoEm: fichaComNumero.id.isNotEmpty ? DateTime.now() : null,
    );

    return await _fichaRepository.salvar(fichaFinal);
  }

  /// Gera o número da ficha no formato: sigla-dia-mês-ano
  /// Exemplo: PVE-01-01-2025 (Pura Verde - 01/01/2025)
  /// Sigla da fazenda é sempre padronizada para 3 letras
  Ficha _gerarNumeroFicha(Ficha ficha) {
    final data = ficha.dataAvaliacao;

    // Garantir que a sigla da fazenda seja sempre 3 letras
    String siglaFazenda = ficha.fazenda.toUpperCase().replaceAll(' ', '');
    if (siglaFazenda.length < 3) {
      // Se for menor que 3, completar com 'X'
      siglaFazenda = siglaFazenda.padRight(3, 'X');
    } else if (siglaFazenda.length > 3) {
      // Se for maior que 3, pegar apenas as 3 primeiras letras
      siglaFazenda = siglaFazenda.substring(0, 3);
    }

    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    final ano = data.year.toString();

    final numeroGerado = '$siglaFazenda-$dia-$mes-$ano';

    return ficha.copyWith(numeroFicha: numeroGerado);
  }
}
