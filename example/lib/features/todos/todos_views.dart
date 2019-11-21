import 'package:loco/loco.dart';
import 'package:loco_example/components/tabs/app_tab.dart';
import 'package:loco_example/components/tabs/tab_event.dart';
import 'package:loco_example/components/tabs/tab_selector_view.dart';
import 'package:loco_example/features/stats/stats_view.dart';
import 'package:loco_example/features/todos/state/filtered_todos_state.dart';
import 'package:loco_example/features/todos/state/todos_state.dart';
import 'package:loco_example/features/todos/views/parts/add_edit_form.dart';
import 'package:loco_example/features/todos/views/parts/add_edit_form_button.dart';
import 'package:loco_example/features/todos/views/parts/filtered_todos_part.dart';
import 'package:loco_example/features/todos/views/parts/home_view_actions.dart';
import 'package:loco_example/features/todos/views/parts/home_view_add_todo_button.dart';
import 'package:loco_flutter/loco_flutter.dart';

import 'events/add_edit_event.dart';
import 'events/filtered_todos_event.dart';
import 'events/todos_event.dart';
import 'models/todo.dart';
import 'state/add_edit_state.dart';
import 'views/add_edit_view.dart';
import 'views/home_view.dart';
import 'views/parts/add_edit_form_title.dart';
import 'views/parts/details_part.dart';
import 'views/parts/home_view_title.dart';

class CloseAddEditFormEvent {}

class TodosViews extends ViewsExtension {
  @override
  final name = 'todos-views-extension';
  onRegister() {
    this.views
      ..registerView<AddEditScreen>(() => AddEditScreen())
      ..registerView<DetailsView>(
        (DetailsViewProps props) => DetailsView(props),
      )
      ..registerView<HomeView>(() => HomeView())
      ..registerView<StatsView>(() => StatsView())
      ..registerView<HomeViewTitle>(() => HomeViewTitle())
      ..registerView<FilteredTodosPart>(() => FilteredTodosPart())
      ..registerView<AddEditForm>(
          (AddEditFormProps props) => AddEditForm(props))
      ..registerView<AddEditFormTitle>(
        (AddEditFormTitleProps props) => AddEditFormTitle(props),
      )
      ..registerView<AddEditFormButton>(
        (AddEditFormButtonProps props) => AddEditFormButton(props),
      )
      ..registerView<HomeViewAddTodoButton>(
        () => HomeViewAddTodoButton(),
      )
      ..registerView<HomeViewActions>(
        (HomeViewActionsProps props) => HomeViewActions(props),
      )
      ..registerView<TabSelectorView>(
          (TabSelectorProps props) => TabSelectorView(props))
      ..onEvent<FormSavedEvent>(_formSaved)
      ..onEvent<EditTodoButtonPressedEvent>(_editTodoButtonPressed)

      // to be differentiated
      ..onEvent<LoadTodosEvent>(_loadTodos)
      ..onEvent<AddTodoEvent>(_addTodo)
      ..onEvent<UpdateTodoEvent>(_updateTodo)
      ..onEvent<DeleteTodoEvent>(_deleteTodo)
      ..onEvent<ToggleAllEvent>(_toggleAll)
      ..onEvent<ClearCompletedEvent>(_clearCompleted)
      ..onEvent<AddTodoButtonPressedEvent>(_addTodoButtonPressed)
      ..onEvent<AddEditFormButtonPressedEvent>(_addEditFormButtonPressed)
      ..onEvent<TodoItemTappedEvent>(_todoItemTapped)
      ..onEvent<UpdateTabEvent>(_updateTab)

      // filtered todos
      ..onEvent<UpdateFilterEvent>(_updateFilter)
      ..onEvent<UpdateTodosEvent>(_todosUpdated);

    onState<AppTab>((activeTab) {
      final body = activeTab == AppTab.todos
          ? views.getView<FilteredTodosPart>()
          : views.getView<StatsView>();

      // final slots = <String, ViewBase>{
      final slots = <String, dynamic>{
        'app-bar-title': views.getView<HomeViewTitle>(),
        'home-view-actions':
            views.getViewListWithProps<HomeViewActions, HomeViewActionsProps>(
          HomeViewActionsProps(
            filterButtonVisible: activeTab == AppTab.todos,
          ),
        ),
        'body': body,
        'home-view-add-todo-button': views.getView<HomeViewAddTodoButton>(),
        'home-view-bottom-navigation-bar':
            views.getViewWithProps<TabSelectorView, TabSelectorProps>(
          TabSelectorProps(
            activeTab: activeTab,
          ),
        ),
      };

      views.updateSlots<HomeView>(slots);

      views.setState<AppTab>(activeTab);
    });

    onState<TodosState>((todosState) {
      views.setState<TodosState>(todosState);
    });

    onState<FilteredTodosState>((filteredTodosState) {
      views.setState<FilteredTodosState>(filteredTodosState);
    });

    views.setSlot<HomeView>('body', views.getView<FilteredTodosPart>());
  }

  @override
  Future<void> onInit() {
    views
      ..initState<AppTab>(AppTab.todos)
      ..initState<AddEditState>(
        AddEditState(
          note: null,
          task: null,
        ),
      );

    return super.onInit();
  }

  void _updateTab(UpdateTabEvent event) {
    // tab update does not have to go to the todos extension
    dispatch(event);
  }

  void _todoItemTapped(TodoItemTappedEvent event) {
    dispatch(event);
  }

  void _addEditFormButtonPressed(AddEditFormButtonPressedEvent event) {
    views.dispatch(SaveAddEditFormEvent());
  }

  void _addTodoButtonPressed(AddTodoButtonPressedEvent event) {
    dispatch(event);
  }

  void _editTodoButtonPressed(EditTodoButtonPressedEvent event) {
    dispatch(event);
  }

  void _loadTodos(LoadTodosEvent event) {
    dispatch(event);
  }

  void _addTodo(AddTodoEvent event) {
    dispatch(event);
  }

  void _updateTodo(UpdateTodoEvent event) {
    dispatch(event);
  }

  void _deleteTodo(DeleteTodoEvent event) {
    dispatch(event);
  }

  void _toggleAll(ToggleAllEvent event) {
    dispatch(event);
  }

  void _clearCompleted(ClearCompletedEvent event) {
    dispatch(event);
  }

  void _updateFilter(UpdateFilterEvent event) {
    dispatch(event);
  }

  void _todosUpdated(UpdateTodosEvent event) {
    dispatch(event);
  }

  void _formSaved(FormSavedEvent event) {
    dispatch(
      Completable<AddTodoEvent>(
        AddTodoEvent(
          Todo(
            event.task,
            note: event.note,
          ),
        ),
        onComplete: () => dispatch(CloseAddEditFormEvent()),
      ),
    );
  }
}
