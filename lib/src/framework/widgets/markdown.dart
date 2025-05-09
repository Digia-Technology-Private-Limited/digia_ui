import 'package:flutter/material.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/widget/all.dart';

import '../base/virtual_leaf_stateless_widget.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../internal_widgets/internal_markdown.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';
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
          height: payload.evalExpr(props.hrHeight) ?? 2,
          color:
              payload.evalColorExpr(props.hrColor) ?? const Color(0xFFd0d7de),
        ),
        H1Config(
          style: payload.getTextStyle(props.h1TextStyle, null) ??
              const TextStyle(
                  fontSize: 32, height: 40 / 32, fontWeight: FontWeight.bold),
        ),
        H2Config(
          style: payload.getTextStyle(props.h2TextStyle, null) ??
              const TextStyle(
                  fontSize: 24, height: 30 / 24, fontWeight: FontWeight.bold),
        ),
        H3Config(
            style: payload.getTextStyle(props.h3TextStyle, null) ??
                const TextStyle(
                    fontSize: 20,
                    height: 25 / 20,
                    fontWeight: FontWeight.bold)),
        H4Config(
          style: payload.getTextStyle(props.h4TextStyle, null) ??
              const TextStyle(
                  fontSize: 16, height: 20 / 16, fontWeight: FontWeight.bold),
        ),
        H5Config(
            style: payload.getTextStyle(props.h5TextStyle, null) ??
                const TextStyle(
                    fontSize: 16,
                    height: 20 / 16,
                    fontWeight: FontWeight.bold)),
        H6Config(
            style: payload.getTextStyle(props.h6TextStyle, null) ??
                const TextStyle(
                    fontSize: 16,
                    height: 20 / 16,
                    fontWeight: FontWeight.bold)),
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
        PConfig(
            textStyle: payload.getTextStyle(props.pTextStyle) ??
                const TextStyle(fontSize: 16)),
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
        CodeConfig(
            style: payload.getTextStyle(props.codeTextStyle) ??
                const TextStyle(backgroundColor: Color(0xCCeff1f3))),
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
      ],
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
