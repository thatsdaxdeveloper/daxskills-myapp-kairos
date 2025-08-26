import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proto_kairos/models/data/generated/assets.dart';
import 'package:proto_kairos/views/utils/svg_util.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => GestureDetector(
            onTap: () => context.pop(),
            child: Center(child: svgIcon(path: Assets.arrowToLeftSvgrepoCom)),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nouvel événement", style: textTheme.headlineMedium),
            Text("Créez un nouveau compte à rebours", style: textTheme.labelMedium),
          ],
        ),
      ),
      body: Center(child: Text('Add')),
    );
  }
}
