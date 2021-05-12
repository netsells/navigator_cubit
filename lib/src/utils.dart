// 🐦 Flutter imports:
import 'package:flutter/widgets.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// 🌎 Project imports:
import 'cubit_navigator.dart';
import 'navigator_cubit.dart';

/// Navigation extensions for BuildContext
extension CubitNavigatorX on BuildContext {
  /// Method that allows widgets to access a [NavigatorCubit] instance
  /// as long as their [BuildContext] contains a [CubitNavigator] instance.
  ///
  /// If we want to access an instance of `MyNavigatorCubit` which was provided
  /// higher up in the widget tree we can do so via:
  ///
  /// ```dart
  /// context.navigatorCubit<MyNavigatorCubit>();
  /// ```
  T navigatorCubit<T extends NavigatorCubit>({bool listen = false}) {
    return BlocProvider.of<T>(this, listen: listen);
  }
}
