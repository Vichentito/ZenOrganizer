import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen_organizer/config/infrastructure/models/finanzas/config_model.dart';
import 'package:zen_organizer/presentation/providers/finanzas/config_provider.dart';
import 'package:zen_organizer/presentation/providers/finanzas/plan_anual_providers.dart';
import 'package:zen_organizer/presentation/widgets/shared/finanzas_drawer_menu.dart';

class ConfigView extends ConsumerStatefulWidget {
  const ConfigView({super.key});

  @override
  ConfigViewState createState() => ConfigViewState();
}

class ConfigViewState extends ConsumerState<ConfigView> {
  final _salaryController = TextEditingController();
  final _aguinaldoController = TextEditingController();
  final _aguinaldoPagadoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.read(configStateProvider.notifier).loadConfig();
    ref.read(aguinaldoStateProvider.notifier).loadAguinaldo();
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
    final configAsyncValue = ref.watch(configStateProvider).config;
    final aguinaldoAsyncValue = ref.watch(aguinaldoStateProvider).aguinaldo;

    configAsyncValue.whenData((data) {
      _salaryController.text = data.sueldo.toString();
    });

    aguinaldoAsyncValue.whenData((data) {
      _aguinaldoController.text = data.monto.toString();
      _aguinaldoPagadoController.text = data.estado;
    });

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
              ElevatedButton(
                onPressed: () {
                  final salary = double.tryParse(_salaryController.text);
                  final aguinaldo = double.tryParse(_aguinaldoController.text);
                  final aguinaldoPagado =
                      _aguinaldoPagadoController.text.toString();

                  if (salary != null && aguinaldo != null) {
                    final currentConfig =
                        ref.watch(configStateProvider).config.value;
                    final currentAguinaldo =
                        ref.watch(aguinaldoStateProvider).aguinaldo.value;

                    final updatedConfig = ConfigModel(
                      id: currentConfig!.id, // conserva el id actual
                      sueldo: salary,
                    );

                    final updatedAguinaldo = AguinaldoModel(
                      id: currentAguinaldo!.id,
                      monto: aguinaldo,
                      fecha: currentAguinaldo.fecha,
                      estado: aguinaldoPagado,
                    );

                    ref
                        .read(configStateProvider.notifier)
                        .updateConfigInFirestore(updatedConfig);
                    ref
                        .read(aguinaldoStateProvider.notifier)
                        .updateAguinaldoInFirestore(updatedAguinaldo);
                  }
                },
                child: const Text('Guardar'),
              ),
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
    ref.read(planAnualStateProvider.notifier).createFullYear();
  }
}
