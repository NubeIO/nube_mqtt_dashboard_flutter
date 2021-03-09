import 'package:flutter/material.dart';

import 'package:nube_mqtt_dashboard/domain/layout/entities.dart';
import 'package:kt_dart/collection.dart';

class VariableMenuItem extends StatelessWidget {
  final PageEntity page;
  final String selectedId;
  final Function(BuildContext context, PageEntity page) _onSelected;

  const VariableMenuItem({
    Key key,
    this.page,
    this.selectedId,
    Function(BuildContext context, PageEntity page) onSelected,
  })  : _onSelected = onSelected,
        super(key: key);

  Widget _buildItem(
    BuildContext context, {
    bool showTrailing = false,
  }) {
    return ListTile(
      selected: page.id == selectedId,
      trailing: showTrailing ? const Icon(Icons.expand_more) : null,
      onTap: () => _onSelected(
        context,
        page,
      ),
      title: Text(page.name),
    );
  }

  List<VariableMenuItem> _buildChildrens() {
    return page.pages
        .map(
          (page) => VariableMenuItem(
            page: page,
            selectedId: selectedId,
            onSelected: _onSelected,
          ),
        )
        .asList();
  }

  @override
  Widget build(BuildContext context) {
    if (page.pages.isEmpty()) {
      return _buildItem(context);
    } else {
      if (page.widgets.isEmpty()) {
        return ExpansionTile(
          initiallyExpanded: true,
          childrenPadding: const EdgeInsets.only(left: 16),
          title: Text(page.name),
          children: _buildChildrens(),
        );
      } else {
        return Column(
          children: [
            _buildItem(context),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                children: _buildChildrens(),
              ),
            )
          ],
        );
      }
    }
  }
}
