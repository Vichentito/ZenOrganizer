import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zen_organizer/config/domain/datasources/finanzas/config_datasource.dart';
import 'package:zen_organizer/config/infrastructure/datasources/finanzas/config_datasoruce.dart';
import 'package:zen_organizer/config/infrastructure/models/finanzas/config_model.dart';
import 'package:zen_organizer/presentation/blocs/finanzas_config_bloc/finanzas_config_bloc.dart';
import 'package:zen_organizer/presentation/widgets/shared/finanzas_drawer_menu.dart';

class ConfigView extends StatelessWidget {
  const ConfigView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Asegúrate de tener una instancia de tu fuente de datos.
    final ConfigDataSource dataSource = ConfigdbDatasource();
    final AguinaldoDataSource aguinaldoDataSource = AguinaldodbDatasource();

    return BlocProvider(
      create: (_) => FinanzasConfigBloc(dataSource, aguinaldoDataSource),
      child: const ConfigViewBody(),
    );
  }
}

class ConfigViewBody extends StatefulWidget {
  const ConfigViewBody({super.key});

  @override
  ConfigViewState createState() => ConfigViewState();
}

class ConfigViewState extends State<ConfigViewBody> {
  final _salaryController = TextEditingController();
  final _aguinaldoController = TextEditingController();
  final _aguinaldoPagadoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<FinanzasConfigBloc>().add(LoadConfig());
  }

  @override
  void dispose() {
    _salaryController.dispose();
    _aguinaldoController.dispose();
    _aguinaldoPagadoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = context.select((FinanzasConfigBloc bloc) =>
        (bloc.state is FinanzasConfigLoaded)
            ? (bloc.state as FinanzasConfigLoaded).config
            : null);
    final aguinaldo = context.select((FinanzasConfigBloc bloc) =>
        (bloc.state is FinanzasConfigLoaded)
            ? (bloc.state as FinanzasConfigLoaded).aguinaldo
            : null);

    if (config != null) {
      _salaryController.text = config.sueldo.toString();
    }

    if (aguinaldo != null) {
      _aguinaldoController.text = aguinaldo.monto.toString();
      _aguinaldoPagadoController.text = aguinaldo.estado;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _salaryController,
                decoration: const InputDecoration(labelText: 'Salario'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu salario';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _aguinaldoController,
                decoration: const InputDecoration(labelText: 'Aguinaldo'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu aguinaldo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _aguinaldoPagadoController,
                decoration:
                    const InputDecoration(labelText: 'Aguinaldo Pagado'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu aguinaldo pagado';
                  }
                  return null;
                },
              ),
              // ElevatedButton(
              // onPressed: () {
              //   final salary = double.tryParse(_salaryController.text);
              //   final aguinaldo = double.tryParse(_aguinaldoController.text);
              //   final aguinaldoPagado =
              //       _aguinaldoPagadoController.text.toString();

              // if (salary != null && aguinaldo != null) {
              //   final currentConfig =
              //       ref.watch(configStateProvider).config.value;
              //   final currentAguinaldo =
              //       ref.watch(aguinaldoStateProvider).aguinaldo.value;

              //   final updatedConfig = ConfigModel(
              //     id: currentConfig!.id, // conserva el id actual
              //     sueldo: salary,
              //   );

              //   final updatedAguinaldo = AguinaldoModel(
              //     id: currentAguinaldo!.id,
              //     monto: aguinaldo,
              //     fecha: currentAguinaldo.fecha,
              //     estado: aguinaldoPagado,
              //   );

              //   ref
              //       .read(configStateProvider.notifier)
              //       .updateConfigInFirestore(updatedConfig);
              //   ref
              //       .read(aguinaldoStateProvider.notifier)
              //       .updateAguinaldoInFirestore(updatedAguinaldo);
              // }
              // },
              // child: const Text('Guardar'),
              // ),
              ElevatedButton(
                onPressed: _generateAnnualPlan,
                child: const Text('Generar plan anual'),
              ),
            ],
          ),
        ),
      ),
      drawer: const FinanzasDrawerMenu(),
    );
  }

  void _generateAnnualPlan() {
    //ref.read(planAnualStateProvider.notifier).createFullYear();
  }
}
