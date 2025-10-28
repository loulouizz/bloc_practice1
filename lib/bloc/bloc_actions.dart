import 'package:bloc_practice_1/bloc/person.dart';
import 'package:flutter/material.dart';

const persons1Url =
    'http://10.0.2.2:5500/api/persons1.json';
    const persons2Url =
    'http://10.0.2.2:5500/api/persons2.json';

typedef PersonsLoader =
    Future<Iterable<Person>> Function(String url);

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonsAction implements LoadAction {
  final String url;
  final PersonsLoader loader;

  const LoadPersonsAction({
    required this.url,
    required this.loader,
  }) : super();
}
