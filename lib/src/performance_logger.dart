import 'dart:developer';

class PerformanceLogger {
  static final Map<String, Stopwatch> _timers = {};

  /// Start timing a process
  static void start(String label) {
    _timers[label] = Stopwatch()..start();
  }

  /// Stop timing and log the result
  static void stop(String label) {
    final timer = _timers[label];
    if (timer != null) {
      timer.stop();
      log('[$label] took ${timer.elapsedMilliseconds}ms');
      _timers.remove(label);
    }
  }
}
