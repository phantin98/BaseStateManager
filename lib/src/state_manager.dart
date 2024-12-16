import 'dart:async';
import 'dart:ui';
import 'state_manager_base.dart';
import 'performance_logger.dart';

class StateManager implements StateManagerBase {
  static final Map<String, dynamic> _states = {};
  static final Map<String, StreamController<dynamic>> _controllers = {};
  static final Map<String, WeakReference<List<VoidCallback>>> _listeners = {};

  @override
  void registerState<T>(String key, {T? defaultValue}) {
    PerformanceLogger.start('registerState:$key'); // Start performance logging

    if (!_states.containsKey(key)) {
      _states[key] = defaultValue;
      _controllers[key] = StreamController<T>.broadcast();
      _listeners[key] = WeakReference([]);
    }

    PerformanceLogger.stop('registerState:$key'); // Stop performance logging
  }

  @override
  T getState<T>(String key) {
    PerformanceLogger.start('getState:$key'); // Start performance logging

    if (!_states.containsKey(key)) {
      throw Exception('State "$key" is not registered.');
    }
    T state = _states[key] as T;

    PerformanceLogger.stop('getState:$key'); // Stop performance logging
    return state;
  }

  @override
  void updateState<T>(String key, T value) {
    PerformanceLogger.start('updateState:$key'); // Start performance logging

    if (!_states.containsKey(key)) {
      throw Exception('State "$key" is not registered.');
    }
    _states[key] = value;

    _controllers[key]?.add(value);
    _notifyListeners(key);

    PerformanceLogger.stop('updateState:$key'); // Stop performance logging
  }

  @override
  Stream<T> getStateStream<T>(String key) {
    PerformanceLogger.start('getStateStream:$key'); // Start performance logging

    if (!_controllers.containsKey(key)) {
      throw Exception('State "$key" is not registered.');
    }
    Stream<T> stream = _controllers[key]!.stream as Stream<T>;

    PerformanceLogger.stop('getStateStream:$key'); // Stop performance logging
    return stream;
  }

  @override
  void addListener(String key, VoidCallback callback) {
    PerformanceLogger.start('addListener:$key'); // Start performance logging

    if (!_listeners.containsKey(key)) {
      throw Exception('State "$key" is not registered.');
    }
    final weakListeners = _listeners[key]!.target;
    weakListeners?.add(callback);

    PerformanceLogger.stop('addListener:$key'); // Stop performance logging
  }

  @override
  void removeListener(String key, VoidCallback callback) {
    PerformanceLogger.start('removeListener:$key'); // Start performance logging

    if (_listeners.containsKey(key)) {
      _listeners[key]!.target?.remove(callback);
    }

    PerformanceLogger.stop('removeListener:$key'); // Stop performance logging
  }

  @override
  void resetState(String key) {
    PerformanceLogger.start('resetState:$key'); // Start performance logging

    if (!_states.containsKey(key)) {
      throw Exception('State "$key" is not registered.');
    }
    final defaultValue = _states[key];
    _states[key] = defaultValue;
    _controllers[key]?.add(defaultValue);
    _notifyListeners(key);

    PerformanceLogger.stop('resetState:$key'); // Stop performance logging
  }

  @override
  void dispose() {
    PerformanceLogger.start('dispose'); // Start performance logging

    _controllers.forEach((key, controller) {
      controller.close();
    });
    _controllers.clear();
    _states.clear();
    _listeners.clear();

    PerformanceLogger.stop('dispose'); // Stop performance logging
  }

  void _notifyListeners(String key) {
    final weakListeners = _listeners[key]?.target;
    weakListeners?.forEach((callback) {
      callback();
    });
  }
}

/// Wrapper class for WeakReference
class WeakReference<T> {
  final T? target;

  WeakReference(this.target);
}
