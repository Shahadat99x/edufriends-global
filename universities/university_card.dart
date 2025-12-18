import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'universities_screen.dart';

const Color kPrimaryBlue = Color(0xFF0056B3);
const double _cornerRadius = 16.0;

class UniversityCard extends StatelessWidget {
  final University university;
  final VoidCallback onTap;
  const UniversityCard({super.key, required this.university, required this.onTap});

  Widget _rowLabelValue(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.5),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontSize: 13, color: Colors.black54)),
          ),
          Expanded(
            child: Text(
              value ?? '-',
              style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_cornerRadius),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(_cornerRadius),
              border: Border.all(color: Colors.white.withOpacity(0.4)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        university.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: kPrimaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        university.type.toUpperCase(),
                        style: const TextStyle(
                          color: kPrimaryBlue,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 8),
                _rowLabelValue('Country', university.countryName ?? university.countryId ?? 'Unknown'),
                _rowLabelValue('City', university.city.isNotEmpty ? university.city : 'Unknown'),
                _rowLabelValue('Programs', university.programs.isNotEmpty ? university.programs.length.toString() : '0'),

                if (university.website != null) ...[
                  const SizedBox(height: 4),
                  _rowLabelValue('Website', university.website),
                ],

                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton.icon(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                    icon: const Icon(Icons.visibility, size: 16, color: Colors.white),
                    label: const Text(
                      'View',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}