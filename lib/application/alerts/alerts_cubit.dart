import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'alerts_cubit.freezed.dart';
part 'alerts_state.dart';

@injectable
class AlertsCubit extends Cubit<AlertsState> {
  AlertsCubit() : super(const AlertsState.initial());
}
