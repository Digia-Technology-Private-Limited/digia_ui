import 'package:flutter/material.dart';

class DUIDivider extends StatefulWidget {
  const DUIDivider({super.key});

  @override
  State<DUIDivider> createState() => _DUIDividerState();
}

class _DUIDividerState extends State<DUIDivider> {
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_literals_to_create_immutables
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(
            height: 10,
            thickness: 15,
            indent: 10,
            endIndent: 15,
            color: Colors.black,
          ),
          SizedBox(
            height: 100,
            child: VerticalDivider(
              width: 100,
              thickness: 120,
              indent: 10,
              endIndent: 15,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
