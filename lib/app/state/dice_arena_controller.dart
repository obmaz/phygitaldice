import 'package:flutter/foundation.dart';

import '../../features/dice_arena/data/seed_data.dart';
import '../../features/dice_arena/domain/models.dart';
import 'dice_arena_state.dart';

class DiceArenaController extends ChangeNotifier {
  DiceArenaController()
    : _state = DiceArenaState.initial(character: seedCharacters.first);

  DiceArenaState _state;
  DiceArenaState get state => _state;

  void go(DiceArenaRoute route) {
    _state = _state.copyWith(currentRoute: route);
    notifyListeners();
  }

  void selectCharacter(GameCharacter character) {
    final extraIds = character.skills
        .where((s) => !s.isBase)
        .take(2)
        .map((s) => s.id)
        .toSet();

    final ready = <String, bool>{
      '전용 주사위 준비': true,
      '결정 카드 준비': true,
      '추가 카드 셋': false,
      '상태 완료': false,
    };

    final markers = {'공격'};

    _state = _state.copyWith(
      selectedCharacter: character,
      currentHealth: character.maxHealth,
      selectedExtraSkillIds: extraIds,
      readyChecks: ready,
      activeMarkers: markers,
      currentRoute: DiceArenaRoute.skillSelect,
    );
    notifyListeners();
  }

  void toggleExtraSkill(String skillId) {
    final character = _state.selectedCharacter;
    if (character == null) return;

    final skill = character.skills.firstWhere((s) => s.id == skillId);
    if (skill.isBase) return;

    final next = _state.selectedExtraSkillIds.toList(growable: true);
    if (next.contains(skillId)) {
      next.remove(skillId);
    } else {
      if (next.length >= 2) {
        next.removeAt(0);
      }
      next.add(skillId);
    }

    _state = _state.copyWith(selectedExtraSkillIds: next.toSet());
    notifyListeners();
  }

  void adjustHealth(int delta) {
    final character = _state.selectedCharacter;
    if (character == null) return;

    final next = (_state.currentHealth + delta)
        .clamp(0, character.maxHealth)
        .toInt();
    _state = _state.copyWith(currentHealth: next);
    notifyListeners();
  }

  void toggleMarker(String marker) {
    final next = _state.activeMarkers.contains(marker)
        ? (_state.activeMarkers.toSet()..remove(marker))
        : (_state.activeMarkers.toSet()..add(marker));

    _state = _state.copyWith(activeMarkers: next);
    notifyListeners();
  }

  void toggleReady(String label, bool? value) {
    final next = Map<String, bool>.from(_state.readyChecks);
    next[label] = value ?? false;
    _state = _state.copyWith(readyChecks: next);
    notifyListeners();
  }

  List<GameCharacter> get characters => seedCharacters;
}
