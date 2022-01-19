import 'dart:convert';
import 'dart:io';

import 'package:app_customers/database/models/customer.dart';
import 'package:app_customers/database/web/webclient.dart';
import 'package:async/async.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CustomersRepository {
  Future<List<Customers>> findAll() async {
    try {
      final url = Uri.http(baseUrl, "/customers");
      final Response res =
          await client.get(url).timeout(const Duration(seconds: 15));
      final List<Customers> customers = [];
      final List<dynamic> decodedJson = jsonDecode(res.body);
      for (Map<String, dynamic> customersJson in decodedJson) {
        customers.add(Customers.fromJson(customersJson));
      }
      return customers;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<Customers?> save({required Customers customer, File? image}) async {
    try {
      final url = Uri.http(baseUrl, "/customers");
      var request = http.MultipartRequest("POST", url);
      request.fields['nome'] = customer.nome;
      request.fields['sobrenome'] = customer.sobrenome;
      request.fields['email'] = customer.email;
      if (image != null) {
        var stream = http.ByteStream(DelegatingStream.typed(image.openRead()));
        var length = await image.length();
        request.files.add(http.MultipartFile('dataFile', stream, length,
            filename: basename(image.path)));
      }
      var response = await request.send();
      Customers? obj;
      response.stream.transform(utf8.decoder).listen((value) {
        Map<String, dynamic> json = jsonDecode(value);
        obj = Customers.fromJson(json);
      });
      return obj;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Customers?> update({required Customers customer, File? image}) async {
    try {
      final url = Uri.http(baseUrl, "/customers/${customer.id}");
      var request = http.MultipartRequest("PUT", url);
      request.fields['nome'] = customer.nome;
      request.fields['sobrenome'] = customer.sobrenome;
      request.fields['email'] = customer.email;
      if (image != null) {
        var stream = http.ByteStream(DelegatingStream.typed(image.openRead()));
        var length = await image.length();
        request.files.add(http.MultipartFile('dataFile', stream, length,
            filename: basename(image.path)));
      }
      var response = await request.send();
      Customers? obj;
      response.stream.transform(utf8.decoder).listen((value) {
        Map<String, dynamic> json = jsonDecode(value);
        obj = Customers.fromJson(json);
      });
      return obj;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> delete({required int? id}) async {
    try {
      final url = Uri.http(baseUrl, "/customers/$id");
      final Response res = await client.delete(url);
      return res.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Customers?> find({required int id}) async {
    try {
      final url = Uri.http(baseUrl, "/customers/$id");
      final Response res = await client.get(url);
      Map<String, dynamic> json = jsonDecode(res.body);
      Customers obj = Customers.fromJson(json);
      return obj;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<Customers>> filter({required String filter}) async {
    try {
      final url = Uri.http(baseUrl, "/customers/filter");
      final Map<String, dynamic> filterMap = {
        'filter': filter,
      };
      final Response res = await client
          .post(url,
              headers: {
                'Content-type': 'application/json',
              },
              body: jsonEncode(filterMap))
          .timeout(const Duration(seconds: 15));
      final List<Customers> customers = [];
      final List<dynamic> decodedJson = jsonDecode(res.body);
      for (Map<String, dynamic> customersJson in decodedJson) {
        customers.add(Customers.fromJson(customersJson));
      }
      return customers;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<File> fileFromImageUrl({required String? urlFile, required int? id}) async {
    final url = Uri.http(baseUrl, "/$urlFile");
    final response = await http.get(url);
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File(join(documentDirectory.path, 'image-$id.png'));
    file.writeAsBytesSync(response.bodyBytes);
    return file;
  }
}
