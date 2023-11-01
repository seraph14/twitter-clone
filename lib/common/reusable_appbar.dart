import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_clone/constants/constants.dart';

class ReUsableAppbar extends StatelessWidget {
  const ReUsableAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: SvgPicture.asset(
        AssetsConstants.twitterLogo,
      ),
    );
  }
}
