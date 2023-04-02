import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

void main() {
  HttpOverrides.global = new DebugHttpOverrides();
  runApp(MyApp());
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

class RestDataTable extends StatefulWidget {
  final Uri apiUrl;

  RestDataTable({required this.apiUrl});

  @override
  _RestDataTableState createState() => _RestDataTableState();
}

class _RestDataTableState extends State<RestDataTable> {
  late List<Map<String, dynamic>> _data;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    setState(() {
      _isLoading = true;
    });
    final response = await http.get(widget.apiUrl);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      print(jsonData);
      //final Map<String, dynamic> record = jsonData['results'];
      //print("record");
      //print(record);
      final List<dynamic> result = jsonData['results'];
      print("result");
      print(result);
      setState(() {
        _data = result.map((e) => e as Map<String, dynamic>).toList();
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  List<DataRow> buildRow(List<Map<String, dynamic>> data) {
      final rows = <DataRow>[];

  // Add rows dynamically
  for (var row in data) {
    rows.add(
      DataRow(cells: [
        DataCell(Text(row["summary"]["status"].toString())),
        DataCell(Text("")),
        DataCell(Text(row["summary"].toString())),
        DataCell(Text("")),
        DataCell(Text("")),
        DataCell(Text(row["uid"].toString())),
        DataCell(Text(row["createTime"].toString())),
        DataCell(Text("")),
      ]),
    );
  }
  return rows;
  }
  
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Expanded(
            child: Text(
              'State',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Log',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Summary',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Repo',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Revision',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Pipeline',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Started',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Duration',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
      ],
      rows: buildRow(_data)
    );
  }
}

