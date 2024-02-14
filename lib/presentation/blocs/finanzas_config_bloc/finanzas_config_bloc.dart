import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zen_organizer/config/domain/datasources/finanzas/config_datasource.dart';
import 'package:zen_organizer/config/infrastructure/models/finanzas/config_model.dart';

part 'finanzas_config_event.dart';
part 'finanzas_config_state.dart';

class FinanzasConfigBloc
    extends Bloc<FinanzasConfigEvent, FinanzasConfigState> {
  final ConfigDataSource dataSource;

  FinanzasConfigBloc(this.dataSource) : super(FinanzasConfigInitial()) {
    on<LoadConfig>(_onLoadConfig);
  }

  Future<void> _onLoadConfig(
      LoadConfig event, Emitter<FinanzasConfigState> emit) async {
    try {
      final config = await dataSource.getConfig();
      emit(FinanzasConfigLoaded(config));
    } catch (error) {
      // Maneja el error como prefieras
    }
  }
}
