import 'package:flutter/material.dart';

typedef DUIIconDataProvider = IconData Function(Map<String, dynamic> map);
typedef DUIImageProviderFn = ImageProvider Function(String identifier);
typedef DUITextStyleBuilder = TextStyle Function(String identifier);
typedef DUIExternalFunctionHandler = Function(
    BuildContext context, String methodId, Map<String, Object?> args);
