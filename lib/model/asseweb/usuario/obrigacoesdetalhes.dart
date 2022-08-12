import 'dart:convert';

class ObrigacoesDetalhes {
  ObrigacoesDetalhes({
    this.obrigacaoDescricao,
    this.obrigacaoTipo,
    this.responsavel,
    this.vencimento,
    this.competencia,
    this.clienteId,
    this.obrigacaoArquivoId,
    this.disponivelPor,
    this.disponivelEm,
    this.visualizadoPor,
    this.visualizadoEm,
    this.emailEnviadoEm,
    this.smsEnviadoEm,
  });

  String? obrigacaoDescricao;
  String? obrigacaoTipo;
  String? responsavel;
  String? vencimento;
  String? competencia;
  int? clienteId;
  int? obrigacaoArquivoId;
  String? disponivelPor;
  String? disponivelEm;
  String? visualizadoPor;
  String? visualizadoEm;
  String? emailEnviadoEm;
  String? smsEnviadoEm;

  factory ObrigacoesDetalhes.fromJson(String str) => ObrigacoesDetalhes.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ObrigacoesDetalhes.fromMap(Map<String, dynamic> json) => ObrigacoesDetalhes(
    obrigacaoDescricao: json["obrigacaoDescricao"] == null ? null : json["obrigacaoDescricao"],
    obrigacaoTipo: json["obrigacaoTipo"] == null ? null : json["obrigacaoTipo"],
    responsavel: json["responsavel"] == null ? null : json["responsavel"],
    vencimento: json["vencimento"] == null ? null : json["vencimento"],
    competencia: json["competencia"] == null ? null : json["competencia"],
    clienteId: json["clienteId"] == null ? null : json["clienteId"],
    obrigacaoArquivoId: json["obrigacaoArquivoId"] == null ? null : json["obrigacaoArquivoId"],
    disponivelPor: json["disponivelPor"] == null ? null : json["disponivelPor"],
    disponivelEm: json["disponivelEm"] == null ? null : json["disponivelEm"],
    visualizadoPor: json["visualizadoPor"] == null ? null : json["visualizadoPor"],
    visualizadoEm: json["visualizadoEm"] == null ? null : json["visualizadoEm"],
    emailEnviadoEm: json["emailEnviadoEm"] == null ? null : json["emailEnviadoEm"],
    smsEnviadoEm: json["smsEnviadoEm"] == null ? null : json["smsEnviadoEm"],
  );

  Map<String, dynamic> toMap() => {
    "obrigacaoDescricao": obrigacaoDescricao == null ? null : obrigacaoDescricao,
    "obrigacaoTipo": obrigacaoTipo == null ? null : obrigacaoTipo,
    "responsavel": responsavel == null ? null : responsavel,
    "vencimento": vencimento == null ? null : vencimento,
    "competencia": competencia == null ? null : competencia,
    "clienteId": clienteId == null ? null : clienteId,
    "obrigacaoArquivoId": obrigacaoArquivoId == null ? null : obrigacaoArquivoId,
    "disponivelPor": disponivelPor == null ? null : disponivelPor,
    "disponivelEm": disponivelEm == null ? null : disponivelEm,
    "visualizadoPor": visualizadoPor == null ? null : visualizadoPor,
    "visualizadoEm": visualizadoEm == null ? null : visualizadoEm,
    "emailEnviadoEm": emailEnviadoEm == null ? null : emailEnviadoEm,
    "smsEnviadoEm": smsEnviadoEm == null ? null : smsEnviadoEm,
  };
}
