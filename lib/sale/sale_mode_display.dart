import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';

class SaleModeDisplay extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SaleModeDisplayState();
  }
}

class _SaleModeDisplayState extends State<SaleModeDisplay> {
  final MultiSplitViewController _controller = MultiSplitViewController();

  @override
  void initState() {
    super.initState();
    _controller.areas = [
      Area(builder: (builderContext, area) => Draft.blue()),
      Area(builder: (builderContext, area) => Draft.green())
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MultiSplitViewTheme(
        data:
            MultiSplitViewThemeData(dividerPainter: DividerPainters.grooved2()),
        child: MultiSplitView(
            axis: Axis.vertical,
            onDividerTap: _onDividerTap,
            onDividerDoubleTap: _onDividerDoubleTap,
            controller: _controller));
  }

  _onDividerTap(int dividerIndex) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 1),
      content: Text("Tap on divider: $dividerIndex"),
    ));
  }

  _onDividerDoubleTap(int dividerIndex) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 1),
      content: Text("Double tap on divider: $dividerIndex"),
    ));
  }
}
