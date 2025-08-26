import 'package:flutter/material.dart';
import 'package:proto_kairos/views/pages/home_page.dart';

class ScaffoldControl extends StatefulWidget {
  const ScaffoldControl({super.key});

  @override
  State<ScaffoldControl> createState() => _ScaffoldControlState();
}

class _ScaffoldControlState extends State<ScaffoldControl> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomePage(),
    );
  }
}
