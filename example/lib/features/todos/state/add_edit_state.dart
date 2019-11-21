import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class AddEditState extends Equatable {
  final String task;
  final String note;
  AddEditState({
    this.task,
    this.note,
  });

  get props => [task, note];
}
