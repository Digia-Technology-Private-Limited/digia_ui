import 'package:flutter/material.dart';

class InternalAnimatedBuilder extends StatefulWidget {
  final ValueNotifier? valueNotifier;
  final Widget Function(BuildContext, Object?) builder;
  const InternalAnimatedBuilder({
    super.key,
    this.valueNotifier,
    required this.builder,
  });

  @override
  State<InternalAnimatedBuilder> createState() =>
      _InternalAnimatedBuilderState();
}

class _InternalAnimatedBuilderState extends State<InternalAnimatedBuilder> {
  ValueNotifier<dynamic>? _valueNotifier;

  @override
  void initState() {
    super.initState();
    _valueNotifier = widget.valueNotifier;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _valueNotifier?.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _valueNotifier?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_valueNotifier == null) {
      return Text(
        'No Listenable found!!',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.red.shade500,
        ),
      );
    }

    return AnimatedBuilder(
        animation: _valueNotifier!,
        builder: (context, _) {
          return widget.builder(context, _valueNotifier!.value);
        });
  }
}
