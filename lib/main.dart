import 'package:zen_organizer/config/datasources/finanzas/config_datasource.dart';
import 'package:zen_organizer/config/datasources/finanzas/gasto_fijo_item_datasource.dart';
import 'package:zen_organizer/config/datasources/finanzas/plan_anual_datasource.dart';
import 'package:zen_organizer/config/datasources/notes_datasource.dart';
import 'package:zen_organizer/config/infrastructure/datasources/finanzas/config_datasoruce.dart';
import 'package:zen_organizer/config/infrastructure/datasources/finanzas/gasto_fijo_item_datasource.dart';
import 'package:zen_organizer/config/infrastructure/datasources/finanzas/plan_anual_datasource.dart';
import 'package:zen_organizer/config/infrastructure/datasources/notes_datasource.dart';
import 'package:zen_organizer/presentation/blocs/finanzas_config_bloc/finanzas_config_bloc.dart';
import 'package:zen_organizer/presentation/blocs/gastos_fijos_bloc/gastos_fijos_bloc.dart';
import 'package:zen_organizer/presentation/blocs/notes_bloc/notes_bloc.dart';
import 'package:zen_organizer/presentation/blocs/plan_anual_bloc/plan_anual_bloc.dart';

import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  final ConfigDataSource configDataSource = ConfigdbDatasource();
  final AguinaldoDataSource aguinaldoDataSource = AguinaldodbDatasource();
  final GastoFijoDataSource gastoFijoDataSource = GastoFijodbDatasource();
  final PlanAnualDataSource planAnualDataSource = PlanAnualdbDatasource();

  final NotesBloc notesBloc = NotesBloc(dataSource);
  final FinanzasConfigBloc finanzasConfigBloc =
      FinanzasConfigBloc(configDataSource, aguinaldoDataSource);
  final GastosFijosBloc gastosFijosBloc = GastosFijosBloc(gastoFijoDataSource);
  final PlanAnualBloc planAnualBloc = PlanAnualBloc(planAnualDataSource);

  runApp(MyApp(
    notesBloc: notesBloc,
    finanzasConfigBloc: finanzasConfigBloc,
    gastosFijosBloc: gastosFijosBloc,
    planAnualBloc: planAnualBloc,
  ));
}

class MyApp extends StatelessWidget {
  final NotesBloc notesBloc;
  final FinanzasConfigBloc finanzasConfigBloc;
  final GastosFijosBloc gastosFijosBloc;
  final PlanAnualBloc planAnualBloc;

  const MyApp(
      {Key? key,
      required this.notesBloc,
      required this.finanzasConfigBloc,
      required this.gastosFijosBloc,
      required this.planAnualBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        routerConfig: createAppRouter(
            notesBloc, finanzasConfigBloc, gastosFijosBloc, planAnualBloc),
        debugShowCheckedModeBanner: false,
        theme: AppTheme().getTheme(),
        title: 'ZenOrginizer',
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: const <Locale>[
          Locale('es', 'ES'),
        ]);
  }
}
