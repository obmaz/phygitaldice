import 'package:flutter/material.dart';

import '../state/dice_arena_controller.dart';
import '../state/dice_arena_state.dart';
import '../ui/app_shell.dart';
import 'package:phygital_dice/features/dice_arena/presentation/screens/home_screen.dart';

class AppRouter extends StatefulWidget {
  const AppRouter({super.key});

  @override
  State<AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends State<AppRouter> {
  late final DiceArenaController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DiceArenaController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final s = _controller.state;

        Widget page;
        switch (s.currentRoute) {
          case DiceArenaRoute.home:
            page = HomeScreen(controller: _controller);
          case DiceArenaRoute.characterSelect:
            page = HomeScreen(controller: _controller);
          case DiceArenaRoute.skillSelect:
            page = HomeScreen(controller: _controller);
          case DiceArenaRoute.buildConfirm:
            page = HomeScreen(controller: _controller);
          case DiceArenaRoute.readySummary:
            page = HomeScreen(controller: _controller);
        }

        return AppShell(child: page);
      },
    );
  }
}
