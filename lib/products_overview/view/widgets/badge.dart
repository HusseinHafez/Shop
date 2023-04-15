import 'package:flutter/material.dart';
import 'package:myshop/size_config.dart';

class Badge extends StatelessWidget {
  final Widget child;
  final String value;

  const Badge({
    Key? key,
    required this.child,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.deepOrange,
            ),
            constraints: BoxConstraints(
              minHeight: getHeight(16),
              minWidth: getWidth(16),
            ),
            child: Text(
              value,
              style:  TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: getFont(14)
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }
}
