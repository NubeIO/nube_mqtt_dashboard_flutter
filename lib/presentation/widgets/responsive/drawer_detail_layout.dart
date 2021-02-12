import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../themes/nube_theme.dart';

typedef IndexedWidgetBuilder = Widget Function(BuildContext context, int index);

class DrawerDetailLayout extends StatelessWidget {
  final Widget _header;
  final Widget _footer;
  final Widget _builder;
  final int itemCount;
  final IndexedWidgetBuilder _itemBuilder;
  final PreferredSizeWidget _appBar;

  const DrawerDetailLayout({
    Key key,
    Widget header,
    Widget footer,
    @required Widget detailBuilder,
    @required this.itemCount,
    @required IndexedWidgetBuilder itemBuilder,
    PreferredSizeWidget appBar,
  })  : assert(detailBuilder != null),
        assert(itemCount != null),
        assert(itemBuilder != null),
        _header = header,
        _footer = footer,
        _builder = detailBuilder,
        _itemBuilder = itemBuilder,
        _appBar = appBar,
        super(key: key);

  Widget _buildDrawer(BuildContext context) {
    final theme = Theme.of(context).copyWith(
      textTheme: Theme.of(context).textTheme.apply(
            bodyColor: Theme.of(context).colorScheme.onSurface,
            displayColor: Theme.of(context).colorScheme.onSurface,
          ),
      iconTheme: IconTheme.of(context).copyWith(
        color: Colors.white,
      ),
      primaryColor: Theme.of(context).colorScheme.secondary,
    );
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Theme(
      data: theme,
      child: Column(
        children: [
          DrawerHeader(
              child: _header ??
                  Center(
                      child: Text(
                    'Nubeio',
                    style: theme.textTheme.headline1,
                  ))),
          if (itemCount > 0)
            Expanded(
              child: ListView.builder(
                itemCount: itemCount,
                itemBuilder: (context, position) {
                  return _itemBuilder(context, position);
                },
              ),
            )
          else
            Expanded(child: Container()),
          _footer ?? Container(),
          SizedBox(
            height: bottomPadding,
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _appBarBuilder(BuildContext context) {
    if (itemCount > 0) {
      return _appBar;
    } else {
      return AppBar(
        elevation: 4,
        backgroundColor: NubeTheme.backgroundOverlay(context),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarBuilder(context),
      drawer: Drawer(
        child: Container(
          child: _buildDrawer(context),
        ),
      ),
      body: _builder,
    );
  }
}
