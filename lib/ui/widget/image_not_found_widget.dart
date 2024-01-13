import 'package:flutter/material.dart';

class ImageNotFoundWidget extends StatelessWidget {
  const ImageNotFoundWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      child: Center(
        child: Icon(
          Icons.error_outline,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }
}
