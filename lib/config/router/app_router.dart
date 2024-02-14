import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zen_organizer/presentation/blocs/notes_bloc/notes_bloc.dart';
import 'package:zen_organizer/presentation/screens/screens.dart';
import 'package:zen_organizer/presentation/views/views.dart';

GoRouter createAppRouter(NotesBloc notesBloc) {
  return GoRouter(initialLocation: '/', routes: [
    ShellRoute(
      builder: (context, state, child) {
        return HomeScreen(childView: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) {
            return const HomeView();
          },
        ),
        GoRoute(
          path: '/notes',
          builder: (context, state) {
            return BlocProvider.value(
                value: notesBloc, child: const NotesView());
          },
          routes: [
            // Ruta de detalles de la nota
            GoRoute(
                path:
                    'details/:noteId', // Define un parámetro 'noteId' en la ruta
                builder: (context, state) {
                  final noteId = state.pathParameters['noteId']!;
                  return BlocProvider.value(
                      value: notesBloc, child: NoteDetailsView(noteId: noteId));
                }),
          ],
        ),
        GoRoute(
          path: '/finanzas',
          builder: (context, state) {
            return const QuincenasView();
          },
          routes: [
            GoRoute(
              path: 'gastosfijos',
              builder: (context, state) {
                return const GastosFijosView();
              },
            ),
            GoRoute(
              path: 'config',
              builder: (context, state) {
                return const ConfigView();
              },
            ),
            GoRoute(
              path: 'quincenaDetails',
              builder: (context, state) {
                final res = state.extra as Map<String, dynamic>;
                return QuincenaDetailView(
                  planAnualId: res['planAnualId'],
                  quincenaInicio: DateTime.parse(res['quincenaInicio']),
                  quincenaFin: DateTime.parse(res['quincenaFin']),
                );
              },
            ),
          ],
        )
      ],
    )
  ]);
}
