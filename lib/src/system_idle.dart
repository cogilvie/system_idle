import 'dart:async';
import 'dart:io';

import 'package:system_idle/src/system_idle_linux.dart';
import 'package:system_idle/src/system_idle_macos.dart';
import 'package:system_idle/src/system_idle_windows.dart';

const couldNotInitialize = 'Could not initialize the plugin';
const notInitialized = 'Plugin has not been initialized. Call initialize first';
const systemReturnedNull = 'System returned null value';
const unknownError = 'Unknown error';

const defaultIdleDuration = Duration(minutes: 5);

abstract class SystemIdleChecker {
  /// {@template system_idle_initialize}
  /// Initializes SystemIdle plugin with given time
  /// If time is not provided the default time is used;
  /// {@endtemplate}
  Future<void> initialize({required Duration duration});

  /// {@template system_idle_on_idle_state_changed}
  /// Returns a bool stream with changes of the idle state
  /// {@endtemplate}
  Stream<bool> onIdleStateChanged();
}

class SystemIdleException implements Exception {
  const SystemIdleException({required this.message});

  final String message;
}

class SystemIdle {
  SystemIdle._() {
    if (Platform.isWindows) {
      _systemIdleChecker = SystemIdleCheckerWindows();
    } else if (Platform.isMacOS) {
      _systemIdleChecker = SystemIdleCheckerMacOS();
    } else if (Platform.isLinux) {
      _systemIdleChecker = SystemIdleCheckerLinux();
    }
  }

  static final SystemIdle _instance = SystemIdle._();

  /// A singleton instance of [SystemIdle] class
  static SystemIdle get instance => _instance;

  late SystemIdleChecker _systemIdleChecker;

  /// {@macro system_idle_initialize}
  Future<void> initialize({Duration duration = defaultIdleDuration}) =>
      _systemIdleChecker.initialize(duration: duration);

  /// {@macro system_idle_on_idle_state_changed}
  Stream<bool> get onIdleStateChanged =>
      _systemIdleChecker.onIdleStateChanged();
}
