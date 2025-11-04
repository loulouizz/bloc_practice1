import 'package:bloc_practice_1/apis/login_api.dart';
import 'package:bloc_practice_1/apis/notes_api.dart';
import 'package:bloc_practice_1/bloc/actions.dart';
import 'package:bloc_practice_1/bloc/app_bloc.dart';
import 'package:bloc_practice_1/bloc/app_state.dart';
import 'package:bloc_practice_1/dialogs/generic_dialog.dart';
import 'package:bloc_practice_1/dialogs/loading_screen.dart';
import 'package:bloc_practice_1/models.dart';
import 'package:bloc_practice_1/strings.dart';
import 'package:bloc_practice_1/views/iterable_list_view.dart';
import 'package:bloc_practice_1/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(
        loginApi: LoginApi(),
        notesApi: NotesApi(),
      ),
      child: Scaffold(
        
        appBar: AppBar(title: const Text(homePage)),
        body: BlocConsumer<AppBloc, AppState>(
          // side effect -> loading indicator, etc
          listener: (context, appState) {
            // loading screen
            if (appState.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: pleaseWait,
              );
            } else {
              LoadingScreen.instance().hide();
            }

            // display possible errors
            final loginError = appState.loginError;
            if (loginError != null) {
              showGenericDialog(
                context: context,
                title: loginErrorDialogTitle,
                content: loginErrorDialogContent,
                optionsBuilder: () => {ok: true},
              );
            }

            // if we are logged in, but we have no fetched notes, fetch them now
            if (appState.isLoading == false &&
                appState.loginError == null &&
                appState.loginHandle ==
                    const LoginHandle.fooBar() &&
                appState.fetchedNotes == null) {
              context.read<AppBloc>().add(
                const LoadNotesAction(),
              );
            }
          },
          // dictate what will be displayed on the screen inside the widget tree
          builder: (context, appState) {
            final notes = appState.fetchedNotes;
            if (notes == null) {
              return LoginView(
                onLoginTapped: (email, password) {
                  context.read<AppBloc>().add(
                    LoginAction(
                      email: email,
                      password: password,
                    ),
                  );
                },
              );
            } else {
              return notes.toListView();
            }
          },
        ),
      ),
    );
  }
}
