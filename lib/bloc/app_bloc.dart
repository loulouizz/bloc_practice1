import 'package:bloc/bloc.dart';
import 'package:bloc_practice_1/apis/login_api.dart';
import 'package:bloc_practice_1/apis/notes_api.dart';
import 'package:bloc_practice_1/bloc/actions.dart';
import 'package:bloc_practice_1/bloc/app_state.dart';
import 'package:bloc_practice_1/models.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  final LoginApiProtocol loginApi;
  final NotesApiProtocol notesApi;

  AppBloc({required this.loginApi, required this.notesApi})
    : super(const AppState.empty()) {
    on<LoginAction>((event, emit) async {
      //start loading
      emit(
        AppState(
          isLoading: true,
          loginError: null,
          loginHandle: null,
          fetchedNotes: null,
        ),
      );

      //call login
      final loginHandle = await loginApi.login(
        email: event.email,
        password: event.password,
      );

      emit(
        AppState(
          isLoading: false,
          loginError: loginHandle == null
              ? LoginErrors.invalidHandle
              : null,
          loginHandle: loginHandle,
          fetchedNotes: null,
        ),
      );
    });

    on<LoadNotesAction>((event, emit) async {
      // load true
      emit(
        AppState(
          isLoading: true,
          loginError: state.loginError,
          loginHandle: state.loginHandle,
          fetchedNotes: null,
        ),
      );

      // load notes
      final loginHandle = state.loginHandle;
      if (loginHandle != const LoginHandle.fooBar()) {
        // invalid login handle, cannot fetch notes
        emit(
          AppState(
            isLoading: false,
            loginError: LoginErrors.invalidHandle,
            loginHandle: loginHandle,
            fetchedNotes: null,
          ),
        );
      } else {
        // valid login handle
        final notes = await notesApi.getNotes(
          loginHandle: loginHandle!,
        );

        emit(
          AppState(
            isLoading: false,
            loginError: null,
            loginHandle: loginHandle,
            fetchedNotes: notes,
          ),
        );
      }
    });
  }
}

class CubitTeste extends Cubit<String> {
  CubitTeste() : super('initial state da silva');
}
