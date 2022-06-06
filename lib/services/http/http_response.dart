
import 'http_error.dart';

class MyHttpResponse {
  final bool isSucess;
  var data;
  HttpError? httpError;
  int? codigo;

  MyHttpResponse({required this.isSucess, this.httpError, this.data, this.codigo});
}