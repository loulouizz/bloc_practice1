import 'package:bloc_practice_1/bloc/bloc_actions.dart';
import 'package:bloc_practice_1/bloc/person.dart';
import 'package:bloc_practice_1/bloc/persons_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

const mockerPersons1 = [
  Person(age: 20, name: 'Foo'),
  Person(age: 30, name: 'Bar'),
];

const mockerPersons2 = [
  Person(age: 20, name: 'Foo'),
  Person(age: 30, name: 'Bar'),
];

Future<Iterable<Person>> mockGetPersons1(String _) =>
    Future.value(mockerPersons1);

Future<Iterable<Person>> mockGetPersons2(String _) =>
    Future.value(mockerPersons2);

void main() {
  group('Testing bloc', () {
    late PersonsBloc bloc;

    setUp(() {
      bloc = PersonsBloc();
    });

    blocTest<PersonsBloc, FetchResult?>(
      'Test initial state',
      build: () => bloc,
      verify: (bloc) {
        expect(bloc.state, null);
      },
    );

    // fetch mock data (persons1) and compare it with FetchResult
    blocTest<PersonsBloc, FetchResult?>(
      'Mock retrieving persons from first iterable',
      build: () => bloc,
      act: (bloc) {
        bloc.add(
          const LoadPersonsAction(
            url: 'useless_url_1',
            loader: mockGetPersons1,
          ),
        );

        bloc.add(
          const LoadPersonsAction(
            url: 'useless_url_1',
            loader: mockGetPersons1,
          ),
        );
      },
      expect: () =>[
        const FetchResult(
          persons: mockerPersons1,
          isRetrievedFromCache: false,
        ),

        const FetchResult(
          persons: mockerPersons1,
          isRetrievedFromCache: true,
        ),
      ],
    );

    blocTest<PersonsBloc, FetchResult?>(
      'Mock retrieving persons from second iterable',
      build: () => bloc,
      act: (bloc) {
        bloc.add(
          const LoadPersonsAction(
            url: 'useless_url_2',
            loader: mockGetPersons2,
          ),
        );

        bloc.add(
          const LoadPersonsAction(
            url: 'useless_url_2',
            loader: mockGetPersons2,
          ),
        );
      },
      expect: () => [
        // this result is received right after the first action above, so at this time, LoadPersonsAction has been called
        // only once
        const FetchResult(
          persons: mockerPersons2,
          isRetrievedFromCache: false,
        ),

        // here, LoadPersonsAction has been called for the 2nd time, so that's why the result is different
        const FetchResult(
          persons: mockerPersons2,
          isRetrievedFromCache: true,
        ),
      ],
    );
  });
}
