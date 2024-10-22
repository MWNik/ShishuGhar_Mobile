import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:shishughar/style/styles.dart';

class AnimatedRollingSwitch extends StatefulWidget {
  final bool isOnlyUnsynched;
  final String title1;
  final String title2;
  // final String? title;
  void Function(bool)? onChange;

  AnimatedRollingSwitch(
      {super.key,
      required this.isOnlyUnsynched,
      this.onChange,
      required this.title1,
      required this.title2});

  @override
  State<AnimatedRollingSwitch> createState() => _AnimatedRollingSwitchState();
}

class _AnimatedRollingSwitchState extends State<AnimatedRollingSwitch> {
  String getLabel() {
    return widget.isOnlyUnsynched ? widget.title2 : widget.title1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedToggleSwitch<bool>.dual(
            current: widget.isOnlyUnsynched,
            animationCurve: Curves.bounceInOut,
            iconBuilder: (value) {
              return widget.isOnlyUnsynched
                  ? Icon(
                      Icons.check_circle_outline_outlined,
                      color: Colors.grey.shade800,
                    )
                  : Icon(
                      Icons.check_circle,
                      color: Color(0xff5979AA),
                    );
            },
            style: ToggleStyle(
              borderColor: Colors.black,
              indicatorColor: Colors.transparent,
            ),

            first: true,

            second: false,
            height: 30,

            borderWidth: 2.5,
            indicatorSize: Size(26, 30),
            // indicatorSize: Size.zero,
            spacing: 1,
            // indicatorAppearingBuilder: (context, value, indicator) {},
            indicatorTransition: ForegroundIndicatorTransition.rolling(),
            animationDuration: Duration(milliseconds: 800),
            onChanged: (value) {
              widget.onChange?.call(value ?? false);
              print('Switch Value --------> $value');
            },
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              getLabel(),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: Styles.black12700,
              softWrap: true,
            ),
          )
        ],
      ),
    );
  }
}
