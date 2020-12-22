import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../themes/nube_theme.dart';
import 'padding.dart';
import 'screen_type_layout.dart';

typedef IndexedWidgetBuilder = Widget Function(BuildContext context, int index,
    bool selected, void Function(int index) onTapCallback);
typedef DetailWidgetBuilder = Widget Function(
  BuildContext context,
  int selectedIndex,
);

PreferredSizeWidget _defaultAppbar(BuildContext context, int key) => AppBar();

class DrawerDetailLayout extends StatefulWidget {
  final Widget _header;
  final Widget _footer;
  final DetailWidgetBuilder _builder;
  final int itemCount;
  final IndexedWidgetBuilder _itemBuilder;
  final void Function(int key) _onSelectedChange;
  final PreferredSizeWidget Function(BuildContext context, int key)
      _appBarBuilder;

  const DrawerDetailLayout({
    Key key,
    Widget header,
    Widget footer,
    @required DetailWidgetBuilder detailBuilder,
    @required this.itemCount,
    @required IndexedWidgetBuilder itemBuilder,
    Function(int index) onSelectedChange,
    PreferredSizeWidget Function(BuildContext context, int index)
        appBarBuilder = _defaultAppbar,
  })  : assert(detailBuilder != null),
        assert(itemCount != null),
        assert(itemBuilder != null),
        _header = header,
        _footer = footer,
        _builder = detailBuilder,
        _itemBuilder = itemBuilder,
        _onSelectedChange = onSelectedChange,
        _appBarBuilder = appBarBuilder,
        super(key: key);

  @override
  _DrawerDetailLayoutState createState() => _DrawerDetailLayoutState();
}

class _DrawerDetailLayoutState extends State<DrawerDetailLayout> {
  int selectedIndex = -1;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _fixIndex();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(widget);
    if (widget.itemCount > 0 && selectedIndex == -1) {
      _fixIndex();
    }
  }

  void _fixIndex() {
    setState(() {
      selectedIndex = widget.itemCount > 0 ? 0 : -1;
    });
  }

  void _onSelected(int selectedIndex) {
    if (this.selectedIndex == selectedIndex) return;
    setState(() {
      this.selectedIndex = selectedIndex;
    });
    if (widget._onSelectedChange != null) {
      widget._onSelectedChange(selectedIndex);
    }
  }

  Widget _buildDrawer(BuildContext context, bool isMobile) {
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
                  return widget._itemBuilder(
                    context,
                    position,
                    selectedIndex == position,
                    (index) {
                      _onSelected(index);
                      if (isMobile) {
                        Navigator.pop(context);
                      }
                    },
                  );
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

  Widget _builder(BuildContext context, int selectedIndex) {
    if (widget.itemCount > 0) {
      return widget._builder(context, selectedIndex);
    } else {
      return Container();
    }
  }

  PreferredSizeWidget _appBarBuilder(BuildContext context, int selectedIndex) {
    if (widget.itemCount > 0) {
      return widget._appBarBuilder(context, selectedIndex);
    } else {
      return AppBar(
        elevation: 4,
        backgroundColor: NubeTheme.backgroundOverlay(context),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: Scaffold(
        key: _scaffoldKey,
        appBar: _appBarBuilder(context, selectedIndex),
        drawer: Drawer(
          child: Container(
            child: _buildDrawer(context, true),
          ),
        ),
        body: _builder(context, selectedIndex),
      ),
      tablet: Stack(
        children: [
          Row(children: [
            SizedBox(
              width: ResponsiveSize.MASTER_PANEL_WIDTH,
            ),
            Expanded(
              child: Scaffold(
                key: _scaffoldKey,
                appBar: widget._appBarBuilder != null
                    ? _appBarBuilder(context, selectedIndex)
                    : AppBar(),
                body: _builder(context, selectedIndex),
              ),
            ),
          ]),
          SizedBox(
            width: ResponsiveSize.MASTER_PANEL_WIDTH,
            child: Material(
              elevation: 16,
              shape: const RoundedRectangleBorder(),
              child: _buildDrawer(context, false),
            ),
          )
        ],
      ),
    );
  }
}
