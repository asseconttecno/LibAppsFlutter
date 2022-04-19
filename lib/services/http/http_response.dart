
import 'http_error.dart';

class HttpResponse {
  final bool isSucess;
  var data;
  HttpError? httpError;
  int? codigo;

  HttpResponse({required this.isSucess, this.httpError, this.data, this.codigo});
}