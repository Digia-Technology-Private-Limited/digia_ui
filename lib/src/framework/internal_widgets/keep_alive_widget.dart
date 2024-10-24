import 'package:flutter/widgets.dart';

class KeepAliveWrapper extends StatefulWidget {
  const KeepAliveWrapper(
      {super.key, required this.child, this.keepTabsAlive = false});
  final Widget child;
  final bool? keepTabsAlive;

  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => widget.keepTabsAlive ?? false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
