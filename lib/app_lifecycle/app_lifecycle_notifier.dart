

import 'package:flutter/material.dart';

class AppLifecycleStateNotifier extends ValueNotifier<AppLifecycleState> {
  AppLifecycleStateNotifier() : super(AppLifecycleState.resumed);
}
