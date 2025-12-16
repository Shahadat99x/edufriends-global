import 'package:flutter/material.dart';
import '../../common_widgets/glass_container.dart';
import '../../core/theme/app_theme.dart';

/// Simple data model for demo programs
class Program {
  final String tag; // e.g., 'MASTERS', 'PHD'
  final String title;
  final String university;
  final String cityCountry;
  final String tuition; // display string
  final String duration; // e.g. '1.5 years'
  final String discipline;

  const Program({
    required this.tag,
    required this.title,
    required this.university,
    required this.cityCountry,
    required this.tuition,
    required this.duration,
    required this.discipline,
  });
}

/// Sample static EU programs — real universities + plausible program names/tuitions for demo
const List<Program> samplePrograms = [
  Program(
    tag: 'MASTERS',
    title: 'Applied Data Science',
    university: 'University of Copenhagen',
    cityCountry: 'Copenhagen, Denmark',
    tuition: '€2,500 / year',
    duration: '1.5 years',
    discipline: 'Computer Science',
  ),
  Program(
    tag: 'PHD',
    title: 'Advanced Robotics',
    university: 'Lund University',
    cityCountry: 'Lund, Sweden',
    tuition: '€500 / year',
    duration: '4 years',
    discipline: 'Robotics',
  ),
  Program(
    tag: 'MASTERS',
    title: 'International Business',
    university: 'Vilnius University',
    cityCountry: 'Vilnius, Lithuania',
    tuition: '€4,200 / year',
    duration: '2 years',
    discipline: 'Business',
  ),
  Program(
    tag: 'PHD',
    title: 'Telecommunication Systems',
    university: 'Riga Technical University',
    cityCountry: 'Riga, Latvia',
    tuition: '€4,610 / year',
    duration: '4.5 years',
    discipline: 'CSE',
  ),
  Program(
    tag: 'MASTERS',
    title: 'Renewable Energy Engineering',
    university: 'Technical University of Madrid',
    cityCountry: 'Madrid, Spain',
    tuition: '€7,999 / year',
    duration: '1.5 years',
    discipline: 'Engineering',
  ),
  Program(
    tag: 'PHD',
    title: 'Artificial Intelligence',
    university: 'Trinity College Dublin',
    cityCountry: 'Dublin, Ireland',
    tuition: '€6,000 / year',
    duration: '3.5 years',
    discipline: 'AI',
  ),
];

/// FeaturedProgramsGrid - displays program cards in a responsive grid
class FeaturedProgramsGrid extends StatelessWidget {
  final List<Program> programs;
  final void Function(Program)? onProgramTap;
  final int? crossAxisCount; // optional override

  const FeaturedProgramsGrid({super.key, this.programs = samplePrograms, this.onProgramTap, this.crossAxisCount});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final w = MediaQuery.of(context).size.width;

    final int cols = crossAxisCount ?? (w >= 800 ? 3 : (w >= 600 ? 2 : 1));

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: programs.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        mainAxisSpacing: AppTheme.sp12,
        crossAxisSpacing: AppTheme.sp12,
        childAspectRatio: 3 / 2.2,
      ),
      itemBuilder: (context, i) {
        final p = programs[i];
        return _ProgramCard(program: p, onTap: () => onProgramTap?.call(p));
      },
    );
  }
}

class _ProgramCard extends StatelessWidget {
  final Program program;
  final VoidCallback? onTap;

  const _ProgramCard({required this.program, this.onTap});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return GlassContainer(
      padding: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tag pill + spacer
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: cs.secondary.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(program.tag, style: text.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: cs.secondary)),
                ),
                const Spacer(),
                // small placeholder flag circle
                Container(
                  width: 36,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: cs.primary.withOpacity(0.12),
                  ),
                  alignment: Alignment.center,
                  child: Text(program.cityCountry.split(',').first.split(' ').map((s) => s.isEmpty ? '' : s[0]).take(2).join(), style: text.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: cs.primary)),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Title
            Text(program.title, style: text.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text('${program.university} · ${program.cityCountry}', style: text.bodySmall?.copyWith(color: cs.onSurface.withOpacity(0.7))),

            const SizedBox(height: 10),

            // Tuition badge + meta
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: cs.surface.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text('TUITION PER YEAR', style: text.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: cs.onSurface.withOpacity(0.7))),
                ),
                const SizedBox(width: 8),
                Text(program.tuition, style: text.titleMedium?.copyWith(fontWeight: FontWeight.w800, color: cs.primary)),
              ],
            ),

            const Spacer(),

            // Bottom meta row
            Row(
              children: [
                Expanded(child: Text('Duration: ${program.duration}', style: text.bodySmall?.copyWith(color: cs.onSurface.withOpacity(0.7)))),
                TextButton(onPressed: onTap, child: const Text('View program')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
