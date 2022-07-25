import '../../config.dart';
import '../http/http.dart';

class SenhaAssewebService {
  HttpCli _http = HttpCli();


  Future<bool> passwordrecover(String email,String senha) async {
    String _api = "/api/ExternalLogin/passwordrecover";
    final MyHttpResponse response = await _http.post(
        url: Config.conf.apiAsseponto! + _api,
        body: {
          "email": email.trim().replaceAll(' ', ''),
          "password": senha
        }
    );

    return response.isSucess;
  }

  Future<bool> alteracaoPass(String token, String email,String senha) async {
    String _api = "/api/ExternalLogin/changepassword";
    final MyHttpResponse response = await _http.post(
        url: Config.conf.apiAsseponto! + _api,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + token
        },
        body: {
          "email": email.trim().replaceAll(' ', ''),
          "password": senha
        }
    );
    return response.isSucess;
  }
}