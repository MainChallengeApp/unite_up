import 'package:flutter/widgets.dart';
import 'package:unite_up/services/env_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Mobile implementation using WebView
class WaitlistPageContent extends StatelessWidget {
  const WaitlistPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse(EnvService.waitlistUrl)),
    );
  }
}

