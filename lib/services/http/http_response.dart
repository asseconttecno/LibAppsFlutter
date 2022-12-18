
import 'http_error.dart';

class MyHttpResponse {
  final bool isSucess;
  var data;
  HttpError? httpError;
  int? codigo;
  String? extencao;

  MyHttpResponse({required this.isSucess, this.httpError, this.extencao, this.data, this.codigo});
}