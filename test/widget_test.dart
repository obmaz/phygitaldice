import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:phygital_dice/main.dart';

void main() {
  testWidgets('renders the Dice Arena setup screen', (tester) async {
    await tester.pumpWidget(const DiceArenaApp());

    expect(find.text('Dice Arena'), findsOneWidget);
    expect(find.text('서리 감시자'), findsWidgets);
    expect(find.text('전용 주사위'), findsOneWidget);
    expect(find.text('추가 스킬'), findsWidgets);
  });

  testWidgets('updates character health from the status screen', (
    tester,
  ) async {
    await tester.pumpWidget(const DiceArenaApp());

    await tester.tap(find.byKey(const Key('nav-status')));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byKey(const Key('health-dial')),
        matching: find.text('34'),
      ),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('health-increase')));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byKey(const Key('health-dial')),
        matching: find.text('34'),
      ),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('health-decrease')));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byKey(const Key('health-dial')),
        matching: find.text('33'),
      ),
      findsOneWidget,
    );
  });
}
