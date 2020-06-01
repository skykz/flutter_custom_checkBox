import 'package:flutter/material.dart';

class SliderProvider extends ChangeNotifier {

  int _minDuration = 200;
  int get getValue => _minDuration;

  void setNewValue(int val) {
    _minDuration = val;
    notifyListeners();
  }  
  changeWidthSlider(int newValue) {
    _minDuration = newValue;
    notifyListeners();
  }

  }