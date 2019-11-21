import 'package:loco/extension.dart';
import 'package:loco/loco.dart';
import 'package:loco_example/features/todos/models/todo.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

import 'events/filtered_todos_event.dart';
import 'events/todos_event.dart';
import 'models/visibility_filter.dart';
import 'state/filtered_todos_state.dart';
import 'state/todos_state.dart';

List<Todo> _filterTodos(
  List<Todo> todos,
  VisibilityFilter filter,
) {
  return todos.where((todo) {
    if (filter == VisibilityFilter.all) {
      return true;
    } else if (filter == VisibilityFilter.active) {
      return !todo.complete;
    } else if (filter == VisibilityFilter.completed) {
      return todo.complete;
    }

    throw ArgumentError('Unknown filter type');
  }).toList();
}

class TodosExtension extends Extension {
  @override
  final String name = 'TodosExtension';

  // should be already available just use for DI
  final Api api = Api.instance;

  TodosRepository todosRepository;

  @override
  void onRegister() {
    onEvent<LoadTodosEvent>(_loadTodos);
    onEvent<Completable<AddTodoEvent>>(_addTodo);
    onEvent<UpdateTodoEvent>(_updateTodo);
    onEvent<DeleteTodoEvent>(_deleteTodo);
    onEvent<ToggleAllEvent>(_toggleAll);
    onEvent<ClearCompletedEvent>(_clearCompleted);

    // filtered todos
    onEvent<UpdateFilterEvent>(_updateFilter);
    onEvent<UpdateTodosEvent>(_todosUpdated);

    onState<TodosState>((todosState) {
      if (todosState is TodosLoadedState) {
        dispatch(UpdateTodosEvent(todosState.todos));
      }
    });

    super.onRegister();
  }

  @override
  Future<void> onInit() async {
    todosRepository = api.get<TodosRepository>();

    dispatch(LoadTodosEvent());
  }

  /*
  FilteredTodosState get initialState {
    return todosBloc.currentState is TodosLoaded
        ? FilteredTodosLoaded(
            (todosBloc.currentState as TodosLoaded).todos,
            VisibilityFilter.all,
          )
        : FilteredTodosLoading();
  }
  */

  // @override
  // TodosState get initialState => TodosLoading();

  void _loadTodos(LoadTodosEvent _) async {
    try {
      final todos = await todosRepository.loadTodos();

      setState<TodosState>(
        TodosLoadedState(
          todos.map(Todo.fromEntity).toList(),
        ),
      );
    } catch (_) {
      setState<TodosState>(
        TodosNotLoadedState(),
      );
    }
  }

  void _addTodo(Completable<AddTodoEvent> event) async {
    final currentState = getState<TodosState>();

    if (currentState is TodosLoadedState) {
      final List<Todo> updatedTodos = List.from(currentState.todos)
        ..add(event.event.todo);

      setState<TodosState>(TodosLoadedState(updatedTodos));

      _saveTodos(updatedTodos);

      event.complete();
    }
  }

  void _updateTodo(UpdateTodoEvent event) async {
    final currentState = getState<TodosState>();

    if (currentState is TodosLoadedState) {
      final List<Todo> updatedTodos = currentState.todos.map((todo) {
        return todo.id == event.updatedTodo.id ? event.updatedTodo : todo;
      }).toList();

      setState<TodosState>(TodosLoadedState(updatedTodos));

      _saveTodos(updatedTodos);
    }
  }

  void _deleteTodo(DeleteTodoEvent event) async {
    final currentState = getState<TodosState>();

    if (currentState is TodosLoadedState) {
      final updatedTodos =
          currentState.todos.where((todo) => todo.id != event.todo.id).toList();

      setState<TodosState>(
        TodosLoadedState(updatedTodos),
      );

      _saveTodos(updatedTodos);
    }
  }

  void _toggleAll(_) async {
    final currentState = getState<TodosState>();

    if (currentState is TodosLoadedState) {
      final allComplete = currentState.todos.every((todo) => todo.complete);

      final List<Todo> updatedTodos = currentState.todos
          .map((todo) => todo.copyWith(complete: !allComplete))
          .toList();

      setState<TodosState>(
        TodosLoadedState(updatedTodos),
      );

      _saveTodos(updatedTodos);
    }
  }

  void _clearCompleted(_) async {
    final currentState = getState<TodosState>();

    if (currentState is TodosLoadedState) {
      final List<Todo> updatedTodos =
          currentState.todos.where((todo) => !todo.complete).toList();

      setState<TodosState>(
        TodosLoadedState(updatedTodos),
      );

      _saveTodos(updatedTodos);
    }
  }

  Future _saveTodos(List<Todo> todos) {
    return todosRepository.saveTodos(
      todos.map((todo) => todo.toEntity()).toList(),
    );
  }

  /// Filtered TODOS
  void _updateFilter(
    UpdateFilterEvent event,
  ) {
    final todosState = getState<TodosState>();

    if (todosState is TodosLoadedState) {
      setState<FilteredTodosState>(
        FilteredTodosLoadedState(
          _filterTodos(
            todosState.todos,
            event.filter,
          ),
          event.filter,
        ),
      );
    }
  }

  void _todosUpdated(
    UpdateTodosEvent event,
  ) {
    final todosState = getState<TodosState>();

    if (todosState is TodosLoadedState) {
      final filteredTodosState = getState<FilteredTodosState>();

      final visibilityFilter = filteredTodosState is FilteredTodosLoadedState
          ? filteredTodosState.activeFilter
          : VisibilityFilter.all;

      setState<FilteredTodosState>(
        FilteredTodosLoadedState(
          _filterTodos(
            todosState.todos,
            visibilityFilter,
          ),
          visibilityFilter,
        ),
      );
    }
  }
}
