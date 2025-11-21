import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Centralized icon definitions for the Unite Up app.
/// All icons used throughout the app are defined here for consistency and reusability.
class AppIcons {
  // Private constructor to prevent instantiation
  AppIcons._();

  // ============================================================================
  // Navigation Icons
  // ============================================================================
  static const IconData arrowBack = Icons.arrow_back_ios_new_rounded;
  static const IconData arrowForward = Icons.arrow_forward_ios_rounded;
  static const IconData chevronRight = Icons.chevron_right_rounded;

  // ============================================================================
  // Profile & User Icons
  // ============================================================================
  static const IconData person = Icons.person_rounded;
  static const IconData personOutline = Icons.person_outline_rounded;
  static const IconData people = Icons.people_outline_rounded;

  // ============================================================================
  // Action Icons
  // ============================================================================
  static const IconData add = Icons.add_rounded;
  static const IconData close = Icons.close_rounded;
  static const IconData clear = Icons.clear_rounded;
  static const IconData edit = Icons.edit_rounded;
  static const IconData send = Icons.send_rounded;
  static const IconData upload = Icons.upload_rounded;
  static const IconData personAdd = Icons.person_add_rounded;

  // ============================================================================
  // Communication Icons
  // ============================================================================
  static const IconData chat = Icons.chat_bubble_outline_rounded;
  static const IconData notifications = Icons.notifications_outlined;

  // ============================================================================
  // Settings Icons
  // ============================================================================
  static const IconData settings = Icons.settings_outlined;
  static const IconData lightMode = Icons.light_mode_rounded;
  static const IconData darkMode = Icons.dark_mode_rounded;
  static const IconData autoMode = Icons.brightness_auto_rounded;

  // ============================================================================
  // Media Icons
  // ============================================================================
  static const IconData image = Icons.image_rounded;
  static const IconData video = Icons.videocam_rounded;
  static const IconData attachFile = Icons.attach_file_rounded;
  static const IconData file = Icons.insert_drive_file_rounded;

  // ============================================================================
  // Search Icons
  // ============================================================================
  static const IconData search = Icons.search_rounded;
  static const IconData searchOff = Icons.search_off_rounded;

  // ============================================================================
  // Status & Selection Icons
  // ============================================================================
  static const IconData checkCircle = Icons.check_circle_rounded;
  static const IconData checkCircleOutline = Icons.check_circle;
  static const IconData circle = Icons.circle_outlined;

  // ============================================================================
  // Social & Activity Icons
  // ============================================================================
  static const IconData trophy = Icons.emoji_events_rounded;
  static const IconData stats = Icons.bar_chart_rounded;
  static const IconData flag = Icons.flag_rounded;
  static const IconData flagOutline = Icons.flag_outlined;

  // ============================================================================
  // Information Icons
  // ============================================================================
  static const IconData info = Icons.info_outline_rounded;
  static const IconData code = Icons.code_rounded;

  // ============================================================================
  // Authentication Icons
  // ============================================================================
  static const IconData login = Icons.login;
  static const IconData logout = Icons.logout_rounded;
  static const IconData email = Icons.email_outlined;
  static const IconData lock = Icons.lock_outline_rounded;

  // ============================================================================
  // AI & Special Icons
  // ============================================================================
  static const IconData ai = Icons.auto_awesome_rounded;

  // ============================================================================
  // Social Login Icons (Font Awesome)
  // ============================================================================
  static const IconData google = FontAwesomeIcons.google;
  static const IconData apple = FontAwesomeIcons.apple;
}
