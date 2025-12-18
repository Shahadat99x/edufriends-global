import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'universities_screen.dart';

const Color kPrimaryBlue = Color(0xFF0056B3);
const Color kBackground = Color(0xFFF7F8FB);

class UniversityDetailsScreen extends StatelessWidget {
  final University university;
  const UniversityDetailsScreen({super.key, required this.university});

  Widget _label(String t) => Text(t, style: const TextStyle(fontSize: 13, color: Colors.black54));
  Widget _value(String t) => Text(t, style: const TextStyle(fontWeight: FontWeight.w700));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black87), onPressed: () => Navigator.pop(context)),
        title: const Text('University Details', style: TextStyle(color: Colors.black87)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // header card
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.72),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.6)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(university.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800))),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(color: kPrimaryBlue.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                              child: Text(university.type.toUpperCase(), style: const TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.w700)),
                            )
                          ],
                        ),

                        const SizedBox(height: 8),
                        Row(children: [const Icon(Icons.public, size: 16, color: kPrimaryBlue), const SizedBox(width: 8), Text(university.countryName ?? university.countryId ?? 'Unknown')]),
                        const SizedBox(height: 10),
                        Row(children: [const Icon(Icons.location_city, size: 16), const SizedBox(width: 8), Text(university.city.isNotEmpty ? university.city : '-'),]),
                        const SizedBox(height: 12),
                        if (university.website != null) SelectableText(university.website!, style: const TextStyle(color: Colors.blueAccent)),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // raw fields card
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.72),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.6)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('MongoDB Fields', style: TextStyle(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 8),

                        _label('ID'), const SizedBox(height: 4), _value(university.id), const SizedBox(height: 8),
                        _label('Slug'), const SizedBox(height: 4), _value(university.slug), const SizedBox(height: 8),
                        _label('CountryId'), const SizedBox(height: 4), _value(university.countryId ?? '-'), const SizedBox(height: 8),
                        _label('Created At'), const SizedBox(height: 4), _value(university.createdAt != null ? university.createdAt!.toIso8601String() : '-'), const SizedBox(height: 8),
                        _label('Updated At'), const SizedBox(height: 4), _value(university.updatedAt != null ? university.updatedAt!.toIso8601String() : '-'), const SizedBox(height: 12),

                        const Text('Programs', style: TextStyle(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 8),

                        if (university.programs.isEmpty) const Text('No program data returned', style: TextStyle(color: Colors.black54)),

                        if (university.programs.isNotEmpty)
                          ...university.programs.map<Widget>((p){
                            // program can be Map or simple string
                            final title = (p is Map && p['title'] != null) ? p['title'].toString() : (p is String ? p : 'Program');
                            final tuition = (p is Map && p['tuition_per_year_eur'] != null) ? p['tuition_per_year_eur'].toString() : null;
                            final duration = (p is Map && p['duration_years'] != null) ? p['duration_years'].toString() : null;
                            final degree = (p is Map && p['degree_type'] != null) ? p['degree_type'].toString() : null;

                            return Column(
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(title),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (degree != null) const Text('Degree: \$degree', style: TextStyle(color: Colors.black54)),
                                      if (duration != null) const Text('Duration: \$duration years', style: TextStyle(color: Colors.black54)),
                                      if (tuition != null) const Text('Tuition (EUR/year): €\$tuition', style: TextStyle(color: Colors.black54)),
                                    ],
                                  ),
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: () {
                                    // optionally navigate to program detail
                                  },
                                ),
                                const Divider(height: 8),
                              ],
                            );
                          }),

                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // actions
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // open website (add url_launcher package if you want to open links)
                        if (university.website != null) {
                          // implement launch
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: kPrimaryBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Text('Open Website')),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: () {
                      // save to favorites (local persistence) - implement as needed
                    },
                    style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Text('Save')),
                  ),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}
