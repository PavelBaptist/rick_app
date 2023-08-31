import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_app/core/error/failure.dart';
import 'package:rick_app/feature/domain/usecases/search_person.dart';
import 'package:rick_app/feature/presentation/bloc/search_bloc/search_event.dart';
import 'package:rick_app/feature/presentation/bloc/search_bloc/search_state.dart';

const SERVER_FAILURE_MESSAGE = 'Server Failure';
const CACHED_FAILURE_MESSAGE = 'Cache Faiure';

class PersonSearchBloc extends Bloc<PersonSearchEvent, PersonSearchState> {
  final SearchPerson searchPerson;

  PersonSearchBloc({required this.searchPerson}) : super(PersonEmpty()) {
    on<SearchPersons>(_onSearchPersons);
  }

  void _onSearchPersons(
      SearchPersons event, Emitter<PersonSearchState> emit) async {
    emit(PersonSearchLoading());

    final failureOrPerson =
        await searchPerson(SearchPersonParams(query: event.personQuery));

    emit(failureOrPerson.fold(
        (failure) => PersonSearchError(message: _mapFailureToMessage(failure)),
        (person) => PersonSearchLoaded(person: person)));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CatheFailure:
        return CACHED_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
