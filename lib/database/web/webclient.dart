
import 'package:app_customers/database/web/intercepitador.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

Client client = InterceptedClient.build(interceptors: [
  LoggingInterceptor(),
]);

const String port = '3000';
const String baseUrl = '10.0.0.106:$port';
