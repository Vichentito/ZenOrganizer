import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'finanzas_config_event.dart';
part 'finanzas_config_state.dart';

class FinanzasConfigBloc extends Bloc<FinanzasConfigEvent, FinanzasConfigState> {
  FinanzasConfigBloc() : super(FinanzasConfigInitial()) {
    on<FinanzasConfigEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
