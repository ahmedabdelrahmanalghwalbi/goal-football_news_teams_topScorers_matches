import 'package:flutter/material.dart';
import 'package:goolazo/views/utils/size_config.dart';

class SplashSkipButton extends StatefulWidget {
  SplashSkipButton({
    this.animationController,
    this.pageController,
    this.pages,
  });

  AnimationController animationController;
  PageController pageController;
  List pages;

  @override
  State<SplashSkipButton> createState() => _SplashSkipButtonState();
}

class _SplashSkipButtonState extends State<SplashSkipButton> {
  var _offset;
  @override
  void initState() {
    super.initState();
    _offset = Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(1.5, 0.0))
        .animate(widget.animationController);
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offset,
      child: Align(
        alignment: Alignment.topRight,
        child: TextButton(
          onPressed: () async {
            widget.pageController.animateToPage(
              widget.pages.length - 1,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Skip',
                  style: TextStyle(
                    fontFamily: 'AbrilFatface',
                    color: Colors.black54,
                    fontSize: getProportionateScreenWidth(16),
                    letterSpacing: 0.75,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  width: 4.0,
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black54,
                  size: 18.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
