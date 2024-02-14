import 'package:zen_organizer/config/domain/datasources/notes_datasource.dart';
import 'package:zen_organizer/config/infrastructure/datasources/notes_datasource.dart';
import 'package:zen_organizer/presentation/blocs/notes_bloc/notes_bloc.dart';

import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:zen_organizer/config/router/app_router.dart';
import 'package:zen_organizer/config/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  final NotesDataSource dataSource = NotesdbDatasource();
  final NotesBloc notesBloc = NotesBloc(dataSource);
  runApp(ProviderScope(
    child: MyApp(
      notesBloc: notesBloc,
    ),
  ));
}

class MyApp extends StatelessWidget {
  final NotesBloc notesBloc;

  const MyApp({Key? key, required this.notesBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        routerConfig: createAppRouter(notesBloc),
        debugShowCheckedModeBanner: false,
        theme: AppTheme().getTheme(),
        title: 'ZenOrginizer',
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: const <Locale>[
          Locale('es', 'ES'),
        ]);
  }
}
