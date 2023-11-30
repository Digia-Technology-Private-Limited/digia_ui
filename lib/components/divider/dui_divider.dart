

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
    return Scaffold(
      body: Column(
        children: [
          Divider(
            indent: 10,
            endIndent: 15,
            // height: ,
          ),
          VerticalDivider(
            indent: 10,
            endIndent: 15,
          ),
        ],
      ),
    );
  }
}