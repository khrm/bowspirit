import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'routes.dart';

class RestDataTable extends StatefulWidget {
  final Uri apiUrl;

  const RestDataTable({required this.apiUrl});

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
      final List<dynamic> result = jsonData['results'];
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
          DataCell(
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(LogRoute(row["summary"]["record"].toString()));
              },
              child: const Text('Logs!'),
            ),
          ),
          DataCell(
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MetadataRoute(row["summary"]["record"].toString()));
              },
              child: const Text('Pipelinerun.yaml'),
            ),
          ),
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
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : DataTable(columns: const <DataColumn>[
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
                  'Metadata',
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
          ], rows: buildRow(_data));
  }
}
