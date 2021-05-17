import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../themes/nube_theme.dart';

typedef IndexedWidgetBuilder = Widget Function(BuildContext context, int index);

class DrawerDetailLayout extends StatefulWidget {
  final Widget _header;
  final Widget _footer;
  final Widget _builder;
  final int itemCount;
  final IndexedWidgetBuilder _itemBuilder;
  final PreferredSizeWidget Function(BuildContext context, ScaffoldState state)
      _appBarBuilder;
  final PreferredSizeWidget defaultAppBar;

  const DrawerDetailLayout({
    Key key,
    Widget header,
    Widget footer,
    @required Widget detailBuilder,
    @required this.itemCount,
    @required IndexedWidgetBuilder itemBuilder,
    PreferredSizeWidget Function(BuildContext context, ScaffoldState state)
        appBarBuilder,
    this.defaultAppBar,
  })  : assert(detailBuilder != null),
        assert(itemCount != null),
        assert(itemBuilder != null),
        _header = header,
        _footer = footer,
        _builder = detailBuilder,
        _itemBuilder = itemBuilder,
        _appBarBuilder = appBarBuilder,
        super(key: key);

  @override
  _DrawerDetailLayoutState createState() => _DrawerDetailLayoutState();
}

class _DrawerDetailLayoutState extends State<DrawerDetailLayout> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
              child: widget._header ??
                  Center(
                      child: Text(
                    'Nubeio',
                    style: theme.textTheme.headline1,
                  ))),
          if (widget.itemCount > 0)
            Expanded(
              child: ListView.builder(
                itemCount: widget.itemCount,
                itemBuilder: (context, position) {
                  return widget._itemBuilder(context, position);
                },
              ),
            )
          else
            Expanded(child: Container()),
          widget._footer ?? Container(),
          SizedBox(
            height: bottomPadding,
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ScaffoldState state) {
    if (widget.itemCount > 0) {
      return widget._appBarBuilder(context, state);
    } else {
      return widget.defaultAppBar ??
          AppBar(
            elevation: 4,
            backgroundColor: NubeTheme.backgroundOverlay(context),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(context, _scaffoldKey.currentState),
      drawer: Drawer(
        child: Container(
          child: _buildDrawer(context),
        ),
      ),
      body: widget._builder,
    );
  }
}
