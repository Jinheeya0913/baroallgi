import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppLogoImg extends StatefulWidget {
  final double width;
  final bool isHorizontal;

  const AppLogoImg({super.key, this.width = 100, this.isHorizontal = false});

  @override
  State<AppLogoImg> createState() => _AppLogoImgState();
}

class _AppLogoImgState extends State<AppLogoImg> {
  @override
  Widget build(BuildContext context) {
    if(!widget.isHorizontal) {
      return SvgPicture.asset(
        'assets/images/logo_allbaro.svg',
        width: widget.width,
      );
    } else {
      return SvgPicture.asset(
        'assets/images/logo_horizen.svg',
        width: widget.width,
        fit: BoxFit.fitWidth,

      );
    }

  }
}
