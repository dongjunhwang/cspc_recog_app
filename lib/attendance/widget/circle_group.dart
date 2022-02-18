library circle_group;

import 'dart:math';

import 'package:flutter/material.dart';

class CircleGroup extends StatelessWidget {
  final List<Widget> children;
  final Widget centerWidget;
  int layer;
  final double childPadding;

  final double outPadding;
  final Color childColor;
  final double elevation;
  final Offset origin;

  List<Offset> childPositions;
  List<Offset> emptyChildPositions;

  CircleGroup({
    this.children,
    this.centerWidget,
    this.childPadding = 10.0,
    this.outPadding = 10.0,
    this.childColor,
    this.elevation = 10.0,
    this.origin = Offset.zero,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final width = constraints.maxWidth;
        final maxSize = min(height, width);

        assert(children.length <= 18);
        if (children.length > 6) {
          layer = 2;
        } else {
          layer = 1;
        }
        final double resizedChild =
            (maxSize - 2 * outPadding - (2 * layer) * childPadding) /
                (2 * layer + 1);
        final double radius = resizedChild + childPadding;
        setChildPositon(radius);
        print(childPositions);

        final Offset centerPoint = Offset(
            width / 2 - resizedChild / 2 + origin.dx,
            height / 2 - resizedChild / 2 + origin.dy);

        return Container(
          child: SizedBox(
            height: height,
            width: width,
            child: Stack(
              children: [
                Positioned(
                  top: centerPoint.dy,
                  left: centerPoint.dx,
                  child: childCircle(resizedChild, centerWidget),
                ),
                ...List.generate(
                  children.length,
                  (index) => Positioned(
                    top: centerPoint.dy + childPositions[index].dy,
                    left: centerPoint.dx + childPositions[index].dx,
                    child: childCircle(resizedChild, children[index]),
                  ),
                ),
                ...List.generate(
                  emptyChildPositions.length,
                  (index) => Positioned(
                    top: centerPoint.dy + emptyChildPositions[index].dy,
                    left: centerPoint.dx + emptyChildPositions[index].dx,
                    child: childCircle(resizedChild, null),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget childCircle(double size, Widget child) {
    return PhysicalModel(
      color: childColor ?? Colors.white,
      shape: BoxShape.circle,
      elevation: elevation,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        width: size,
        height: size,
        child: child,
      ),
    );
  }

  setChildPositon(double radius) {
    final List<Offset> positions = List.generate(6, (index) {
      double dx = radius * cos(pi / 3 * index);
      double dy = radius * sin(pi / 3 * index);
      return Offset(dx, dy);
    });

    positions.shuffle();
    childPositions = positions.sublist(0, min(6, children.length));
    emptyChildPositions = positions.sublist(min(6, children.length));

    if (layer == 2) {
      final List<Offset> secondLayerPositions = List.generate(6, (index) {
        double dx = 2 * radius * cos(pi / 3 * index);
        double dy = 2 * radius * sin(pi / 3 * index);
        return Offset(dx, dy);
      });
      final List<Offset> sidePositions = List.generate(6, (index) {
        return (secondLayerPositions[index % 6] +
                secondLayerPositions[(index + 1) % 6]) /
            2;
      });
      secondLayerPositions.addAll(sidePositions);

      secondLayerPositions.shuffle();
      childPositions
          .addAll(secondLayerPositions.sublist(0, children.length - 6));
      emptyChildPositions
          .addAll(secondLayerPositions.sublist(children.length - 6));
    }
  }
}
