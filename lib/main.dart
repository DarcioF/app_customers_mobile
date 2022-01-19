import 'package:app_customers/views/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  runApp(MaterialApp(
    title: "Controle de Clientes",
    home: Home(),
    builder: EasyLoading.init(),
  ));
}
