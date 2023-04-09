import 'package:flutter/material.dart';

import 'logs.dart';
import 'metadata.dart';

Route MetadataRoute(String url) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Metadata(
        url: Uri.https(
            "127.0.0.1", "/apis/results.tekton.dev/v1alpha2/parents/$url")),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route LogRoute(String url) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Log(
        url: Uri.https(
            "127.0.0.1",
            "/apis/results.tekton.dev/v1alpha2/parents/$url"
                .replaceFirst(RegExp(r'\/records\/'), "/logs/"))),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
