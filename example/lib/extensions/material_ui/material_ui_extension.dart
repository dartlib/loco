import 'package:flutter/material.dart';
import 'package:loco/loco.dart';
import 'package:loco_example/components/tabs/app_tab.dart';
import 'package:loco_example/components/tabs/tab_event.dart';
import 'package:loco_example/features/todos/events/todos_event.dart';
import 'package:loco_example/features/todos/todos_views.dart';
import 'package:loco_example/features/todos/views/add_edit_view.dart';
import 'package:loco_example/features/todos/views/home_view.dart';
import 'package:loco_example/features/todos/views/parts/add_edit_form.dart';
import 'package:loco_example/features/todos/views/parts/add_edit_form_button.dart';
import 'package:loco_example/features/todos/views/parts/add_edit_form_title.dart';
import 'package:loco_example/features/todos/views/parts/details_part.dart';
import 'package:loco_example/features/todos/views/parts/filtered_todos_part.dart';
import 'package:loco_flutter/loco_flutter.dart';

const kMaterialAppKey = '_MaterialAppKey_';

final GlobalKey<NavigatorState> kNavigatorKey = GlobalKey();

class AppState {}

class MaterialUIExtensionOptions {
  final String title;
  final Color color;
  final ThemeData theme;
  final ThemeData darkTheme;
  final ThemeMode themeMode;
  final Locale locale;
  final Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates;
  final List<Locale> supportedLocales;
  MaterialUIExtensionOptions({
    this.title = '',
    this.color,
    this.theme,
    this.darkTheme,
    this.themeMode = ThemeMode.system,
    this.locale,
    this.localizationsDelegates,
    this.supportedLocales = const <Locale>[
      Locale('en', 'US'),
    ],
  });
}

class MaterialUIExtension extends App<AppState> {
  final MaterialUIExtensionOptions options;

  MaterialUIExtension(this.options);

  NavigatorState get navigator => kNavigatorKey.currentState;

  @override
  final String name = 'MaterialUIExtension';

  _addTodoButtonPressed(AddTodoButtonPressedEvent event) {
    navigator.pushNamed(
      '/todos',
      arguments: {
        'isEditing': false,
      },
    );
  }

  void _editTodoButtonPressed(EditTodoButtonPressedEvent event) {
    navigator.pushNamed(
      '/todos',
      arguments: {
        'isEditing': true,
        'todo': event.todo,
      },
    );
  }

  _todoItemTapped(TodoItemTappedEvent event) {
    final removedTodo = navigator.pushNamed('/details_view', arguments: {
      'todo': event.todo,
    });

    if (removedTodo != null) {
      /* What to do about this? Could just make it a different state.
         Then call this code based on that state.
      Scaffold.of(context).showSnackBar(
        DeleteTodoSnackBar(
          key: LocoExampleKeys.snackbar,
          todo: todo,
          onUndo: () => dispatch(
            AddTodoEvent(todo),
          ),
          localizations: localizations,
        ),
      );
      */
    }
  }

  Route _homeRoute(_) {
    final todosViews = Api.instance.getExtension<TodosViews>();
    final view = todosViews.views.getView<HomeView>();

    // who set's the body for the FilteredTodoList?

    return buildRoute(view); // layoutWithSlots;
  }

  Route _detailsRoute(Map<String, dynamic> arguments) {
    final todosViews = Api.instance.getExtension<TodosViews>();
    final view =
        todosViews.views.getViewWithProps<DetailsView, DetailsViewProps>(
      DetailsViewProps(id: arguments['todo'].id),
    );

    return buildRoute(view);
    /*
    final removedTodo = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) {
        return DetailsView(
          DetailsViewProps(id: todo.id),
        );
      }),
    );
    // this is not implemented now...
    // pushNamed also just returns the route.popped?
    if (removedTodo != null) {
      Scaffold.of(context).showSnackBar(
        DeleteTodoSnackBar(
          key: LocoExampleKeys.snackbar,
          todo: todo,
          onUndo: () => dispatch(
            AddTodoEvent(todo),
          ),
          localizations: localizations,
        ),
      );
    }
     */
  }

  Route _todosRoute(Map<String, dynamic> arguments) {
    final todosViews = Api.instance.getExtension<TodosViews>();
    final isEditing = arguments['todo'] != null;

    // What about the tabs?
    // Starting to understand why everythings a widget
    // because create diverse types becomes a mess quickly.
    todosViews.views.setSlots<AddEditScreen>({
      'add-edit-form-title': todosViews.views
          .getViewWithProps<AddEditFormTitle, AddEditFormTitleProps>(
        AddEditFormTitleProps(
          isEditing: isEditing,
        ),
      ),
      'add-edit-form':
          todosViews.views.getViewWithProps<AddEditForm, AddEditFormProps>(
        AddEditFormProps(
          isEditing: isEditing,
          todo: arguments['todo'],
        ),
      ),
      'add-edit-form-button': todosViews.views
          .getViewWithProps<AddEditFormButton, AddEditFormButtonProps>(
        AddEditFormButtonProps(
          isEditing: isEditing,
          todo: arguments['todo'],
        ),
      ),
    });

    final view = todosViews.views.getView<AddEditScreen>();

    return buildRoute(view);
  }

  @override
  void onRegister() {
    onEvent<ApiInitializedEvent>(_runApp);
    onEvent<AddTodoButtonPressedEvent>(_addTodoButtonPressed);
    onEvent<EditTodoButtonPressedEvent>(_editTodoButtonPressed);
    onEvent<TodoItemTappedEvent>(_todoItemTapped);
    onEvent<UpdateTabEvent>(_updateTab);
    onEvent<CloseAddEditFormEvent>(_closeAddEditForm);

    initState<AppTab>(AppTab.todos);

    addRoute('/', _homeRoute);
    addRoute('/todos', _todosRoute);
    addRoute('/details_view', _detailsRoute);
  }

  _closeAddEditForm(CloseAddEditFormEvent event) {
    // ok this is bad, seems the way I'm listening to events is incorrect
    // kindof a wonder anything works at all
    // I'm indeed receiving a cumulation of events.
    // which explains the super weird behavior.
    // e.g. if I have closed/saved/added a todo with the form
    // each time it clicks it sends all historic events. causing this
    // function to be called multiple times.
    // super weird.
    // This is probably an event handler leak?
    // meaning the old handlers are never actually removed.
    // no it's just the form containing this leak..
    // I have an onEvent<> there which I do not dispose. (I hope)
    // I can first test it with another event.
    navigator.pop();
  }

  _updateTab(UpdateTabEvent event) {
    setState<AppTab>(event.tab);
  }

  void _runApp(ApiInitializedEvent event) {
    // final key = Key(kMaterialAppKey);

    runApp(
      MaterialApp(
        // key: key,
        navigatorKey: kNavigatorKey,
        onGenerateRoute: onGenerateRoute,
        // this.navigatorObservers = const <NavigatorObserver>[],
        builder: (BuildContext context, Widget child) {
          return child;
        },
        title: options.title,
        // this.onGenerateTitle,
        color: options.color,
        theme: options.theme,
        darkTheme: options.darkTheme,
        themeMode: options.themeMode,
        locale: options.locale,
        localizationsDelegates: options.localizationsDelegates,

        // this.localeListResolutionCallback,
        // this.localeResolutionCallback,

        supportedLocales: options.supportedLocales,
        debugShowMaterialGrid: false,
        showPerformanceOverlay: false,
        checkerboardRasterCacheImages: false,
        checkerboardOffscreenLayers: false,
        showSemanticsDebugger: false,
        debugShowCheckedModeBanner: true,
      ),
    );
  }
}
