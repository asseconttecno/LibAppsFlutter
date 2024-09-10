

import 'package:hyj_share_extend/hyj_share_extend.dart';

import '../enums/enums.dart';

export '../enums/enums.dart';

class ExternalShare {

  static share(String titulo, String texto, String url) async  {
    await ShareExtend.share(titulo, "text", sharePanelTitle: texto);
  }

  static shareFile({required String titulo, required String nomeFile,
    required String path, required SheredType? tipo}) async {

    await ShareExtend.share(path, tipo?.value ?? "file",
      sharePanelTitle: titulo,
      subject: nomeFile);
  }

}