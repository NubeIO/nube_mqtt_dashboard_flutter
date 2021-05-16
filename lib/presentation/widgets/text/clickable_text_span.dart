import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ClickableTextSpan extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final TextSelection textSelection;
  final GlobalKey _textKey = GlobalKey();
  final InlineSpan text;
  final GestureTapCallback onTap;

  ClickableTextSpan({
    Key key,
    this.padding = const EdgeInsets.all(4.0),
    @required this.textSelection,
    @required this.text,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        RichText(key: _textKey, text: text),
        Positioned.fill(
          child: LayoutBuilder(
            builder: (context, _) => Stack(
              children: <Widget>[
                Positioned.fromRect(
                  rect: _getSelectionRect(),
                  child: InkWell(onTap: () => onTap()),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Rect _getSelectionRect() =>
      (_textKey.currentContext.findRenderObject() as RenderParagraph)
          .getBoxesForSelection(textSelection)
          .fold(
            null,
            (Rect previous, TextBox textBox) => Rect.fromLTRB(
              min(previous?.left ?? textBox.left,
                  textBox.left - padding.horizontal),
              min(previous?.top ?? textBox.top, textBox.top - padding.vertical),
              max(previous?.right ?? textBox.right,
                  textBox.right + padding.horizontal),
              max(previous?.bottom ?? textBox.bottom,
                  textBox.bottom + padding.vertical),
            ),
          ) ??
      Rect.zero;
}
