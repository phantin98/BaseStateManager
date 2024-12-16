import 'dart:async';
import 'dart:ui';

abstract class StateManagerBase {
  /// Register a new state with an optional default value
  void registerState<T>(String key, {T? defaultValue});

  /// Get the current value of a state
  T getState<T>(String key);

  /// Update the value of a state
  void updateState<T>(String key, T value);

  /// Get a Stream to listen for state changes
  Stream<T> getStateStream<T>(String key);

  /// Add a listener for state changes
  void addListener(String key, VoidCallback callback);

  /// Remove a listener
  void removeListener(String key, VoidCallback callback);

  /// Reset a state to its default value
  void resetState(String key);

  /// Dispose all states and listeners
  void dispose();
}
