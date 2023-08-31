import 'package:equatable/equatable.dart';
import 'package:rick_app/feature/domain/entities/person_entity.dart';

abstract class PersonSearchState extends Equatable {
  const PersonSearchState();

  @override
  List<Object> get props => [];
}

class PersonEmpty extends PersonSearchState {}

class PersonSearchLoading extends PersonSearchState {}

class PersonSearchLoaded extends PersonSearchState {
  final List<PersonEntity> person;

  PersonSearchLoaded({required this.person});

  @override
  List<Object> get props => [person];
}

class PersonSearchError extends PersonSearchState {
  final String message;

  PersonSearchError({required this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}
