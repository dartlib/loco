import 'package:equatable/equatable.dart';
import 'package:loco_example/features/todos/models/models.dart';
import 'package:meta/meta.dart';

@immutable
abstract class StatsEvent extends Equatable {}

class UpdateStatsEvent extends StatsEvent {
  final List<Todo> todos;

  UpdateStatsEvent(this.todos);

  get props => [todos];

  @override
  String toString() => 'UpdateStats { todos: $todos }';
}
