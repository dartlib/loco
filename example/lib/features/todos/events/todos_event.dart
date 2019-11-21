import 'package:equatable/equatable.dart';
import 'package:loco_example/features/todos/models/models.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TodosEvent extends Equatable {
  @override
  get props => [];
}

class LoadTodosEvent extends TodosEvent {
  @override
  String toString() => 'LoadTodosEvent';
}

class AddTodoEvent extends TodosEvent {
  final Todo todo;

  AddTodoEvent(this.todo);

  @override
  get props => [todo];

  @override
  String toString() => 'AddTodoEvent { todo: $todo }';
}

class UpdateTodoEvent extends TodosEvent {
  final Todo updatedTodo;

  UpdateTodoEvent(this.updatedTodo);

  @override
  get props => [updatedTodo];

  @override
  String toString() => 'UpdateTodoEvent { updatedTodo: $updatedTodo }';
}

class DeleteTodoEvent extends TodosEvent {
  final Todo todo;

  DeleteTodoEvent(this.todo);

  @override
  get props => [todo];

  @override
  String toString() => 'DeleteTodoEvent { todo: $todo }';
}

class ClearCompletedEvent extends TodosEvent {
  @override
  String toString() => 'ClearCompletedEvent';
}

class ToggleAllEvent extends TodosEvent {
  @override
  String toString() => 'ToggleAllEvent';
}

class AddTodoButtonPressedEvent extends TodosEvent {
  @override
  String toString() => 'AddTodoButtonPressedEvent';
}
