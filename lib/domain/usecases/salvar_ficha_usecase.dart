import '../entities/entities.dart';
import '../repositories/repositories.dart';

/// Use case para salvar uma ficha completa com validações
class SalvarFichaUseCase {
  final FichaRepository _fichaRepository;

  const SalvarFichaUseCase(this._fichaRepository);

  /// Salva uma ficha com validações de negócio
  Future<Ficha> call(Ficha ficha) async {
    // Validação: número da ficha deve ser único
    if (await _fichaRepository.existeNumero(ficha.numeroFicha)) {
      final fichaExistente = await _fichaRepository.buscarPorNumero(
        ficha.numeroFicha,
      );
      if (fichaExistente != null && fichaExistente.id != ficha.id) {
        throw Exception('Número da ficha já existe: ${ficha.numeroFicha}');
      }
    }

    // Validação: peso total deve ser positivo
    if (ficha.pesoTotal <= 0) {
      throw Exception('Peso total deve ser maior que zero');
    }

    // Validação: quantidade de amostras deve ser positiva
    if (ficha.quantidadeAmostras <= 0) {
      throw Exception('Quantidade de amostras deve ser maior que zero');
    }

    // Validação: data de avaliação não pode ser futura
    if (ficha.dataAvaliacao.isAfter(DateTime.now())) {
      throw Exception('Data de avaliação não pode ser futura');
    }

    // Atualiza data de modificação se for uma edição
    final fichaParaSalvar = ficha.id.isNotEmpty && ficha.atualizadoEm == null
        ? ficha.copyWith(atualizadoEm: DateTime.now())
        : ficha;

    return await _fichaRepository.salvar(fichaParaSalvar);
  }
}
