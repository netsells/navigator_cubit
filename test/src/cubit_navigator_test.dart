// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:navigator_cubit/navigator_cubit.dart';

class TestNavigatorCubit extends NavigatorCubit {
  TestNavigatorCubit({required Page root}) : super(root: root);
}

class TestNestedNavigatorCubit extends NavigatorCubit {
  TestNestedNavigatorCubit({required Page root}) : super(root: root);
}

void main() {
  testWidgets('cubit navigator initially displays root page', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CubitNavigator<TestNavigatorCubit>(
          createCubit: (_) => TestNavigatorCubit(
            root: const MaterialPage(child: Scaffold(key: Key('child'))),
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('child')), findsOneWidget);
  });

  testWidgets(
    'pushing then popping displays correct widgets',
    (tester) async {
      final cubit = TestNavigatorCubit(
        root: const MaterialPage(child: Scaffold(key: Key('child1'))),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: CubitNavigator<TestNavigatorCubit>(
            createCubit: (_) => cubit,
          ),
        ),
      );

      cubit.push(
        MaterialPage(
          child: Scaffold(
            key: const Key('child2'),
            appBar: AppBar(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('child2')),
        findsOneWidget,
      );

      await tester.pageBack();

      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('child1')),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    '''replacing root widget displays correct widget and does not allow the user to go back''',
    (tester) async {
      final cubit = TestNavigatorCubit(
        root: const MaterialPage(child: Scaffold(key: Key('child1'))),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: CubitNavigator<TestNavigatorCubit>(
            createCubit: (_) => cubit,
          ),
        ),
      );

      cubit.replace(
        MaterialPage(
          child: Scaffold(
            key: const Key('child2'),
            appBar: AppBar(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('child2')),
        findsOneWidget,
      );

      expect(find.byType(BackButton), findsNothing);
    },
  );
}
