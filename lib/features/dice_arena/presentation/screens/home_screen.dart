import 'package:flutter/material.dart';
import 'package:phygital_dice/app/state/dice_arena_controller.dart';
import 'package:phygital_dice/app/state/dice_arena_state.dart';
import 'package:phygital_dice/features/dice_arena/domain/models.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.controller});

  final DiceArenaController controller;

  @override
  Widget build(BuildContext context) {
    final state = controller.state;
    final character = state.selectedCharacter ?? controller.characters.first;
    final isStatus = state.currentRoute == DiceArenaRoute.readySummary;

    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: isStatus
              ? _StatusView(
                  key: const ValueKey('status'),
                  controller: controller,
                  state: state,
                  character: character,
                )
              : _SetupView(
                  key: const ValueKey('setup'),
                  controller: controller,
                  state: state,
                  character: character,
                ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: isStatus ? 1 : 0,
        onDestinationSelected: (index) {
          controller.go(
            index == 0 ? DiceArenaRoute.home : DiceArenaRoute.readySummary,
          );
        },
        destinations: const [
          NavigationDestination(
            key: Key('nav-setup'),
            icon: Icon(Icons.dashboard_customize_outlined),
            selectedIcon: Icon(Icons.dashboard_customize),
            label: '세팅',
          ),
          NavigationDestination(
            key: Key('nav-status'),
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: '상태',
          ),
        ],
      ),
    );
  }
}

class _SetupView extends StatelessWidget {
  const _SetupView({
    super.key,
    required this.controller,
    required this.state,
    required this.character,
  });

  final DiceArenaController controller;
  final DiceArenaState state;
  final GameCharacter character;

  @override
  Widget build(BuildContext context) {
    final baseSkills = character.skills.where((skill) => skill.isBase);
    final extraSkills = character.skills.where((skill) => !skill.isBase);

    return _PageContent(
      children: [
        _Header(
          title: 'Dice Arena',
          subtitle: 'Companion App',
          trailing: FilledButton.icon(
            onPressed: () => controller.go(DiceArenaRoute.characterSelect),
            icon: const Icon(Icons.person_search),
            label: const Text('캐릭터'),
          ),
        ),
        const SizedBox(height: 18),
        _CharacterCard(
          character: character,
          selected: true,
          onTap: () => controller.selectCharacter(character),
        ),
        const SizedBox(height: 20),
        _SectionTitle(
          icon: Icons.casino_outlined,
          title: '전용 주사위',
          subtitle: '물리 주사위 면을 빠르게 확인합니다.',
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final face in character.diceFaces) _DiceFaceChip(face: face),
          ],
        ),
        const SizedBox(height: 22),
        _SectionTitle(
          icon: Icons.bolt_outlined,
          title: '기본 스킬',
          subtitle: '캐릭터 선택 시 항상 포함됩니다.',
        ),
        const SizedBox(height: 10),
        for (final skill in baseSkills)
          _SkillTile(skill: skill, selected: true),
        const SizedBox(height: 16),
        _SectionTitle(
          icon: Icons.auto_awesome_outlined,
          title: '추가 스킬',
          subtitle: '최대 2개까지 이번 게임에 준비합니다.',
        ),
        const SizedBox(height: 10),
        for (final skill in extraSkills)
          _SkillTile(
            skill: skill,
            selected: state.selectedExtraSkillIds.contains(skill.id),
            onTap: () => controller.toggleExtraSkill(skill.id),
          ),
        const SizedBox(height: 20),
        _SectionTitle(
          icon: Icons.checklist,
          title: '준비 체크',
          subtitle: '테이블에 올릴 구성물을 확인합니다.',
        ),
        const SizedBox(height: 8),
        for (final entry in state.readyChecks.entries)
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: entry.value,
            onChanged: (value) => controller.toggleReady(entry.key, value),
            title: Text(entry.key),
            controlAffinity: ListTileControlAffinity.leading,
          ),
      ],
    );
  }
}

class _StatusView extends StatelessWidget {
  const _StatusView({
    super.key,
    required this.controller,
    required this.state,
    required this.character,
  });

  final DiceArenaController controller;
  final DiceArenaState state;
  final GameCharacter character;

  @override
  Widget build(BuildContext context) {
    final markers = ['공격', '속박', '방어', '집중'];

    return _PageContent(
      children: [
        _Header(
          title: character.name,
          subtitle: character.archetype,
          trailing: FilledButton.icon(
            onPressed: () => controller.go(DiceArenaRoute.home),
            icon: const Icon(Icons.tune),
            label: const Text('세팅'),
          ),
        ),
        const SizedBox(height: 18),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton.filledTonal(
                key: const Key('health-decrease'),
                onPressed: () => controller.adjustHealth(-1),
                icon: const Icon(Icons.remove),
                tooltip: '체력 감소',
              ),
              const SizedBox(width: 16),
              Container(
                key: const Key('health-dial'),
                width: 126,
                height: 126,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: character.accent.withValues(alpha: 0.13),
                  shape: BoxShape.circle,
                  border: Border.all(color: character.accent, width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${state.currentHealth}',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: character.base,
                      ),
                    ),
                    Text(
                      '/ ${character.maxHealth}',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              IconButton.filledTonal(
                key: const Key('health-increase'),
                onPressed: () => controller.adjustHealth(1),
                icon: const Icon(Icons.add),
                tooltip: '체력 증가',
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _SectionTitle(
          icon: Icons.flag_outlined,
          title: '상태 마커',
          subtitle: '물리 카드 옆에 놓인 마커를 앱에도 맞춰둡니다.',
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final marker in markers)
              FilterChip(
                label: Text(marker),
                selected: state.activeMarkers.contains(marker),
                onSelected: (_) => controller.toggleMarker(marker),
              ),
          ],
        ),
        const SizedBox(height: 24),
        _SectionTitle(
          icon: Icons.auto_awesome_outlined,
          title: '이번 게임 스킬',
          subtitle: '기본 스킬과 선택한 추가 스킬입니다.',
        ),
        const SizedBox(height: 10),
        for (final skill in character.skills.where(
          (skill) =>
              skill.isBase || state.selectedExtraSkillIds.contains(skill.id),
        ))
          _SkillTile(skill: skill, selected: true),
      ],
    );
  }
}

class _PageContent extends StatelessWidget {
  const _PageContent({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
        const SizedBox(width: 12),
        trailing,
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 2),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

class _CharacterCard extends StatelessWidget {
  const _CharacterCard({
    required this.character,
    required this.selected,
    required this.onTap,
  });

  final GameCharacter character;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: character.base,
                foregroundColor: Colors.white,
                child: const Icon(Icons.ac_unit),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(character.tagline),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: [
                        _StatChip(label: 'HP', value: '${character.maxHealth}'),
                        _StatChip(label: '방어', value: '${character.defense}'),
                        _StatChip(label: '템포', value: '${character.tempo}'),
                      ],
                    ),
                  ],
                ),
              ),
              if (selected) const Icon(Icons.check_circle),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Chip(
      visualDensity: VisualDensity.compact,
      label: Text('$label $value'),
    );
  }
}

class _DiceFaceChip extends StatelessWidget {
  const _DiceFaceChip({required this.face});

  final DiceFace face;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(face.icon, color: face.color, size: 18),
      label: Text(face.label),
    );
  }
}

class _SkillTile extends StatelessWidget {
  const _SkillTile({required this.skill, required this.selected, this.onTap});

  final CharacterSkill skill;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: skill.color.withValues(
            alpha: selected ? 0.18 : 0.08,
          ),
          foregroundColor: skill.color,
          child: Icon(skill.icon),
        ),
        title: Text(skill.name),
        subtitle: Text('${skill.cost} · ${skill.effect}'),
        trailing: selected
            ? const Icon(Icons.check_circle)
            : const Icon(Icons.add_circle_outline),
      ),
    );
  }
}
