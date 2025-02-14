import 'package:hive/hive.dart';

import '../../config.dart';
import '../../model/model.dart';

part 'db_model.g.dart';

@HiveType(typeId: 0)
class UserDB extends HiveObject {
  @HiveField(0)
  String? cpf;

  @HiveField(1)
  int? funcionarioId;

  @HiveField(2)
  String? nome;

  @HiveField(3)
  String? registro;

  @HiveField(4)
  String? cargo;

  @HiveField(5)
  String? foto;

  @HiveField(6)
  String? email;

  @HiveField(7)
  String? pis;

  @HiveField(8)
  bool? permitirMarcarPontoWeb;

  @HiveField(9)
  bool? permitirMarcarPonto;

  @HiveField(10)
  bool? permitirMarcarPontoOffline;

  @HiveField(11)
  bool? capturarGps;

  @HiveField(12)
  DateTime? ultimaMarcacao;

  @HiveField(13)
  int? setorId;

  @HiveField(14)
  String? cnpj;

  @HiveField(15)
  DateTime? dataInicial;

  @HiveField(16)
  DateTime? dataFinal;

  @HiveField(17)
  String? descricaoPeriodo;

  @HiveField(18)
  bool? app;

  @HiveField(19)
  int? databaseId;

  @HiveField(20)
  String? senha;

  factory UserDB.fromPonto(UsuarioPonto values) => UserDB(
      databaseId: values.databaseId,
      app: values.app,
      nome: values.funcionario?.nome,
      registro: values.funcionario?.registro,
      cpf: values.funcionario?.cpf,
      cargo: values.funcionario?.cargo,
      email: values.funcionario?.email,
      pis: values.funcionario?.pis,
      foto: values.funcionario?.foto,
      permitirMarcarPontoWeb: values.funcionario?.permitirMarcarPontoWeb,
      permitirMarcarPonto: values.funcionario?.permitirMarcarPonto,
      permitirMarcarPontoOffline: values.funcionario?.permitirMarcarPontoOffline,
      capturarGps: values.funcionario?.capturarGps,
      ultimaMarcacao: values.funcionario?.ultimaMarcacao,
      setorId: values.funcionario?.setorId,
      cnpj: values.funcionario?.cnpj,
      dataFinal: values.periodo?.dataFinal,
      dataInicial: values.periodo?.dataInicial,
      descricaoPeriodo: values.periodo?.descricao,
      senha: Config.usenha
  );


  UsuarioPonto get ponto {
    Config.usenha = senha;
    return UsuarioPonto(
      databaseId: databaseId,
      app: app,
      periodo: Periodo(
        dataFinal: dataFinal,
        dataInicial: dataInicial,
        descricao: descricaoPeriodo
      ),
      funcionario: Funcionario(
          nome: nome,
          registro: registro,
          cpf: cpf,
          cargo: cargo,
          email: email,
          pis: pis,
          foto: foto,
          permitirMarcarPontoWeb: permitirMarcarPontoWeb,
          permitirMarcarPonto: permitirMarcarPonto,
          permitirMarcarPontoOffline: permitirMarcarPontoOffline,
          capturarGps: capturarGps,
          ultimaMarcacao: ultimaMarcacao,
          setorId: setorId,
          cnpj: cnpj
      )
    );
  }

  UserDB({
    this.databaseId,
    this.cpf,
    this.funcionarioId,
    this.nome,
    this.registro,
    this.cargo,
    this.foto,
    this.email,
    this.pis,
    this.permitirMarcarPontoWeb,
    this.permitirMarcarPonto,
    this.permitirMarcarPontoOffline,
    this.capturarGps,
    this.ultimaMarcacao,
    this.setorId,
    this.cnpj,
    this.dataInicial,
    this.dataFinal,
    this.descricaoPeriodo,
    this.app,
    this.senha
  });
}
