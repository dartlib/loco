import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class StatsState extends Equatable {}

class StatsLoadingState extends StatsState {
  @override
  get props => [];

  @override
  String toString() => 'StatsLoading';
}

class StatsLoadedState extends StatsState {
  final int numActive;
  final int numCompleted;

  StatsLoadedState(this.numActive, this.numCompleted);

  @override
  get props => [numActive, numCompleted];

  @override
  String toString() {
    return 'StatsLoaded { numActive: $numActive, numCompleted: $numCompleted }';
  }
}
