// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// 📦 Package imports:
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:navigator_cubit/navigator_cubit.dart';

class TestNavigatorCubit extends NavigatorCubit {
  TestNavigatorCubit(Page root) : super(root: root);
}

void main() {
  test('initial state contains only the root widget', () async {
    final cubit = TestNavigatorCubit(
      const MaterialPage(child: Scaffold(key: Key('child'))),
    );

    expect(
      cubit.state,
      isA<List<Page>>()
          .having(
            (l) => l.length,
            'length',
            equals(1),
          )
          .having(
            (l) => l.first,
            'first',
            isA<MaterialPage>().having(
              (p) => p.child,
              'child',
              isA<Scaffold>().having(
                (s) => s.key,
                'key',
                equals(const Key('child')),
              ),
            ),
          ),
    );
  });

  blocTest<TestNavigatorCubit, List<Page>>(
    'pushing a page adds it to the state',
    build: () => TestNavigatorCubit(
      const MaterialPage(child: Scaffold(key: Key('child1'))),
    ),
    act: (c) => c.push(
      const MaterialPage(child: Scaffold(key: Key('child2'))),
    ),
    expect: () => [
      isA<List<Page>>()
          .having(
            (l) => l.length,
            'length',
            equals(2),
          )
          .having(
            (l) => l.first,
            'first',
            isA<MaterialPage>().having(
              (p) => p.child,
              'child',
              isA<Scaffold>().having(
                (scaffold) => scaffold.key,
                'key',
                equals(const Key('child1')),
              ),
            ),
          )
          .having(
            (l) => l.last,
            'first',
            isA<MaterialPage>().having(
              (p) => p.child,
              'child',
              isA<Scaffold>().having(
                (scaffold) => scaffold.key,
                'key',
                equals(const Key('child2')),
              ),
            ),
          ),
    ],
  );

  blocTest<TestNavigatorCubit, List<Page>>(
    'popping when more than one page emits the state with the top page removed',
    build: () => TestNavigatorCubit(
      const MaterialPage(child: Scaffold(key: Key('child1'))),
    ),
    seed: () => [
      const MaterialPage(child: Scaffold(key: Key('child1'))),
      const MaterialPage(child: Scaffold(key: Key('child2'))),
    ],
    act: (c) => c.pop(),
    expect: () => [
      isA<List<Page>>()
          .having(
            (l) => l.length,
            'length',
            equals(1),
          )
          .having(
            (l) => l.first,
            'first',
            isA<MaterialPage>().having(
              (p) => p.child,
              'child',
              isA<Scaffold>().having(
                (scaffold) => scaffold.key,
                'key',
                equals(const Key('child1')),
              ),
            ),
          ),
    ],
  );

  blocTest<TestNavigatorCubit, List<Page>>(
    'popping with only one page has no effect',
    build: () => TestNavigatorCubit(
      const MaterialPage(child: Scaffold(key: Key('child1'))),
    ),
    act: (c) => c.pop(),
    expect: () => [],
  );

  blocTest<TestNavigatorCubit, List<Page>>(
    'replacing replaces the top-most page',
    build: () => TestNavigatorCubit(
      const MaterialPage(child: Scaffold(key: Key('child1'))),
    ),
    seed: () => [
      const MaterialPage(child: Scaffold(key: Key('child1'))),
      const MaterialPage(child: Scaffold(key: Key('child2'))),
    ],
    act: (c) => c.replace(
      const MaterialPage(child: Scaffold(key: Key('child3'))),
    ),
    expect: () => [
      isA<List<Page>>()
          .having(
            (l) => l.length,
            'length',
            equals(2),
          )
          .having(
            (l) => l.first,
            'first',
            isA<MaterialPage>().having(
              (p) => p.child,
              'child',
              isA<Scaffold>().having(
                (scaffold) => scaffold.key,
                'key',
                equals(const Key('child1')),
              ),
            ),
          )
          .having(
            (l) => l.last,
            'first',
            isA<MaterialPage>().having(
              (p) => p.child,
              'child',
              isA<Scaffold>().having(
                (scaffold) => scaffold.key,
                'key',
                equals(const Key('child3')),
              ),
            ),
          ),
    ],
  );
}
