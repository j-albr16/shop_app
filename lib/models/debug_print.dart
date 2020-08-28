
library debug_print;

import 'package:flutter/material.dart';


class DebugPrinter extends StatelessWidget {

  final String debugString;
  final Widget child;

  const DebugPrinter({Key key,this.child, this.debugString}) : super();

  @override
  Widget build(BuildContext context) {
    print(debugString);
    return child;
  }
}

/// A Calculator.
