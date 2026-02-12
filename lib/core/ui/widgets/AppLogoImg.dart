import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppLogoImg extends StatefulWidget {
  final double width;
  const AppLogoImg({super.key, this.width = 100});

  @override
  State<AppLogoImg> createState() => _AppLogoImgState();
}

class _AppLogoImgState extends State<AppLogoImg> {
  @override
  Widget build(BuildContext context) {
    return  SvgPicture.asset('assets/images/logo_allbaro.svg', width: widget.width,);
  }
}
