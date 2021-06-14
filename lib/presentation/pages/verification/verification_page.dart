import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/verification/verification_cubit.dart';
import '../../../domain/session/session_data_source_interface.dart';
import '../../../injectable/injection.dart';
import '../../routes/router.dart';
import '../../widgets/animated/illustration_verification.dart';
import '../../widgets/text/page_info_widget.dart';

class VerificationPage extends StatelessWidget {
  const VerificationPage({Key key}) : super(key: key);

  void _onStatusChange(BuildContext context, ProfileStatusType statusType) {
    if (statusType == ProfileStatusType.PROFILE_EXISTS) {
      ExtendedNavigator.of(context).pushAndRemoveUntil(
        Routes.connectPage,
        (route) => false,
        arguments: ConnectPageArguments(isInitalConfig: true),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => getIt<VerificationCubit>(),
        child: BlocListener<VerificationCubit, VerificationState>(
          listener: (context, VerificationState state) {
            _onStatusChange(context, state.status);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              AspectRatio(
                aspectRatio: 1,
                child: VerificationIllustration(
                  size: Size.infinite,
                ),
              ),
              PageInfoText(
                title: "Almost Done",
                subtitle:
                    "In order to make sure nobody has unauthorized access to data, someone from the admin needs to validate your request.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
