/// Centralized duration constants for the Dare U app
class AppDurations {
  // Private constructor to prevent instantiation
  AppDurations._();

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 100);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // Debounce Durations
  static const Duration debounceShort = Duration(milliseconds: 300);
  static const Duration debounceMedium = Duration(milliseconds: 500);
  static const Duration debounceLong = Duration(milliseconds: 1000);

  // Timeout Durations
  static const Duration timeoutShort = Duration(seconds: 5);
  static const Duration timeoutMedium = Duration(seconds: 10);
  static const Duration timeoutLong = Duration(seconds: 30);
}

