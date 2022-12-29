import 'package:flutter/cupertino.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset('assets/image/top.png'),
            width: size.width,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset('assets/image/low.png'),
            width: size.width,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset('assets/image/low.png'),
            width: size.width,
          ),
          child
        ],
      ),
    );
  }
}
