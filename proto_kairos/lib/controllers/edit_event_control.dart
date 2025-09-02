import 'package:flutter/material.dart';
import 'package:proto_kairos/models/entities/countdown_entity.dart';

class EditEventControl extends StatefulWidget {
  final CountdownEntity countdown;
  const EditEventControl({super.key, required this.countdown});

  @override
  State<EditEventControl> createState() => _EditEventControlState();
}

class _EditEventControlState extends State<EditEventControl> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("ID : ${widget.countdown.title}"),
    );
  }
}
