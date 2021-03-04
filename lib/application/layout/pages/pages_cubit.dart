import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/layout/entities.dart';

part 'pages_cubit.freezed.dart';
part 'pages_state.dart';

@injectable
class PageCubit extends Cubit<PageState> {
  // ignore: unused_field
  final PageEntity _page;
  PageCubit._(this._page) : super(const PageState.initial());

  @factoryMethod
  // ignore: prefer_constructors_over_static_methods
  static PageCubit create(PageEntity page) => PageCubit._(page);
}
