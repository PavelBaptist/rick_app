import 'package:dartz/dartz.dart';
import 'package:rick_app/core/error/exeption.dart';
import 'package:rick_app/core/error/failure.dart';
import 'package:rick_app/core/platform/network_info.dart';
import 'package:rick_app/feature/data/datasources/person_local_data_source.dart';
import 'package:rick_app/feature/data/datasources/person_rempde_data_source.dart';
import 'package:rick_app/feature/data/models/person_model.dart';
import 'package:rick_app/feature/domain/entities/person_entity.dart';
import 'package:rick_app/feature/domain/repositories/person_repository.dart';

class PersonRepositoryImpl implements PersonRepository {
  final PersonRemoteDataSource remoteDataSource;
  final PersonLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PersonRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, List<PersonEntity>>> getAllPersons(int page) async {
    return _getPersons(() => remoteDataSource.getAllPersons(page));
  }

  @override
  Future<Either<Failure, List<PersonEntity>>> searchPerson(String query) async {
    return _getPersons(() => remoteDataSource.searchPerson(query));
  }

  Future<Either<Failure, List<PersonModel>>> _getPersons(
      Future<List<PersonModel>> Function() getPersons) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePerson = await getPersons();
        localDataSource.personsToCache(remotePerson);
        return Right(remotePerson);
      } on ServerExeption {
        return Left(ServerFailure());
      }
    } else {
      try {
        final locationPerson = await localDataSource.getLastPersonsFromCache();
        return Right(locationPerson);
      } on CacheExeption {
        return Left(CatheFailure());
      }
    }
  }
}
