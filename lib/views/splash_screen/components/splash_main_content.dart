import 'package:flutter/material.dart';
import 'package:goolazo/views/utils/size_config.dart';

//  The default structure for the splash screen
class SplashMainContent extends StatelessWidget {
  const SplashMainContent({
    this.image,
    this.title,
    this.description,
  });

  final String image, title, description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Stack(
          alignment: Alignment.center,
          children: [
            buildVectorsBackgroundCircle(),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(image), fit: BoxFit.contain)),
            ),
            // Image.asset(
            //   image,
            //   fit: BoxFit.contain,
            //   alignment: Alignment.center,
            // ),
          ],
        ),
        const Spacer(),
        Text(
          title,
          style: TextStyle(
              fontSize: getProportionateScreenWidth(20),
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'AbrilFatface'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: getProportionateScreenWidth(16),
                fontFamily: 'AbrilFatface'),
          ),
        ),
      ],
    );
  }

  Widget buildVectorsBackgroundCircle() {
    return Container(
      height: getProportionateScreenHeight(350),
      width: getProportionateScreenWidth(300),
      decoration: BoxDecoration(
        color: Colors.teal[600],
        shape: BoxShape.circle,
      ),
    );
  }
}
