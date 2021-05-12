// 🐦 Flutter imports:
import 'package:flutter/widgets.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// 🌎 Project imports:
import 'navigator_cubit.dart';
import 'utils.dart';

/// A [Widget] which handles navigation via a [NavigatorCubit].
class CubitNavigator<T extends NavigatorCubit> extends StatelessWidget {
  /// Constructs a [CubitNavigator]
  CubitNavigator({Key? key, required this.createCubit}) : super(key: key);

  /// Takes a [NavigatorBuilder] function which is responsible for creating
  /// an instance of [NavigatorCubit].
  final NavigatorBuilder<T> createCubit;

  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<T>(
      create: createCubit,
      child: BlocBuilder<T, List<Page>>(
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async =>
                !await _navigatorKey.currentState!.maybePop(),
            child: Navigator(
              key: _navigatorKey,
              pages: state,
              onPopPage: (route, result) {
                if (!route.didPop(result)) {
                  return false;
                }

                return context.navigatorCubit<T>().pop();
              },
            ),
          );
        },
      ),
    );
  }
}

/// A type of [Function] which takes a [BuildContext] and returns a
/// subclass of [NavigatorCubit]
typedef NavigatorBuilder<T extends NavigatorCubit> = T Function(
    BuildContext context);
