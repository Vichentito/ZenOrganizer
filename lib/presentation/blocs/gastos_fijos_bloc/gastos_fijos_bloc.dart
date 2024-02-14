import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'gastos_fijos_event.dart';
part 'gastos_fijos_state.dart';

class GastosFijosBloc extends Bloc<GastosFijosEvent, GastosFijosState> {
  GastosFijosBloc() : super(GastosFijosInitial()) {
    on<GastosFijosEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
