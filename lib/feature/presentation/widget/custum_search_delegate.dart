import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_app/feature/domain/entities/person_entity.dart';
import 'package:rick_app/feature/presentation/bloc/search_bloc/search_bloc.dart';
import 'package:rick_app/feature/presentation/bloc/search_bloc/search_event.dart';
import 'package:rick_app/feature/presentation/bloc/search_bloc/search_state.dart';

import 'search_result.dart';

class CustomSearchDelegate extends SearchDelegate {
  CustomSearchDelegate() : super(searchFieldLabel: 'Search for characters...');

  final _suggestions = [
    'Rick',
    'Morthy',
    'Summer',
    'Beth',
    'Jerry',
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      onPressed: () {
        return close(context, null);
      },
      icon: Icon(Icons.arrow_back_ios_outlined),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    print('Вызов из делегата');
    var state = BlocProvider.of<PersonSearchBloc>(context, listen: false);
    state.add(SearchPersons(personQuery: query));

    return BlocBuilder<PersonSearchBloc, PersonSearchState>(
        builder: (context, state) {
      if (state is PersonSearchLoading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is PersonSearchLoaded) {
        final person = state.person;
        if (person.isEmpty) {
          return _showErrorText('No Characters with that name found');
        }
        return Container(
          child: ListView.builder(
            itemCount: person.isNotEmpty ? person.length : 0,
            itemBuilder: (context, index) {
              PersonEntity result = person[index];
              return SearchResult(personResult: result);
            },
          ),
        );
      } else if (state is PersonSearchError) {
        return _showErrorText(state.message);
      } else {
        return Center(
          child: Icon(Icons.now_wallpaper),
        );
      }
    });
  }

  Widget _showErrorText(String errorMessage) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Text(
          errorMessage,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.length > 0) {
      return Container();
    }

    return ListView.separated(
      padding: EdgeInsets.all(10),
      itemBuilder: ((context, index) {
        return Text(
          _suggestions[index],
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
          ),
        );
      }),
      separatorBuilder: (context, index) {
        return Divider();
      },
      itemCount: _suggestions.length,
    );
  }
}
