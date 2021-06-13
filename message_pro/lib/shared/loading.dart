import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:message_pro/shared/constants.dart';
class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color:Colors.white,
      child:Center(
        child: SpinKitSpinningCircle(
          color: kPrimaryColor1,
          size:55.0,
        )
      )
    );
  }
}
