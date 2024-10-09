enum ObrigacaoStatus {
  Nenhum(-1, "Nenhum"),
  EmAberto(0, "Em Aberto"),
  Concluido(1, "Concluído"),
  SemMovimentoNaoAvaliado(2, "Sem Movimento Não Avaliado"),
  SemMovimentoRejeitado(3, "Sem Movimento Rejeitado"),
  Provisorio(4, "Provisório"),
  SemMovimento(5, "Sem Movimento"),
  AguardandoAprovacao(6, "Aguardando Aprovação"),
  ArquivoComDivergencia(7, "Arquivo com divergência");

  final int value;
  final String description;

  const ObrigacaoStatus(this.value, this.description);

  static ObrigacaoStatus fromInt(int value) {
    return ObrigacaoStatus.values.firstWhere(
          (status) => status.value == value,
      orElse: () => Nenhum,
    );
  }
}
