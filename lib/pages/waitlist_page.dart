import 'package:flutter/material.dart';

import 'waitlist_page_mobile.dart'
    if (dart.library.html) 'waitlist_page_web.dart';

class WaitlistPage extends StatelessWidget {
  const WaitlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const WaitlistPageContent();
  }
}
