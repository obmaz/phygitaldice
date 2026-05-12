import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'router/app_router.dart';

class DiceArenaApp extends StatelessWidget {
  const DiceArenaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dice Arena',
      theme: AppTheme.theme,
      home: const AppRouter(),
    );
  }
}
