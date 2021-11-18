import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TQExpandableText extends StatefulWidget {
  const TQExpandableText(
      this.text, {
        this.expanded = false,
        this.maxLines = 3,
      });

  final String text;
  final bool expanded;
  final int maxLines;

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<TQExpandableText> {
  bool _expanded = false;
  late TapGestureRecognizer _tapGestureRecognizer;

  @override
  void initState() {
    super.initState();

    _expanded = widget.expanded;
    _tapGestureRecognizer = TapGestureRecognizer()..onTap = _toggleExpanded;
  }

  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() => _expanded = !_expanded);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle effectiveTextStyle = TextStyle(fontSize: 14,color: Color(0xfff5f5f5));

    final textAlign = TextAlign.start;

    final textDirection = Directionality.of(context);

    final textScaleFactor =  MediaQuery.textScaleFactorOf(context);

    final locale = Localizations.maybeLocaleOf(context);

    final linkText =
    _expanded ? ' 收起' : '展开';

    final link = TextSpan(
      text: _expanded ? '' : '\u2026 ',
      style: TextStyle(fontSize: 14,color: Color(0xff8C8C8C)),
      children: <TextSpan>[
        TextSpan(
          text: linkText,
          style: effectiveTextStyle.copyWith(
            color: Colors.black,
          ),
          recognizer: _tapGestureRecognizer,
        )
      ],
    );

    final text = TextSpan(
      text: widget.text,
      style: effectiveTextStyle,
    );

    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;

        TextPainter textPainter = TextPainter(
          text: link,
          textAlign: textAlign,
          textDirection: textDirection,
          textScaleFactor: textScaleFactor,
          maxLines: widget.maxLines,
          locale: locale,
        );
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final linkSize = textPainter.size;
        final linkWidth = textPainter.width;
        print(
            ' textPainter-min${textPainter.width} textPainter-max${textPainter.maxIntrinsicWidth}');
        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;
        // print(
        //     'linkSize-width:${linkSize.width} linkSize-height:${linkSize.height} textSize-width:${textSize.width} textSize-height:${textSize.height} linkWidth${linkWidth}');
        final position = textPainter.getPositionForOffset(Offset(
          textSize.width - linkWidth,
          textSize.height,
        ));
        final endOffset = textPainter.getOffsetBefore(position.offset);

        TextSpan textSpan;
        if (textPainter.didExceedMaxLines) {
          textSpan = TextSpan(
            style: effectiveTextStyle,
            text: _expanded ? widget.text : widget.text.substring(0, endOffset),
            children: <TextSpan>[
              link,
            ],
          );
        } else {
          textSpan = text;
        }

        return RichText(
          text: textSpan,
          softWrap: true,
          textDirection: textDirection,
          textAlign: textAlign,
          textScaleFactor: textScaleFactor,
          overflow: TextOverflow.clip,
        );
      },
    );
    return result;
  }
}