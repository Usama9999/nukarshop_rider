import 'package:flutter/material.dart';

class ConfigSize {
  static double screenWidth = 0.0;
  static double screenHeight = 0.0;
  static double _blockSizeHorizontal = 0.0;
  static double _blockSizeVertical = 0.0;
  static double widthMultiplier = 0;
  static double textMultiplier = 0.0;
  static double imageSizeMultiplier = 0.0;
  static double heightMultiplier = 0.0;
  static double paddingWidth = 0.0;
  static double paddingHeight = 0.0;

  void init(BoxConstraints boxConstraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      screenHeight = boxConstraints.maxHeight;
      screenWidth = boxConstraints.maxWidth;
    } else {
      screenHeight = boxConstraints.maxWidth;
      screenWidth = boxConstraints.maxHeight;
    }

    _blockSizeHorizontal = screenWidth / 100;
    _blockSizeVertical = screenHeight / 100;
    textMultiplier = _blockSizeVertical;
    imageSizeMultiplier = _blockSizeHorizontal;
    heightMultiplier = _blockSizeVertical;
    widthMultiplier = _blockSizeHorizontal;
    paddingWidth = _blockSizeHorizontal;
    paddingHeight = _blockSizeVertical;

    print(_blockSizeVertical);
    print(_blockSizeHorizontal);
  }
}
