# navigator_cubit

Simple, stateful navigation using [Cubit](https://bloclibrary.dev).

[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)
[![Gitmoji](https://img.shields.io/badge/gitmoji-%20😜%20😍-FFDD67.svg)](https://gitmoji.dev/)
[![Pub Version](https://img.shields.io/pub/v/navigator_cubit)](https://pub.dev/packages/navigator_cubit)
![GitHub](https://img.shields.io/github/license/netsells/navigator_cubit)
![GitHub Workflow Status](https://img.shields.io/github/workflow/status/netsells/navigator_cubit/Test)
[![Coverage Status](https://coveralls.io/repos/github/netsells/navigator_cubit/badge.svg?branch=master)](https://coveralls.io/github/navigator_cubit?branch=master)

## ❓ Why?

Not everyone needs an incredibly complex navigation API. But most people could definitely benefit from using a navigation system which supports nested Navigators, and declarative state.

`navigator_cubit` is intended to provide a simple navigation API which makes it easy to implement stateful, nested navigation. It **doesn't** support the Router API, or navigation via paths. But it can be argued that many apps don't need either of these things. Not including them makes the `navigator_cubit` package much simpler and easier to implement.

## 🚀 Installation

Install from [pub.dev](https://pub.dev/packages/navigator_cubit):

```yaml
dependencies:
  flutter_bloc: ^7.0.0
  navigator_cubit: ^1.0.0
```

## 🔨 Usage

### Step 1: Extend `NavigatorCubit`

Each navigator you use must have its own class of `NavigatorCubit`. This class provides basic methods like `push`, `pop`, `replace` etc.

A minimal implementation looks like this:

```dart
class HomeNavigatorCubit extends NavigatorCubit {
  HomeNavigatorCubit({required Page root}) : super(root: root);
}
```

You can add your own methods if you like for more specific navigation transactions:

```dart
class HomeNavigatorCubit extends NavigatorCubit {
  HomeNavigatorCubit({required Page root}) : super(root: root);

  void popTwice() {
    if (state.length > 2) {
      emit(state.take(state.length - 2).toList());
      return true;
    } else {
      return false;
    }
  }
}
```

_Note: the `state` of a `NavigatorCubit` is simply the lits of `Page`s._

### Step 2: Add a `CubitNavigator` widget to your tree

The `CubitNavigator` widget handles the navigation state. You can nest them too!

```dart
class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CubitNavigator<HomeNavigatorCubit>(
      createCubit: (context) => HomeNavigatorCubit(
        root: DashboardWidget(),
      ),
    );
  }
}
```

### Step 3: Access the navigator cubit in children

You have a couple of options for accessing the Navigator instance.

Option 1 is to use the `BlocProvider.of` method from the Bloc library:

```dart
final navigator = BlocProvider.of<HomeNavigatorCubit>(context);
```

Alternatively, for something a bit more readable:

```dart
final navigator = context.navigatorCubit<HomeNavigatorCubit>();
```

Either way, getting access to a `Navigator` instance allows you to perform navigation actions:

```dart
navigator.push(
  MaterialPage(child: DetailWidget()),
);

navigator.pop();

navigator.replace(
  MaterialPage(child: AnotherWidget()),
);
```

## 👨🏻‍💻 Authors

- [@ptrbrynt](https://www.github.com/ptrbrynt) at [Netsells](https://netsells.co.uk/)
