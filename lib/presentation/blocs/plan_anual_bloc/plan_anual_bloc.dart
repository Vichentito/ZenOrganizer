import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'plan_anual_event.dart';
part 'plan_anual_state.dart';

class PlanAnualBloc extends Bloc<PlanAnualEvent, PlanAnualState> {
  PlanAnualBloc() : super(PlanAnualInitial()) {
    on<PlanAnualEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
