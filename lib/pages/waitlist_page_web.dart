// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'dart:ui_web' as ui;

import 'package:flutter/widgets.dart';
import 'package:unite_up/services/env_service.dart';

/// Web implementation using iframe
class WaitlistPageContent extends StatelessWidget {
  const WaitlistPageContent({super.key});

  static bool _registered = false;

  @override
  Widget build(BuildContext context) {
    if (!_registered) {
      final html.IFrameElement iframe = html.IFrameElement()
        ..src = EnvService.waitlistUrl
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%';

      ui.platformViewRegistry.registerViewFactory(
        'iframeElement',
        (int viewId) => iframe,
      );
      _registered = true;
    }

    return const HtmlElementView(viewType: 'iframeElement');
  }
}
