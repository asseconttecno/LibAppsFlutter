
import 'http/http.dart';

export 'ponto/apontamento.dart';
export 'ponto/bancohoras.dart';
export 'ponto/homepage.dart';
export 'ponto/marcacao.dart';
export 'ponto/memorando.dart';
export 'ponto/senha.dart';
export 'ponto/usuario.dart';
export 'ponto/espelho.dart';
export 'ponto/registro_ponto.dart';
export 'ponto/comprovante.dart';

export 'holerite/holerite.dart';
export 'holerite/usuario.dart';
export 'holerite/senha.dart';

export 'tablet/empresa.dart';
export 'tablet/usuario_offiline.dart';
export 'tablet/usuario_codigo.dart';

export 'asseweb/usuario.dart';
export 'asseweb/senha.dart';


export 'biometria.dart';
export 'sendmail.dart';
export 'update_app.dart';
export 'sqlite_ponto.dart';

export 'http/http.dart';


abstract class Services {
  final HttpCli http = HttpCli();

}