import 'package:flutter/material.dart';

import '../domain/models.dart';

const _teal = Color(0xFF168C78);
const _amber = Color(0xFFE2A536);
const _coral = Color(0xFFE35E4B);
const _violet = Color(0xFF5B5DAA);

const List<DiceFace> _standardDice = [
  DiceFace(label: '공격', icon: Icons.flash_on, color: _coral),
  DiceFace(label: '방어', icon: Icons.shield, color: _teal),
  DiceFace(label: '스킬', icon: Icons.auto_awesome, color: _violet),
  DiceFace(label: '재활용', icon: Icons.change_circle, color: _amber),
  DiceFace(label: '와일드', icon: Icons.star, color: Color(0xFF3C7EDB)),
  DiceFace(label: '빈칸', icon: Icons.circle_outlined, color: Color(0xFF777777)),
];

const List<GameCharacter> seedCharacters = [
  GameCharacter(
    id: 'frost_watcher',
    name: '서리 감시자',
    archetype: '방어형 전사',
    tagline: '방패와 빙결 타이밍으로 빠른 드드를 설계한다.',
    maxHealth: 34,
    defense: 5,
    tempo: 2,
    base: Color(0xFF23313A),
    accent: _teal,
    diceFaces: _standardDice,
    skills: [
      CharacterSkill(
        id: 'guard_line',
        name: '방패선',
        cost: '방어 x2',
        effect: '방어 타이밍 1개를 쌓고 다음 턴까지 2.</s>',
        icon: Icons.shield,
        color: _teal,
        isBase: true,
      ),
      CharacterSkill(
        id: 'ice_break',
        name: '빙결 강타',
        cost: '공격+스킬',
        effect: '주셔 4. 대상에게 속박 마커를 획득한다.',
        icon: Icons.ac_unit,
        color: Color(0xFF3C7EDB),
        isBase: true,
      ),
      CharacterSkill(
        id: 'counter_wall',
        name: '반격 장벽',
        cost: '방어+와일드',
        effect: '이번 라운드에 받은 공격 카드로만 반격을 결정한다.',
        icon: Icons.reply,
        color: _teal,
      ),
      CharacterSkill(
        id: 'frozen_route',
        name: '서리 회로',
        cost: '스킬 x2',
        effect: '상대의 다음 재활용 선택 후 주사위 1개를 고정한다.',
        icon: Icons.route,
        color: _violet,
      ),
      CharacterSkill(
        id: 'white_out',
        name: '화이트 아웃',
        cost: '와일드 x2',
        effect: '라운드 종료까지 모든 빈칸을 방어 면제로 취급한다.',
        icon: Icons.blur_on,
        color: Color(0xFF3C7EDB),
      ),
    ],
  ),
];
