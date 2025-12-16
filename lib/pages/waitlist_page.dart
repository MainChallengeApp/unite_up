// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unite_up/services/env_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WaitlistPage extends StatelessWidget {
  const WaitlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // Create the iframe
      final html.IFrameElement iframe = html.IFrameElement()
        ..src = EnvService.waitlistUrl
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%';

      // ignore: undefined_prefixed_name
      // Registers the iframe with Flutter's platform view registry
      ui.platformViewRegistry.registerViewFactory(
        'iframeElement',
        (int viewId) => iframe,
      );

      // Return the HtmlElementView that uses the iframe
      return HtmlElementView(viewType: 'iframeElement');
    }

    // Mobile: normal WebView
    return WebViewWidget(
      controller: WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse(EnvService.waitlistUrl)),
    );
  }
}
