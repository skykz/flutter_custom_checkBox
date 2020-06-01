import 'package:flutter/material.dart';

class Buttons {
  final String name;
  final Color color;

  Buttons({this.name, this.color});
}

class ButtonTypes {
  ButtonTypes(this.buttons);
  final List<Buttons> buttons;

  factory ButtonTypes.initial() {
    return ButtonTypes(
      <Buttons>[
        Buttons(name: 'first_button', color: Colors.blue,),
        Buttons(name: 'second_button', color: Colors.green,),       
      ],
    );
  }
}
