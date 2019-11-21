import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../models/todo.dart';
import '../models/visibility_filter.dart';

@immutable
abstract class FilteredTodosState extends Equatable {
  get props => [];
}

class FilteredTodosLoadingState extends FilteredTodosState {
  @override
  String toString() => 'FilteredTodosLoadingState';
}

class FilteredTodosLoadedState extends FilteredTodosState {
  final List<Todo> filteredTodos;
  final VisibilityFilter activeFilter;

  FilteredTodosLoadedState(this.filteredTodos, this.activeFilter);

  get props => [filteredTodos, activeFilter];

  @override
  String toString() {
    return 'FilteredTodosLoaded { filteredTodos: $filteredTodos, activeFilter: $activeFilter }';
  }
}
