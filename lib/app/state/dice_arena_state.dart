import 'package:phygital_dice/features/dice_arena/domain/models.dart';

enum DiceArenaRoute {
  home,
  characterSelect,
  skillSelect,
  buildConfirm,
  readySummary,
}

class DiceArenaState {
  DiceArenaRoute currentRoute;

  final GameCharacter? selectedCharacter;
  final int currentHealth;
  final Set<String> selectedExtraSkillIds;
  final Map<String, bool> readyChecks;
  final Set<String> activeMarkers;

  DiceArenaState({
    required this.currentRoute,
    required this.selectedCharacter,
    required this.currentHealth,
    required this.selectedExtraSkillIds,
    required this.readyChecks,
    required this.activeMarkers,
  });

  factory DiceArenaState.initial({GameCharacter? character}) {
    final extraSkillIds =
        character?.skills
            .where((skill) => !skill.isBase)
            .take(2)
            .map((skill) => skill.id)
            .toSet() ??
        const <String>{};

    return DiceArenaState(
      currentRoute: DiceArenaRoute.home,
      selectedCharacter: character,
      currentHealth: character?.maxHealth ?? 0,
      selectedExtraSkillIds: extraSkillIds,
      readyChecks: {
        '전용 주사위 준비': character != null,
        '결정 카드 준비': character != null,
        '추가 카드 셋': false,
        '상태 완료': false,
      },
      activeMarkers: const <String>{},
    );
  }

  DiceArenaState copyWith({
    DiceArenaRoute? currentRoute,
    GameCharacter? selectedCharacter,
    int? currentHealth,
    Set<String>? selectedExtraSkillIds,
    Map<String, bool>? readyChecks,
    Set<String>? activeMarkers,
  }) {
    return DiceArenaState(
      currentRoute: currentRoute ?? this.currentRoute,
      selectedCharacter: selectedCharacter ?? this.selectedCharacter,
      currentHealth: currentHealth ?? this.currentHealth,
      selectedExtraSkillIds:
          selectedExtraSkillIds ?? this.selectedExtraSkillIds,
      readyChecks: readyChecks ?? this.readyChecks,
      activeMarkers: activeMarkers ?? this.activeMarkers,
    );
  }
}
