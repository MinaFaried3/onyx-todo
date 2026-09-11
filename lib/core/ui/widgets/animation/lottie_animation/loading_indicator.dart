import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key, this.height, this.width});

  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator();
    // return Center(
    //   child: Lottie.asset(
    //     Assets.jsonLoading,
    //     width: width ?? 200.w,
    //     height: height,
    //   ),
    // );
  }
}
