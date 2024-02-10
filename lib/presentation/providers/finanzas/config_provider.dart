import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen_organizer/config/domain/repositories/finanzas/config_repository.dart';
import 'package:zen_organizer/config/infrastructure/models/finanzas/config_model.dart';
import 'package:zen_organizer/presentation/providers/finanzas/config_repository_provider.dart';

class ConfigState {
  final AsyncValue<ConfigModel> config;

  ConfigState({required this.config});
}

final configStateProvider = StateNotifierProvider<ConfigNotifier, ConfigState>(
  (ref) => ConfigNotifier(ref.read(configRepositoryProvider)),
);

class ConfigNotifier extends StateNotifier<ConfigState> {
  ConfigNotifier(this._repository)
      : super(ConfigState(config: const AsyncValue.loading()));

  final ConfigRepository _repository;

  Future<void> loadConfig() async {
    try {
      final config = await _repository.getConfig();
      state = ConfigState(config: AsyncValue.data(config));
    } catch (e, stackTrace) {
      state = ConfigState(config: AsyncValue.error(e, stackTrace));
    }
  }

  Future<void> updateConfigInFirestore(ConfigModel updatedConfig) async {
    try {
      await _repository.updateConfig(updatedConfig);
    } catch (e) {
      // Handle error
    }
  }
}

final aguinaldoStateProvider =
    StateNotifierProvider<AguinaldoNotifier, AguinaldoState>((ref) {
  return AguinaldoNotifier(ref.read(aguinaldoRepositoryProvider));
});

class AguinaldoState {
  final AsyncValue<AguinaldoModel> aguinaldo;

  AguinaldoState({required this.aguinaldo});
}

class AguinaldoNotifier extends StateNotifier<AguinaldoState> {
  AguinaldoNotifier(this._repository)
      : super(AguinaldoState(aguinaldo: const AsyncValue.loading()));

  final AguinaldoRepository _repository;

  Future<void> loadAguinaldo() async {
    try {
      final aguinaldo = await _repository.getAguinaldo();
      state = AguinaldoState(aguinaldo: AsyncValue.data(aguinaldo));
    } catch (e, stackTrace) {
      state = AguinaldoState(aguinaldo: AsyncValue.error(e, stackTrace));
    }
  }

  Future<void> updateAguinaldoInFirestore(
      AguinaldoModel updatedAguinaldo) async {
    try {
      await _repository.updateAguinaldo(updatedAguinaldo);
    } catch (e) {
      // Handle error
    }
  }
}
