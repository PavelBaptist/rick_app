import 'dart:convert';

import 'package:rick_app/core/error/exeption.dart';
import 'package:rick_app/feature/data/models/person_model.dart';
import 'package:http/http.dart' as http;

abstract class PersonRemoteDataSource {
  /// Calls the https://rickandmortyapi.com/api/character/?page=1 endpoint.
  ///
  /// Throws a [ServerExeption] for all error code.
  Future<List<PersonModel>> getAllPersons(int page);

  /// Calls the https://rickandmortyapi.com/api/character/?name=rick endpoint.
  ///
  /// Throws a [ServerExeption] for all error code.
  Future<List<PersonModel>> searchPerson(String query);
}

class PersonRemoteDataSourceImpl implements PersonRemoteDataSource {
  final http.Client client;

  PersonRemoteDataSourceImpl({required this.client});

  @override
  Future<List<PersonModel>> getAllPersons(int page) async {
    return _getPersonFrimUrl(
        'https://rickandmortyapi.com/api/character/?page=$page');
  }

  @override
  Future<List<PersonModel>> searchPerson(String query) async {
    return _getPersonFrimUrl(
        'https://rickandmortyapi.com/api/character/?name=$query');
  }

  Future<List<PersonModel>> _getPersonFrimUrl(String url) async {
    print(url);
    final response = await client
        .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final persons = json.decode(response.body);
      return (persons['results'] as List)
          .map((person) => PersonModel.fromJson(person))
          .toList();
    } else {
      throw ServerExeption();
    }
  }
}
