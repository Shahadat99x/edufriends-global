import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'student_profile_form.dart';
import 'university_card.dart';
import 'university_details.dart';

const Color kPrimaryOrange = Color(0xFFFF6F3C);
const Color kPrimaryBlue = Color(0xFF0056B3);
const Color kBackground = Color(0xFFF7F8FB);
const String backendBase = 'https://nonwithering-adam-uncabled.ngrok-free.dev'; // update to deployed URL
//const String backendBase = '192.168.0.107:4000';

class University {
  final String id;
  final String name;
  final String slug;
  final String city;
  final String? website;
  final String type;
  final String? countryId;
  final String? countryName;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<dynamic> programs;
  final int? matchScore;

  const University({
    required this.id,
    required this.name,
    required this.slug,
    required this.city,
    this.website,
    required this.type,
    this.countryId,
    this.countryName,
    this.createdAt,
    this.updatedAt,
    this.programs = const [],
    this.matchScore,
  });

  factory University.fromJson(Map<String, dynamic> j) => University(
    id: (j['_id'] ?? j['id'] ?? j['ID'] ?? '').toString(),
    name: j['name'] ?? 'Unknown',
    slug: j['slug'] ?? '',
    city: j['city'] ?? '',
    website: j['website'],
    type: j['type'] ?? 'public',
    countryId: j['countryId']?.toString(),
    countryName: j['country'] ?? j['countryName'] ?? j['country_name'],
    createdAt: j['createdAt'] != null ? DateTime.tryParse(j['createdAt'].toString()) : null,
    updatedAt: j['updatedAt'] != null ? DateTime.tryParse(j['updatedAt'].toString()) : null,
    programs: j['programs'] is List ? List.from(j['programs']) : const [],
    matchScore: j['matchScore'] != null ? (j['matchScore'] as num).toInt() : null,
  );
}

class UniversitiesScreen extends StatefulWidget {
  const UniversitiesScreen({super.key});

  @override
  State<UniversitiesScreen> createState() => _UniversitiesScreenState();
}

class _UniversitiesScreenState extends State<UniversitiesScreen> {
  List<University> _universities = const [];
  bool _loading = false;
  bool _hasProfile = false;

  double _gpa = 3.2;
  double _ielts = 6.0;
  List<String> _preferredSubjects = const ['Computer Science'];
  String? _countryPreference;

  final List<String> _countries = const [
    'Any', 'Lithuania','Romania','Hungary','Latvia','Estonia','Denmark','Bulgaria','Austria'
  ];

  Future<void> _submitProfileAndFetch() async {
    setState((){ _loading = true; });
    try {
      final items = await fetchUniversitiesFromApi(
        page: 0,
        pageSize: 80,
        country: _countryPreference,
        preferredSubjects: _preferredSubjects,
        gpa: _gpa,
        ielts: _ielts,
        backendBase: backendBase,
      );
      if (mounted) setState((){ _universities = items; _hasProfile = true; });
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fetch error: $e')));
    } finally {
      if (mounted) setState((){ _loading = false; });
    }
  }

  void _openProfileForm() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StudentProfileForm(
        initialGpa: _gpa,
        initialIelts: _ielts,
        initialSubjects: _preferredSubjects,
        initialCountry: _countryPreference ?? 'Any',
        countries: _countries,
      ),
    );

    if (result != null) {
      setState((){
        _gpa = result['gpa'];
        _ielts = result['ielts'];
        _preferredSubjects = List<String>.from(result['subjects']);
        _countryPreference = result['country'] == 'Any' ? null : result['country'];
      });
      await _submitProfileAndFetch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'EF',
                        style: TextStyle(fontWeight: FontWeight.w800, color: kPrimaryBlue),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SearchAndFilterRow(
                      onProfileTap: _openProfileForm,
                      hasProfile: _hasProfile,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _universities.isEmpty
                      ? Center(
                          child: Text(
                            _hasProfile ? 'No matches found' : 'Open profile to see university matches',
                            style: const TextStyle(color: Colors.black54),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ListView.separated(
                            padding: const EdgeInsets.only(bottom: 24, top: 6),
                            itemCount: _universities.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final u = _universities[index];
                              return UniversityCard(
                                university: u,
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => UniversityDetailsScreen(university: u),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openProfileForm,
        backgroundColor: kPrimaryOrange,
        child: const Icon(Icons.search, color: Colors.white),
      ),
    );
  }
}

class _SearchAndFilterRow extends StatelessWidget {
  final VoidCallback onProfileTap;
  final bool hasProfile;

  const _SearchAndFilterRow({super.key, required this.onProfileTap, required this.hasProfile});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onProfileTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.22),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.45)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.filter_list, color: kPrimaryBlue),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        hasProfile ? 'Refine profile & refresh' : 'Filter by profile',
                        style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black45),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Future<List<University>> fetchUniversitiesFromApi({
  required int page,
  required int pageSize,
  String? country,
  required List<String> preferredSubjects,
  required double gpa,
  required double ielts,
  required String backendBase,
}) async {
  final uri = Uri.parse('$backendBase/api/universities/match');
  final payload = {
    'country': country,
    'preferredSubjects': preferredSubjects,
    'gpa': gpa,
    'gpaScale': 5,
    'ielts': ielts,
    'acceptsInternational': true,
    'page': page,
    'pageSize': pageSize,
  };

  debugPrint('POST: $uri');
  debugPrint('payload: ${json.encode(payload)}');

  final resp = await http
      .post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      )
      .timeout(const Duration(seconds: 20));

  debugPrint('status: ${resp.statusCode}');
  debugPrint('body: ${resp.body}');

  if (resp.statusCode != 200) throw Exception('HTTP ${resp.statusCode}');
  final Map<String, dynamic> body = json.decode(resp.body) as Map<String, dynamic>;
  final raw = (body['universities'] ?? body['data'] ?? []) as List<dynamic>;

  final parsed = <University>[];
  for (final item in raw) {
    try {
      parsed.add(University.fromJson(Map<String, dynamic>.from(item as Map)));
    } catch (e, st) {
      debugPrint('parse error: $e');
      debugPrint(st.toString());
    }
  }
  return parsed;
}
