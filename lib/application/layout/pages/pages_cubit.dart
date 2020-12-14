import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/layout/entities.dart';
import '../../../utils/logger/log.dart';

part 'pages_cubit.freezed.dart';
part 'pages_state.dart';

@injectable
class PageCubit extends Cubit<PageState> {
  final PageEntity _page;
  PageCubit._(this._page) : super(const PageState.initial()) {
    Log.i("Widgets Cubit created with $_page");
  }

  @factoryMethod
  // ignore: prefer_constructors_over_static_methods
  static PageCubit create(PageEntity page) => PageCubit._(page);

  @override
  Future<void> close() {
    Log.i("Widgets Cubit closed with $_page");
    return super.close();
  }
}
