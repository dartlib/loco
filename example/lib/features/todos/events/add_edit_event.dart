import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class AddEditEvent extends Equatable {
  @override
  get props => [];
}

class FormSavedEvent extends AddEditEvent {
  final String note;
  final String task;
  FormSavedEvent({
    this.note,
    this.task,
  });
}
