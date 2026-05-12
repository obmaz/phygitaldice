import 'package:flutter/material.dart';

class GameCharacter {
  const GameCharacter({
    required this.id,
    required this.name,
    required this.archetype,
    required this.tagline,
    required this.maxHealth,
    required this.defense,
    required this.tempo,
    required this.base,
    required this.accent,
    required this.diceFaces,
    required this.skills,
  });

  final String id;
  final String name;
  final String archetype;
  final String tagline;
  final int maxHealth;
  final int defense;
  final int tempo;
  final Color base;
  final Color accent;
  final List<DiceFace> diceFaces;
  final List<CharacterSkill> skills;
}

class DiceFace {
  const DiceFace({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;
}

class CharacterSkill {
  const CharacterSkill({
    required this.id,
    required this.name,
    required this.cost,
    required this.effect,
    required this.icon,
    required this.color,
    this.isBase = false,
  });

  final String id;
  final String name;
  final String cost;
  final String effect;
  final IconData icon;
  final Color color;
  final bool isBase;
}
