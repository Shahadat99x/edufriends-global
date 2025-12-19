import 'package:flutter/material.dart';
import 'package:edufriends_global/features/home/home_data.dart';
import 'package:edufriends_global/common_widgets/popular_country_card_small.dart';
import 'package:edufriends_global/common_widgets/web/app_webview.dart';
import 'package:edufriends_global/common_widgets/glass_container.dart';


class CountriesScreen extends StatefulWidget {
  const CountriesScreen({super.key});


  @override
  State<CountriesScreen> createState() => _CountriesScreenState();
}


class _CountriesScreenState extends State<CountriesScreen> {
  final TextEditingController _search = TextEditingController();
  String _query = '';
  String _selectedTag = 'All';


  // region sets
  static const Set<String> _baltics = {'Lithuania', 'Latvia', 'Estonia'};
  static const Set<String> _cee = {'Romania', 'Bulgaria', 'Hungary'};
  static const Set<String> _eu = {
    'Lithuania',
    'Latvia',
    'Estonia',
    'Romania',
    'Bulgaria',
    'Hungary',
    'Austria',
    'Denmark'
  };


  @override
  void initState() {
    super.initState();
    _search.addListener(() {
      setState(() => _query = _search.text.trim().toLowerCase());
    });
  }


  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }


  List<HomeCountry> _filtered() {
    const list = popularCountries;
    final q = _query;
    if (q.isEmpty && _selectedTag == 'All') return list;


    return list.where((c) {
      final name = c.name;
      final matchName = q.isEmpty || name.toLowerCase().contains(q);
      final matchTag = switch (_selectedTag) {
        'All' => true,
        'EU' => _eu.contains(name),
        'Baltics' => _baltics.contains(name),
        'CEE' => _cee.contains(name),
        _ => true,
      };
      return matchName && matchTag;
    }).toList();
  }


  int _crossAxisCount(double w) {
    if (w >= 1000) return 4;
    if (w >= 720) return 3;
    return 2;
  }


  double _childAspectRatio(double w) {
    if (w >= 1000) return 1.5;
    if (w >= 720) return 1.42;
    return 1.35;
  }


  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final results = _filtered();


    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Sticky search + filters (no page title here — global AppBar shows it)
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            toolbarHeight: 0,
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(124),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                child: GlassContainer(
                  blur: 12,
                  borderRadius: BorderRadius.circular(14),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      _SearchField(controller: _search),
                      const SizedBox(height: 12),
                      _TagRow(
                        selected: _selectedTag,
                        onChanged: (val) => setState(() => _selectedTag = val),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),


          // Use SliverSafeArea for bottom handling (no more overflow)
          SliverSafeArea(
            top: false,
            bottom: true,
            sliver: SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _crossAxisCount(size.width),
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: _childAspectRatio(size.width),
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final c = results[i];
                    return _CountryCardPolished(
                      title: c.name,
                      coverAsset: c.coverAsset,
                      flagAsset: c.flagAsset,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                AppWebView(title: c.name, initialUrl: c.url),
                          ),
                        );
                      },
                    );
                  },
                  childCount: results.length,
                ),
              ),
            ),
          ),


          if (results.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    'No countries found.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}


/* ---------- small UI bits ---------- */


class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller});
  final TextEditingController controller;


  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search country',
        prefixIcon: Icon(Icons.search, color: cs.onSurfaceVariant),
        filled: true,
        fillColor: cs.surface.withOpacity(0.06),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cs.outline.withOpacity(0.06)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cs.outline.withOpacity(0.06)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cs.primary.withOpacity(0.9)),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      ),
    );
  }
}


class _TagRow extends StatelessWidget {
  const _TagRow({required this.selected, required this.onChanged});
  final String selected;
  final ValueChanged<String> onChanged;


  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const tags = ['All', 'EU', 'Baltics', 'CEE'];


    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final t in tags) ...[
            ChoiceChip(
              label: Text(t),
              selected: selected == t,
              onSelected: (_) => onChanged(t),
              selectedColor: cs.primary.withOpacity(0.14),
              backgroundColor: cs.surface.withOpacity(0.04),
              labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight:
                        selected == t ? FontWeight.w700 : FontWeight.w500,
                    color:
                        selected == t ? cs.primary : cs.onSurfaceVariant,
                  ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(
                  color: selected == t
                      ? cs.primary.withOpacity(.28)
                      : cs.outline.withOpacity(.18),
                ),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              elevation: 0,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}


class _CountryCardPolished extends StatelessWidget {
  const _CountryCardPolished({
    required this.title,
    required this.coverAsset,
    required this.flagAsset,
    required this.onTap,
  });


  final String title;
  final String coverAsset;
  final String flagAsset;
  final VoidCallback onTap;


  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: cs.shadow.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: PopularCountryCardSmall(
              title: title,
              coverAsset: coverAsset,
              flagAsset: flagAsset,
              onTap: onTap,
            ),
          ),
        ),
      ),
    );
  }
}
