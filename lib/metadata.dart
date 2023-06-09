import 'dart:convert';
import 'dart:html' as html;

import 'package:any_syntax_highlighter/any_syntax_highlighter.dart';
import 'package:any_syntax_highlighter/themes/any_syntax_highlighter_theme_collection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:json2yaml/json2yaml.dart';

class Metadata extends StatefulWidget {
  final Uri url;
  const Metadata({super.key, required this.url});

  @override
  _MetadataState createState() => _MetadataState();
}

class _MetadataState extends State<Metadata> {
  late Map<String, dynamic> _data;
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
        var jsonFile = json.decode(
            utf8.decode(base64.decode(_data["data"]["value"].toString())));
        _file = json2yaml(jsonFile);
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
            floatingActionButton: FloatingActionButton.extended(
                label: const Text('Download'),
                icon: const Icon(Icons.download_rounded),
                onPressed: () {
                  final text = "${_file}";

                  // prepare
                  final bytes = utf8.encode(text);
                  final blob = html.Blob([bytes]);
                  final url = html.Url.createObjectUrlFromBlob(blob);
                  final anchor =
                      html.document.createElement('a') as html.AnchorElement
                        ..href = url
                        ..style.display = 'none'
                        ..download = 'pipelinerun.yaml';
                  html.document.body?.children.add(anchor);

                  // download
                  anchor.click();

                  // cleanup
                  html.document.body?.children.remove(anchor);
                  html.Url.revokeObjectUrl(url);
                }),
            body: Center(
              child: SingleChildScrollView(
                child: AnySyntaxHighlighter(
                  "${_file}",
                  fontSize: 16,
                  lineNumbers: false, // by default false
                  theme: AnySyntaxHighlighterThemeCollection
                      .defaultLightTheme(), // you can create and pass custom theme using AnySyntaxHighlighterTheme class
                  isSelectableText:
                      true, // this creates a SelectableText.rich() widget, makes text selectable (by default false)
                  useGoogleFont: 'Source Code Pro',
                  copyIcon: const Icon(Icons.copy_rounded,
                      color: Colors.black), // default is white colored icon
                  hasCopyButton: true, // by default false
                  /* other options are:- 
          padding,
          margin,
          textAlign,
          this.textDirection,
          softWrap,
          overflow,
          textScaleFactor,
          maxLines,
          locale,
          strutStyle,
          textWidthBasis,
          textHeightBehavior,
          overrideDecoration
          */
                ),

                //child: SelectableText("${_file}"),
              ),
            ));
  }
}
