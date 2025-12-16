// lib/utils/url_strategy_web.dart
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void configureUrlStrategy() {
  // Remove the # from Flutter Web URLs
  setUrlStrategy(PathUrlStrategy());
}
