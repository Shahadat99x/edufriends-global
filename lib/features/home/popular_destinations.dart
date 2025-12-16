import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../common_widgets/popular_country_card_small.dart';
import 'home_data.dart';

/// PopularDestinationsAutoList - kept as a separate file with auto-scroll + parallax effect
class PopularDestinationsAutoList extends StatefulWidget {
  const PopularDestinationsAutoList({
    super.key,
    this.height = 160,
    this.fraction = 0.74,
    this.spacing = 12,
    this.period = const Duration(seconds: 3),
    this.onCardTap,
    this.contentMaxWidth = 640,
  });

  final double height;
  final double fraction; // 0.72..0.86 from responsive calc
  final double spacing; // space between cards
  final Duration period; // auto-scroll interval
  final void Function(HomeCountry country)? onCardTap;
  final double contentMaxWidth; // to compute card width when centered

  @override
  State<PopularDestinationsAutoList> createState() => _PopularDestinationsAutoListState();
}

class _PopularDestinationsAutoListState extends State<PopularDestinationsAutoList> {
  late final ScrollController _ctrl;
  Timer? _timer;

  // cached sizes
  late double _cardW;
  late double _itemExtent; // cardW + spacing

  @override
  void initState() {
    super.initState();
    _ctrl = ScrollController();

    _ctrl.addListener(() {
      if (mounted) setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _computeMetrics();
      _startAutoScroll();
    });
  }

  void _computeMetrics() {
    final screenW = MediaQuery.of(context).size.width;
    final availableW = screenW.clamp(0, widget.contentMaxWidth);
    _cardW = availableW * widget.fraction.clamp(0.6, 0.9);
    _itemExtent = _cardW + widget.spacing;
  }

  void _startAutoScroll() {
    _timer?.cancel();
    if (popularCountries.length <= 1) return;

    _timer = Timer.periodic(widget.period, (_) {
      if (!mounted || !_ctrl.hasClients) return;
      final max = _ctrl.position.maxScrollExtent;
      final next = _ctrl.offset + _itemExtent;

      if (next >= max) {
        _ctrl
            .animateTo(max, duration: const Duration(milliseconds: 340), curve: Curves.easeOutCubic)
            .then((_) => _ctrl.jumpTo(0));
      } else {
        _ctrl.animateTo(next, duration: const Duration(milliseconds: 340), curve: Curves.easeOutCubic);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _computeMetrics();

    final availableW = math.min(MediaQuery.of(context).size.width, widget.contentMaxWidth);
    final viewportCenterX = (_ctrl.hasClients ? _ctrl.offset : 0) + (availableW / 2);

    return SizedBox(
      height: widget.height,
      child: ListView.separated(
        controller: _ctrl,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(right: 4),
        itemCount: popularCountries.length,
        separatorBuilder: (_, __) => SizedBox(width: widget.spacing),
        itemBuilder: (context, i) {
          final c = popularCountries[i];

          final double itemStart = i * _itemExtent;
          final double itemCenter = itemStart + (_cardW / 2);
          final double distance = ((itemCenter - viewportCenterX).abs() / availableW).clamp(0.0, 1.0);

          const double scaleFactor = 0.14;
          final double scale = 1 - (distance * scaleFactor);
          final double translateY = (1 - scale) * 18;

          return SizedBox(
            width: _cardW,
            child: Transform.translate(
              offset: Offset(0, translateY),
              child: Transform.scale(
                scale: scale,
                alignment: Alignment.center,
                child: PopularCountryCardSmall(
                  title: c.name,
                  coverAsset: c.coverAsset,
                  flagAsset: c.flagAsset,
                  onTap: () => widget.onCardTap?.call(c),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
