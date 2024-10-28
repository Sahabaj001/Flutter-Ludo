

import 'package:flutter/material.dart';
import 'app_lifecycle_notifier.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  final AppLifecycleStateNotifier notifier;

  AppLifecycleObserver(this.notifier);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    notifier.value = state;
    super.didChangeAppLifecycleState(state);
  }
}