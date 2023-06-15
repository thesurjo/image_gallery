import 'package:flutter/material.dart';

import '../../export/util.export.dart';

class DefaultCircularLoader extends StatelessWidget {
  const DefaultCircularLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        strokeWidth: 0.5,
        color: primarycolor,
      ),
    );
  }
}
