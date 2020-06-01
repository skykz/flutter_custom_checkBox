import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'custom_checkbox.dart';
import 'index_provider.dart';
import 'model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChangeNotifierProvider<SliderProvider>(
          create: (_) => SliderProvider(), child: MainTaskScreen()),
    );
  }
}

class MainTaskScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainState();
  }
}

class MainState extends State<MainTaskScreen> {
  Map<String, dynamic> _buttonData = {
    'button': null,
  };

  double minDuration = 200;
  double maxDuration = 2000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Task"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
                height: 25,
                width: 75,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: ButtonTypes.initial().buttons.map((Buttons button) {
                  final bool selected =
                        _buttonData['button']?.name == button.name;

                    log("${button.name} bool ----- $selected");

                    return InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        if (selected) {
                          _handleButtonChange(false, button);
                        } else {
                          _handleButtonChange(true, button);
                        }
                      },
                      child: Container(
                        height: 25,
                        width: 25,
                        child: CustomButtonWidget(
                            color: button.color,
                            selected: selected,
                            onChange: (newVal) {
                              _handleButtonChange(newVal, button);
                            }),
                      ),
                    );
                  }).toList(),
                )),
            Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 30),
                child: Text(
                  "Animation duration",
                  style: TextStyle(fontSize: 18),
                )),
            Consumer<SliderProvider>(
                builder: (context, newValue, child) => Column(
                      children: <Widget>[
                        Slider(
                          value: newValue.getValue.toDouble(),
                          min: minDuration,
                          max: maxDuration,
                          onChanged: (double val) {
                            newValue.setNewValue(val.round());
                          },
                          divisions: maxDuration.toInt(),
                          label: "${newValue.getValue} ms",
                        ),
                        Text("${newValue.getValue} ms")
                      ],
                    ))
          ],
        ),
      ),
    );
  }

  void _handleButtonChange(bool newVal, Buttons button) {
    setState(() {
      if (newVal) {
        _buttonData['button'] = button;
      } else {
        _buttonData['button'] = null;
      }
    });
  }
}

class SelectWidget extends StatefulWidget {
  final ValueChanged<bool> onChange;
  final bool selected;
  final Function(BuildContext, Animation) builder;

  const SelectWidget(
      {Key key, this.selected, this.onChange, @required this.builder})
      : super(key: key);

  @override
  _MyCheckBoxState createState() => _MyCheckBoxState();
}

class _MyCheckBoxState extends State<SelectWidget>
    with SingleTickerProviderStateMixin {
  bool _checkedBox;
  AnimationController _controller;

  @override
  initState() {
    super.initState();
    _checkedBox = widget.selected;

    _controller = AnimationController(
      value: _checkedBox ? 1.0 : 0.0,
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(SelectWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _checkedBox = widget.selected;
    if (_checkedBox) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  _toggle() {
    setState(() {
      _checkedBox = !_checkedBox;
      if (widget.onChange != null && widget.onChange is Function(bool)) {
        widget.onChange(_checkedBox);
      }
      if (_checkedBox) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final newValue = Provider.of<SliderProvider>(context);
    _controller.duration = Duration(milliseconds: newValue.getValue);
    log("${newValue.getValue}");

    return GestureDetector(      
      onTap: _toggle,
      child: widget.builder(context, _controller),
    );
  }
}

class CustomButtonWidget extends StatelessWidget {
  final bool selected;
  final Color color;
  final ValueChanged<bool> onChange;

  const CustomButtonWidget({
    Key key,
    this.selected,
    this.color,
    this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SelectWidget(
      selected: selected,
      onChange: onChange,
      builder: (BuildContext context, Animation animation) {
        return CustomPaint(
          painter: CustomCheckBoxButtonPainter(
              animation: animation, 
              checked: true, color: color),
        );
      },
    );
  }
}
