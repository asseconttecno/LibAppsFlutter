
import 'dart:async';
import 'package:universal_io/io.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:schedulers/schedulers.dart';

import '../../enums/enums.dart';
import '../../model/model.dart';
import '../../services/services.dart';
import '../../config.dart';
import '../controllers.dart';




class ConfigTabletManager extends ChangeNotifier {
  final SendMail _sendMail = SendMail();
  final SqlitePontoService _sqlitePonto = SqlitePontoService();

  ConfigModel configModel = ConfigModel(email: EmpresaPontoManager.empresa?.email ?? '',
    status: ConfigBackup.Semanal, hora: '23:00', local: Config.documentos);
  Timer? timer;

  initConfig(EmpresaPontoModel empresa) async {
    try{
      List? config = await _sqlitePonto.initConfig();
      difeDiaSemana(DateTime.now());
      if(config == null || config.isEmpty){
        await _sqlitePonto.insertConfig( configModel.toMap());
      }else{
        configModel = ConfigModel.fromSql(config.first);
        notifyListeners();
      }
      autoBackup(empresa);
    }catch(e){
      debugPrint("erro initConfig sql $e");
    }
  }

  Future<bool> saveConfig({required EmpresaPontoModel empresa, String? email,
        int? status, String? hora, String? local}) async {
    ConfigModel _configModel = configModel;
    try{
      updateConfig(
          email: email,
          status: status,
          hora: hora,
          local: local
      );
      int result = await _sqlitePonto.updateConfig( configModel.toMap());
      debugPrint(result.toString());
      autoBackup(empresa);
      return true;
    }catch(e){
      debugPrint("erro saveConfig sql $e");
      configModel = _configModel;
      notifyListeners();
      return false;
    }
  }

  updateConfig({String? email, int? status, String? hora, String? local}) async {
    try{
      configModel = configModel.copyWith(
          email: email,
          status: status,
          hora: hora,
          local: local
      );
      notifyListeners();
    }catch(e){
      debugPrint("erro updateConfig sql $e");
    }
  }

  static int difeDiaSemana(DateTime data) {
    int dia;

    switch (DateFormat('EEE', 'pt_BR').format(data).toUpperCase() ) {
      case 'SAB' :
        dia = 6;
        break;
      case 'DOM' :
        dia = 5;
        break;
      case 'SEG' :
        dia = 4;
        break;
      case 'TER' :
        dia = 3;
        break;
      case 'QUA' :
        dia = 2;
        break;
      case 'QUI' :
        dia = 1;
        break;
      default :
        dia = 0;
    }
    return dia;
  }

  autoBackup(EmpresaPontoModel empresa){
    final scheduler = TimeScheduler();
    int hora = int.parse(configModel.hora!.split(':').first);
    int min = int.parse(configModel.hora!.split(':').last);

    try {
      if(configModel.status == ConfigBackup.Mensal){
        timer = Timer.periodic(const Duration(days: 30), (timer) {
          int mes = DateTime.now().month + 1;
          int ano = mes > 12 ? DateTime.now().year + 1 : DateTime.now().year;
          mes = mes > 12 ? 1 : mes;
          DateTime _data = DateTime(ano, mes, 1, hora, min).subtract(const Duration(days: 1));
          scheduler.run(() {
            backup(empresa);
          }, _data);
        });
      }else if(configModel.status == ConfigBackup.Semanal){
        timer = Timer.periodic(const Duration(days: 7), (timer) {
          int difeDias = difeDiaSemana(DateTime.now());
          int mes = DateTime.now().add(Duration(days: difeDias)).month;
          int ano = DateTime.now().add(Duration(days: difeDias)).year;
          int dia = DateTime.now().add(Duration(days: difeDias)).day;
          DateTime _data = DateTime(ano, mes, dia, hora, min).subtract(const Duration(days: 1));
          scheduler.run(() {
            backup(empresa);
          }, _data);
        });
      }else{
        if(hora == DateTime.now().hour){
          int mes = DateTime.now().month;
          int ano = DateTime.now().year;
          int dia = DateTime.now().day;
          DateTime _data = DateTime(ano, mes, dia, hora, min);
          scheduler.run(() {
            backup(empresa);
          }, _data);
        }
        timer = Timer.periodic(const Duration(hours: 6), (timer) {
          int mes = DateTime.now().month;
          int ano = DateTime.now().year;
          int dia = DateTime.now().day;
          DateTime _data = DateTime(ano, mes, dia, hora, min);
          scheduler.run(() {
            backup(empresa);
          }, _data);
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<bool> backup(EmpresaPontoModel empresa,) async {
    try {
      List? resultsql = await _sqlitePonto.getHistorico(null);
      if(resultsql != null && resultsql.isNotEmpty){
        DateTime inicio = DateTime.parse(resultsql.first["datahora"]);
        DateTime terminmo = DateTime.parse(resultsql.last["datahora"]);
        File? _file = await afd(empresa, inicio, terminmo, resultsql);
        if(_file != null){
          bool rest = await _sendMail.postSendMail(configModel.email!,
              'Segue anexo do AFD ate data ${DateFormat("dd/MM/yyyy", 'pt_BR').format(DateTime.now())}' , _file);
          return rest;
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<File?> afd(EmpresaPontoModel empresa, DateTime inicio, DateTime fim, List marcacoes) async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;

      String _data = '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
      File file = File('$tempPath/afd-$_data.txt');


      int identCnpj = 1;
      if((empresa.cnpj?.replaceAll("/", "").replaceAll(".", "").replaceAll("-", "").length ?? 0) == 11){
        identCnpj = 2;
      }
      String afd = "0000000001$identCnpj${empresa.cnpj?.replaceAll("/", "").replaceAll(".", "").replaceAll("-", "").padLeft(14, "0")}"
          "000000000000${empresa.nome?.padRight(150, " ")}79982892361254320${DateFormat("ddMMyyyy", 'pt_BR').format(inicio)}"
          "${DateFormat("ddMMyyyy", 'pt_BR').format(fim)}${DateFormat("ddMMyyyy", 'pt_BR').format(DateTime.now())}"
          "${DateFormat("HHmm", 'pt_BR').format(DateTime.now())}\n";

      if(marcacoes.isNotEmpty){
        marcacoes.map((e){
          String pis = e["pis"] != null ? e["pis"].toString() : e["registro"] != null ? e["registro"].toString() : "0";
          afd = "$afd${e["id"].toString().padLeft(9, "0")}3${DateFormat("ddMMyyyy", 'pt_BR').format( DateTime.parse(e["datahora"]) )}"
              "${DateFormat("HHmm", 'pt_BR').format( DateTime.parse(e["datahora"]) )}${pis.padLeft(11, "0")} "
              "${e["nome"]}\n";
        }).toList();
      }

      await file.writeAsString(afd);

      try {
        File localFile = File('${configModel.local}/afd-$_data.txt');
        await localFile.writeAsString(afd);
      } catch (e) {
        debugPrint(e.toString());
      }

      return file;
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}