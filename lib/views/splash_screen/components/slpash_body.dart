import 'package:flutter/material.dart';
import 'package:goolazo/views/utils/size_config.dart';

import '../components/buttons/splash_back_button.dart';
import '../components/buttons/splash_next_button.dart';
import '../components/buttons/splash_skip_button.dart';
import 'buttons/splash_get_started_button.dart';
import 'splash_main_content.dart';

class SplashBody extends StatefulWidget {
  @override
  _SplashBodyState createState() => _SplashBodyState();
}

class _SplashBodyState extends State<SplashBody> with TickerProviderStateMixin {
  PageController _pageController;
  AnimationController _skipButtonAnimationController;
  AnimationController _backButtonAnimationController;
  int _currentPageIndex = 0;

  final List<Map<String, String>> _splashData = const [
    {
      "image": "assets/splash_screen/standings.png",
      "title": "League Standings",
      "description": " you can always find leagues standings"
    },
    {
      "image": "assets/splash_screen/players2.png",
      "title": "League Teams",
      "description": "you can display league teams"
    },
    {
      "image": "assets/splash_screen/toopscorersgold.png",
      "title": "League Top Scorers",
      "description": "you can know the top scorer in each league"
    },
    {
      "image": "assets/splash_screen/vs.png",
      "title": "League Matches",
      "description":
          "you can display live, scheduled, finished matches in each league with each match result"
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _skipButtonAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _backButtonAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  }

  void _handleButtonsAnimationsDuringPageTransition(int pageIndex) {
    setState(() {
      _currentPageIndex = pageIndex;
    });

    print('current page index: $_currentPageIndex');

    //  Start buttons animation according to slide change
    switch (_currentPageIndex) {
      case 0:
        _backButtonAnimationController.reverse();
        break;
      case 1:
        _backButtonAnimationController.forward();
        break;
      case 2:
        _backButtonAnimationController.forward();
        _skipButtonAnimationController.reverse();
        break;
      case 3:
        _backButtonAnimationController.reverse();
        _skipButtonAnimationController.forward();
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _skipButtonAnimationController.dispose();
    _backButtonAnimationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            SplashSkipButton(
              pageController: _pageController,
              animationController: _skipButtonAnimationController,
              pages: _splashData,
            ),
            //  PageView slides.
            Expanded(
              flex: 4,
              child: PageView.builder(
                physics: _currentPageIndex == _splashData.length - 1
                    ? const NeverScrollableScrollPhysics()
                    : const AlwaysScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: _handleButtonsAnimationsDuringPageTransition,
                itemCount: _splashData.length,
                itemBuilder: (context, index) => SplashMainContent(
                  image: _splashData[index]["image"],
                  title: _splashData[index]["title"],
                  description: _splashData[index]["description"],
                ),
              ),
            ),
            //  Dots.
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20),
                ),
                margin: EdgeInsets.only(
                  bottom: getProportionateScreenHeight(20),
                ),
                child: Column(
                  children: [
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _splashData.length,
                        (index) => buildDot(index: index),
                      ),
                    ),
                    const Spacer(),
                    //  Navigation buttons
                    Stack(
                      children: [
                        LayoutBuilder(
                          builder: (_, cons) {
                            return Align(
                              alignment: Alignment.bottomRight,
                              child: AnimatedContainer(
                                height: getProportionateScreenHeight(43),
                                width: _currentPageIndex < 3
                                    ? getProportionateScreenWidth(94)
                                    : cons.biggest.width,
                                duration: Duration(milliseconds: 500),
                                child: _currentPageIndex < 3
                                    ? SplashNextButton(
                                        pageController: _pageController)
                                    : SplashGetStartedButton(),
                              ),
                            );
                          },
                        ),
                        SplashBackButton(
                          pageController: _pageController,
                          animationController: _backButtonAnimationController,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //  Animate the dots.
  AnimatedContainer buildDot({int index}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      margin: const EdgeInsets.only(right: 5.0),
      height: getProportionateScreenHeight(7.5),
      width: _currentPageIndex == index ? 20.0 : 6.0,
      decoration: BoxDecoration(
        color:
            _currentPageIndex == index ? Colors.teal[600] : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
