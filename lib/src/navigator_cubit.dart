// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

/// A [Cubit] whose [state] is a [List] of [Page]s.
///
/// This is an abstract class so cannot be instantiated directly.
/// Instead, create your own class which extends [NavigatorCubit]:
///
/// ```dart
/// class HomeNavigatorCubit extends NavigatorCubit {
///   HomeNavigatorCubit({required Page root}) : super(root: root);
/// }
/// ```
abstract class NavigatorCubit extends Cubit<List<Page>> {
  /// Constructs a [NavigatorCubit] with the given [root] page.
  ///
  /// The [root] will be the first [Page] displayed.
  NavigatorCubit({required Page root}) : super([root]);

  /// Pushes the given [page] to the top of the stack.
  void push(Page page) {
    emit([
      ...state,
      page,
    ]);
  }

  /// Removes the top-most [Page] from the stack i.e. navigate back one page.
  bool pop() {
    if (state.length > 1) {
      emit(
        state.take(state.length - 1).toList(),
      );
      return true;
    } else {
      return false;
    }
  }

  /// Replaces the top-most [Page] in the stack with the given [page].
  void replace(Page page) {
    emit(
      [
        ...state.take(state.length - 1),
        page,
      ],
    );
  }

  @override
  void onChange(Change<List<Page>> change) {
    super.onChange(change);

    assert(change.nextState.isNotEmpty);
  }
}
