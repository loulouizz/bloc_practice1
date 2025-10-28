import 'dart:convert';
import 'dart:io';

import 'package:bloc_practice_1/bloc/bloc_actions.dart';
import 'package:bloc_practice_1/bloc/person.dart';
import 'package:bloc_practice_1/bloc/persons_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as devtools show log;

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: BlocProvider(
        create: (_) => PersonsBloc(),
        child: const HomePage(),
      ),
    );
  }
}



Future<Iterable<Person>> getPersons(String url) =>
    HttpClient()
        .getUrl(Uri.parse(url))
        .then((req) => req.close())
        .then(
          (response) =>
              response.transform(utf8.decoder).join(),
        )
        .then((str) => json.decode(str) as List<dynamic>)
        .then(
          (list) => list.map((e) => Person.fromJson(e)),
        );


extension Subscript<T> on Iterable<T> {
  T? operator [](int index) =>
      length > index ? elementAt(index) : null;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () {
                  context.read<PersonsBloc>().add(
                    LoadPersonsAction(
                      url: persons1Url,
                      loader: getPersons,
                    ),
                  );
                },
                child: Text('Load json #1'),
              ),
              TextButton(
                onPressed: () {
                  context.read<PersonsBloc>().add(
                    LoadPersonsAction(
                      url: persons2Url,
                      loader: getPersons,
                    ),
                  );
                },
                child: Text('Load json #2'),
              ),
            ],
          ),

          BlocBuilder<PersonsBloc, FetchResult?>(
            buildWhen: (previousResult, currentResult) {
              return previousResult?.persons !=
                  currentResult?.persons;
            },

            builder: (context, fetchResults) {
              fetchResults?.log();
              final persons = fetchResults?.persons;
              if (persons == null) {
                return const SizedBox();
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: persons.length,
                  itemBuilder: (context, index) {
                    final person = persons[index]!;
                    return ListTile(
                      title: Text(person.name),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
