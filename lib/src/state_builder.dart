import 'package:flutter/widgets.dart';
import 'state_manager_base.dart';

class StateBuilder<T> extends StatelessWidget {
  final String stateKey;
  final StateManagerBase stateManager;
  final Widget Function(BuildContext context, T value) builder;

  const StateBuilder({
    super.key,
    required this.stateKey,
    required this.stateManager,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stateManager.getStateStream<T>(stateKey),
      builder: (context, snapshot) {
        final value = snapshot.data ?? stateManager.getState<T>(stateKey);
        return builder(context, value);
      },
    );
  }
}
