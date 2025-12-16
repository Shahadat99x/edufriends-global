import 'package:flutter/material.dart';
import '../../common_widgets/glass_container.dart';
import '../../common_widgets/web/app_webview.dart';

class InfoStrip extends StatelessWidget {
  const InfoStrip({super.key, this.chips = const ['Visa Guidance Experts', 'Scholarship Advisories']});
  final List<String> chips;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    Widget chip(String label) {
      return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 240),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: cs.surface.withOpacity(0.06),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: cs.onSurface.withOpacity(0.06)),
          ),
          child: Text(
            label.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.bodySmall?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.6, color: cs.onSurface.withOpacity(0.9)),
          ),
        ),
      );
    }

    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      borderRadius: BorderRadius.circular(12),
      blur: 10,
      child: LayoutBuilder(builder: (context, constraints) {
        return Wrap(
          spacing: 10,
          runSpacing: 8,
          children: chips.map((c) => chip(c)).toList(),
        );
      }),
    );
  }
}

class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({required this.onAssessment, required this.onContact, super.key});
  final VoidCallback onAssessment;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget btn(IconData i, String label, VoidCallback onTap) => Expanded(
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: Ink(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: cs.onSurface.withOpacity(.06)),
              ),
              child: Column(
                children: [
                  Icon(i, color: cs.primary, size: 20),
                  const SizedBox(height: 6),
                  Text(label, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ),
        );

    return Row(children: [btn(Icons.assignment_turned_in_outlined, 'Assessment', onAssessment), const SizedBox(width: 10), btn(Icons.phone_in_talk_outlined, 'Contact', onContact)]);
  }
}

class ProfileEvaluationCard extends StatelessWidget {
  /// url should point to your Google Form. It will open inside the app via AppWebView.
  final String formUrl;
  final VoidCallback? onTap; // optional extra hook
  const ProfileEvaluationCard({super.key, required this.formUrl, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      borderRadius: BorderRadius.circular(14),
      blur: 10,
      child: Row(children: [
        // subtle icon box
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: cs.surface.withOpacity(0.06),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: cs.onSurface.withOpacity(0.04)),
          ),
          child: Icon(Icons.person_search_outlined, color: cs.primary),
        ),

        const SizedBox(width: 12),

        // text
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Profile Evaluation', style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text('Get program recommendations based on your background.', style: text.bodySmall?.copyWith(color: cs.onSurface.withOpacity(0.85))),
          ]),
        ),

        const SizedBox(width: 12),

        FilledButton(
          onPressed: () {
            // open google form inside app via AppWebView
            if (onTap != null) onTap!();
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => AppWebView(title: 'Profile Evaluation', initialUrl: formUrl)));
          },
          child: const Text('Start Now'),
        )
      ]),
    );
  }
}

class HighlightBanner extends StatelessWidget {
  const HighlightBanner({required this.title, required this.subtitle, required this.ctaText, required this.onTap, super.key});
  final String title; final String subtitle; final String ctaText; final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      borderRadius: BorderRadius.circular(14),
      blur: 10,
      child: Row(children: [
        Icon(Icons.star_border, color: Theme.of(context).colorScheme.secondary),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 4), Text(subtitle)])),
        const SizedBox(width: 12),
        FilledButton(onPressed: onTap, child: Text(ctaText))
      ]),
    );
  }
}

class TestimonialTeaser extends StatelessWidget {
  const TestimonialTeaser({super.key});
  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(14),
      borderRadius: BorderRadius.circular(16),
      blur: 10,
      child: Row(children: [
        const Icon(Icons.format_quote, size: 28),
        const SizedBox(width: 10),
        Expanded(child: Text('“EduFriends helped me pick the right program and get my TRP smoothly.” — Student', style: Theme.of(context).textTheme.bodyMedium)),
        TextButton(onPressed: () {}, child: const Text('Read more')),
      ]),
    );
  }
}

// FAQSection with 5 default items; answers shown when expanded
class FaqItem {
  final String question; final String answer; FaqItem(this.question, this.answer);
}

class FAQSection extends StatefulWidget {
  const FAQSection({super.key, this.items});
  final List<FaqItem>? items;
  @override State<FAQSection> createState() => _FAQSectionState();
}

class _FAQSectionState extends State<FAQSection> {
  late final List<FaqItem> _items;
  final Set<int> _open = {};

  @override void initState() {
    super.initState();
    _items = widget.items ?? [
      FaqItem('How soon can I receive program recommendations?', 'Typically within 48 hours after you submit your profile evaluation.'),
      FaqItem('Do you help with scholarship applications?', 'Yes — we advise on scholarship eligibility and the application process.'),
      FaqItem('Is there a fee for consultations?', 'We offer both free initial consultations and paid, tailored advising packages.'),
      FaqItem('Which countries support MOI-friendly admissions?', 'Many EU countries have MOI-friendly pathways; our advisors will filter programs accordingly.'),
      FaqItem('Can you support visa and housing arrangements?', 'Yes, we provide ongoing support through visa guidance and partner services for housing.'),
    ];
  }

  @override Widget build(BuildContext context) => Column(children: List.generate(_items.length, (i) => _buildItem(i, _items[i])));

  Widget _buildItem(int i, FaqItem item) {
    final bool open = _open.contains(i);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: GestureDetector(
        onTap: () => setState(() => open ? _open.remove(i) : _open.add(i)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.06))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Expanded(child: Text(item.question, style: Theme.of(context).textTheme.bodyLarge)), Icon(open ? Icons.remove : Icons.add, size: 18)]),
            if (open) ...[const SizedBox(height: 8), Text(item.answer, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant))]
          ]),
        ),
      ),
    );
  }
}
