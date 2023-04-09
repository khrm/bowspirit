import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:json2yaml/json2yaml.dart';

import 'package:http/http.dart' as http;

class Metadata extends StatefulWidget {
  final Uri url;
  const Metadata({super.key, required this.url});
  
  @override
  _MetadataState createState() => _MetadataState();
}

class _MetadataState extends State<Metadata> {

  late Map<String, dynamic>_data;
  late String _file;
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
    final response = await http.get(widget.url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      setState(() {
        _data = jsonData;
        var jsonFile = json.decode(utf8.decode(base64.decode( _data["data"]["value"].toString())));
        _file =  json2yaml(jsonFile);
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
        return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
      appBar: AppBar(),
      body: Center(
        child:SingleChildScrollView(

        child: SelectableText("${_file}"),
      ),
    )
    );
  }

}