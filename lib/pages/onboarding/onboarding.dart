import 'package:digia_ui/Utils/util_functions.dart';
import 'package:digia_ui/components/DUIText/dui_text.dart';
import 'package:digia_ui/pages/onboarding/onboarding_props.dart';
import 'package:flutter/material.dart';

class OnBoarding extends StatefulWidget {
  final OnBoardingProps props;

  const OnBoarding(this.props, {super.key}) : super();

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  late OnBoardingProps props;

  @override
  void initState() {
    props = widget.props;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(top: 60, left: 16, right: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: props.height,
                  width: props.width,
                  decoration: BoxDecoration(
                    color: toColor(props.color),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Center(
                    child: DUIText(props.logoText),
                  ),
                ),
                SizedBox(
                  height: resolveSpacing("sp-400"),
                ),
                DUIText(props.title),
                SizedBox(
                  height: resolveSpacing("sp-250"),
                ),
                DUIText(props.subTitle)
              ],
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 32),
              height: 50,
              width: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(38),
                color: toColor("primary"),
              ),
              child: Center(
                child: Text(
                  "Get Started",
                  style:
                      toTextStyle(styleClass: "f:button1;tc:light;ff:poppins;"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
