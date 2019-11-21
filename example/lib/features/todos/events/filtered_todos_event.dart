import 'package:equatable/equatable.dart';
import 'package:loco_example/features/todos/models/models.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FilteredTodosEvent extends Equatable {
  @override
  get props => [];
}

class UpdateFilterEvent extends FilteredTodosEvent {
  final VisibilityFilter filter;

  UpdateFilterEvent(this.filter);

  @override
  get props => [filter];

  @override
  String toString() => 'UpdateFilterEvent { filter: $filter }';
}

class UpdateTodosEvent extends FilteredTodosEvent {
  final List<Todo> todos;

  UpdateTodosEvent(this.todos);

  @override
  get props => [todos];

  @override
  String toString() => 'UpdateTodosEvent { todos: $todos }';
}
