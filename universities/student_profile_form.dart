import 'dart:ui' as ui;
import 'package:flutter/material.dart';

const Color kPrimaryBlue = Color(0xFF0056B3);
const Color kPrimaryOrange = Color(0xFFFF6F3C);

class StudentProfileForm extends StatefulWidget {
  final double initialGpa;
  final double initialIelts;
  final List<String> initialSubjects;
  final String initialCountry;
  final List<String> countries;

  const StudentProfileForm({
    super.key,
    required this.initialGpa,
    required this.initialIelts,
    required this.initialSubjects,
    required this.initialCountry,
    required this.countries,
  });

  @override
  State<StudentProfileForm> createState() => _StudentProfileFormState();
}

class _StudentProfileFormState extends State<StudentProfileForm> {
  late double _gpa;
  late double _ielts;
  late List<String> _subjects;
  late String _country;

  final List<String> _availableSubjects = const [
    'Computer Science',
    'Business',
    'Engineering',
    'Design',
    'Law'
  ];

  @override
  void initState() {
    super.initState();
    _gpa = widget.initialGpa;
    _ielts = widget.initialIelts;
    _subjects = List.from(widget.initialSubjects);
    _country = widget.initialCountry;
  }

  Color _frostColor(BuildContext c) {
    final bright = Theme.of(c).brightness == Brightness.dark;
    return bright ? Colors.white.withOpacity(0.04) : Colors.white.withOpacity(0.22);
  }

  Color _cardColor(BuildContext c) {
    final bright = Theme.of(c).brightness == Brightness.dark;
    return bright ? Colors.black.withOpacity(0.6) : Colors.white.withOpacity(0.85);
  }

  Widget _glassTile({required Widget child, EdgeInsets padding = const EdgeInsets.all(12)}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: _frostColor(context),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.06)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0,6))],
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildRowTile(IconData icon, String title, {Widget? trailing, VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: _glassTile(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: kPrimaryBlue.withOpacity(0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: kPrimaryBlue, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15))),
            if (trailing != null) trailing,
          ]),
        ),
      ),
    );
  }

  Widget _buildChipsRow() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _availableSubjects.map((s) {
        final selected = _subjects.contains(s);
        return ChoiceChip(
          label: Padding(padding: const EdgeInsets.symmetric(horizontal:8.0, vertical:6), child: Text(s)),
          selected: selected,
          onSelected: (v) => setState(() => v ? _subjects.add(s) : _subjects.remove(s)),
          selectedColor: kPrimaryBlue.withOpacity(0.14),
          backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.03) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.withOpacity(0.12))),
          labelStyle: TextStyle(
            color: selected ? kPrimaryBlue : (Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black87),
            fontWeight: FontWeight.w600,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGradientButton({required VoidCallback onTap, required String text}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [kPrimaryBlue, kPrimaryOrange], begin: Alignment.centerLeft, end: Alignment.centerRight),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: kPrimaryBlue.withOpacity(0.28), blurRadius: 16, offset: const Offset(0,8))],
        ),
        child: Center(
          child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleColor = Theme.of(context).textTheme.titleLarge?.color ?? Theme.of(context).colorScheme.onSurface;
    final bodyColor = Theme.of(context).textTheme.bodyLarge?.color ?? Theme.of(context).colorScheme.onSurface;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.38,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: _cardColor(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // handle
              Center(child: Container(width: 48, height: 6, decoration: BoxDecoration(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade300, borderRadius: BorderRadius.circular(6)))),
              const SizedBox(height: 12),

              // title
              Align(alignment: Alignment.centerLeft, child: Text('Student profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: titleColor))),
              const SizedBox(height: 12),

              // content (scrollable)
              Expanded(
                child: ListView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildRowTile(
                      Icons.public,
                      'Country preference',
                      trailing: DropdownButton<String>(
                        value: _country,
                        underline: const SizedBox.shrink(),
                        items: widget.countries.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                        onChanged: (v) => setState(() { if (v!=null) _country = v; }),
                      ),
                    ),

                    const SizedBox(height: 14),

                    _buildRowTile(Icons.menu_book, 'Preferred subjects'),
                    const SizedBox(height: 8),
                    _buildChipsRow(),

                    const SizedBox(height: 18),

                    _buildRowTile(
                      Icons.school,
                      'GPA (scale: 0 - 5)',
                      trailing: Text(_gpa.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.w700)),
                    ),
                    Slider.adaptive(
                      value: _gpa,
                      min: 0,
                      max: 5.0,
                      divisions: 50,
                      onChanged: (v) => setState(() => _gpa = double.parse(v.toStringAsFixed(2))),
                    ),

                    const SizedBox(height: 8),

                    _buildRowTile(
                      Icons.record_voice_over,
                      'IELTS',
                      trailing: Text(_ielts.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.w700)),
                    ),
                    Slider.adaptive(
                      value: _ielts,
                      min: 0,
                      max: 9.0,
                      divisions: 18,
                      onChanged: (v) => setState(() => _ielts = double.parse(v.toStringAsFixed(1))),
                    ),

                    const SizedBox(height: 18),

                    // helper text
                    Text('Tip: select subjects and press Apply to refresh matches', style: TextStyle(color: bodyColor.withOpacity(0.9), fontWeight: FontWeight.w500)),

                    const SizedBox(height: 80), // leave spacing so content doesn't hide behind sticky bar
                  ],
                ),
              ),

              // sticky action bar
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Row(children: [
                  Expanded(child: _buildGradientButton(onTap: () => Navigator.pop(context, {
                    'gpa': _gpa,
                    'ielts': _ielts,
                    'subjects': _subjects,
                    'country': _country == 'Any' ? null : _country
                  }), text: 'Apply')),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _glassTile(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Center(child: Text('Cancel', style: TextStyle(fontWeight: FontWeight.w700, color: bodyColor))),
                      ),
                    ),
                  )
                ]),
              )
            ],
          ),
        );
      }
    );
  }
}
