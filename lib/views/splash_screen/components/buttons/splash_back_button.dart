import 'package:flutter/material.dart';
import 'package:goolazo/views/utils/size_config.dart';

class SplashBackButton extends StatefulWidget {
  SplashBackButton({
    this.pageController,
    this.animationController,
  });

  PageController pageController;
  AnimationController animationController;

  @override
  State<SplashBackButton> createState() => _SplashBackButtonState();
}

class _SplashBackButtonState extends State<SplashBackButton> {
  var _offset;

  @override
  void initState() {
    super.initState();
    _offset = Tween<Offset>(begin: Offset(-1.5, 0.0), end: Offset(0.0, 0.0))
        .animate(widget.animationController);
  }

  void _perviousSlide(PageController controller) {
    controller.previousPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOutSine,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offset,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.teal[600],
        ),
        onPressed: () {
          _perviousSlide(widget.pageController);
          print('Back');
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20.0,
              ),
              Text(
                'Back',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: getProportionateScreenWidth(16),
                  letterSpacing: 0.75,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
