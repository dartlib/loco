import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../models/todo.dart';

@immutable
abstract class TodosState extends Equatable {
  get props => [];
}

class TodosLoadingState extends TodosState {
  @override
  String toString() => 'TodosLoading';
}

class TodosLoadedState extends TodosState {
  final List<Todo> todos;

  TodosLoadedState([this.todos = const []]);

  @override
  get props => [todos];

  @override
  String toString() => 'TodosLoaded { todos: $todos }';
}

class TodosNotLoadedState extends TodosState {
  @override
  String toString() => 'TodosNotLoaded';
}
