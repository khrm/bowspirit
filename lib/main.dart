import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'home.dart';

void main() {
  HttpOverrides.global = DebugHttpOverrides();
  runApp(const MyApp());
}

class DebugHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Bowspirit';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: RestDataTable(apiUrl:Uri.https("127.0.0.1", "/apis/results.tekton.dev/v1alpha2/parents/default/results")),
      ),
    );
  }
}
