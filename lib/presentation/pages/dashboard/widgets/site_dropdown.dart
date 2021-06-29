import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../application/site/site_cubit.dart';
import '../../../../injectable/injection.dart';

class SiteDropDown extends StatelessWidget {
  const SiteDropDown({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.secondary;
    return BlocProvider(
      create: (context) => getIt<SiteCubit>(),
      child: BlocConsumer<SiteCubit, SiteState>(
        listener: (context, state) {},
        builder: (context, state) {
          return state.siteState.maybeWhen(
            success: (results) {
              final sites = results.asList();
              final selectedId = sites.firstWhere(
                (element) => element.isSelected,
                orElse: () => null,
              );
              return Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 24),
                child: DropdownButton<SimpleSite>(
                  iconEnabledColor: color,
                  isExpanded: true,
                  underline: const SizedBox(),
                  value: selectedId,
                  items: sites.map<DropdownMenuItem<SimpleSite>>((value) {
                    final textStyle = Theme.of(context).textTheme.bodyText1;
                    return DropdownMenuItem<SimpleSite>(
                      value: value,
                      child: Text(
                        value.name,
                        style: textStyle.copyWith(
                          color: value.isSelected ? color : textStyle.color,
                        ),
                      ),
                    );
                  }).toList(),
                  hint: const Text(
                    "Please choose a Site",
                  ),
                  onChanged: (SimpleSite value) {
                    context.read<SiteCubit>().setSite(value.id);
                  },
                ),
              );
            },
            loading: () => const CircularProgressIndicator(),
            orElse: () => const SizedBox(),
          );
        },
      ),
    );
  }
}
