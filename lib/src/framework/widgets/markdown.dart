import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

import '../base/virtual_leaf_stateless_widget.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../internal_widgets/internal_markdown.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';
import '../utils/functional_util.dart';
import '../widget_props/markdown_props.dart';

class VWMarkDown extends VirtualLeafStatelessWidget<MarkDownProps> {
  VWMarkDown({
    required super.props,
    required super.commonProps,
    super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final data = payload.evalExpr(props.data) ?? '';
    final animationEnabled = payload.evalExpr(props.animationEnabled) ?? true;

    final MarkdownConfig config = MarkdownConfig(
      configs: [
        HrConfig(
          height:
              payload.evalExpr(props.hrHeight) ?? HrConfig.darkConfig.height,
          color:
              payload.evalColorExpr(props.hrColor) ?? HrConfig.darkConfig.color,
        ),
        payload
            .getTextStyle(props.h1TextStyle, null)
            ?.maybe((style) => H1Config(style: style)),
        payload
            .getTextStyle(props.h2TextStyle, null)
            ?.maybe((style) => H2Config(style: style)),
        payload
            .getTextStyle(props.h3TextStyle, null)
            ?.maybe((style) => H3Config(style: style)),
        payload
            .getTextStyle(props.h4TextStyle, null)
            ?.maybe((style) => H4Config(style: style)),
        payload
            .getTextStyle(props.h5TextStyle, null)
            ?.maybe((style) => H5Config(style: style)),
        payload
            .getTextStyle(props.h6TextStyle, null)
            ?.maybe((style) => H6Config(style: style)),
        PreConfig(
          padding: To.edgeInsets(props.prePadding),
          margin: To.edgeInsets(props.preMargin),
          decoration: BoxDecoration(
            borderRadius: To.borderRadius(props.preBorderRadius),
            color: payload.evalColorExpr(props.preColor) ?? Color(0xffeff1f3),
          ),
          textStyle: payload.getTextStyle(props.preTextStyle, null) ??
              const TextStyle(fontSize: 16),
          language: payload.evalExpr(props.preLanguage) ?? 'dart',
        ),
        LinkConfig(
          style: payload.getTextStyle(props.linkTextStyle, null) ??
              const TextStyle(
                  color: Color(0xff0969da),
                  decoration: TextDecoration.underline),
          onTap: (value) async {
            await payload.executeAction(props.onLinkTap,
                scopeContext: _createExprContext(value));
          },
        ),
        payload
            .getTextStyle(props.pTextStyle, null)
            ?.maybe((style) => PConfig(textStyle: style)),
        BlockquoteConfig(
          sideColor: payload.evalColorExpr(props.blockSideColor) ??
              const Color(0xffd0d7de),
          textColor: payload.evalColorExpr(props.blockSideColor) ??
              const Color(0xff57606a),
          sideWith: payload.evalExpr(props.blockSideWidth) ?? 4,
          padding: To.edgeInsets(props.blockPadding),
          margin: To.edgeInsets(props.blockMargin),
        ),
        ListConfig(
          marginLeft: payload.evalExpr(props.listMarginLeft) ?? 32,
          marginBottom: payload.evalExpr(props.listMarginBottom) ?? 4,
        ),
        payload
            .getTextStyle(props.codeTextStyle, null)
            ?.maybe((style) => CodeConfig(style: style)),
        TableConfig(
          // headerStyle: payload.getTextStyle(props.tableHeaderTextStyle, null) ??
          //     MarkdownConfig.defaultConfig.table.headerStyle,
          // bodyStyle: payload.getTextStyle(props.tableBodyTextStyle, null) ??
          //     MarkdownConfig.defaultConfig.table.bodyStyle,
          wrapper: (child) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: child,
            );
          },
        ),
        //added bcz rendering fails when we enabling animation
        CheckBoxConfig(
          builder: (bool? isChecked) {
            return Container(
              width: 16,
              height: 16,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(3),
                color: isChecked ?? false ? Colors.black : Colors.transparent,
              ),
              child: isChecked ?? false
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            );
          },
        )
      ].whereType<WidgetConfig>().toList(),
    );

    if (animationEnabled) {
      return AnimatedMarkdown(
        data: data,
        duration:
            Duration(milliseconds: payload.evalExpr(props.duration) ?? 20),
        shrinkWrap: props.shrinkWrap ?? true,
        selectable: props.selectable ?? true,
        config: config,
      );
    } else {
      // Render immediately without animation
      return MarkdownWidget(
        data: data,
        shrinkWrap: props.shrinkWrap ?? true,
        selectable: props.selectable ?? true,
        config: config,
      );
    }
  }

  ScopeContext _createExprContext(
    String url,
  ) {
    return DefaultScopeContext(variables: {
      'markdownUrl': url,
    });
  }
}
