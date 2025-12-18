import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AppWebView extends StatefulWidget {
  const AppWebView({
    super.key,
    required this.title,
    required this.initialUrl,
  });

  final String title;       // e.g., "Lithuania"
  final String initialUrl;  // country page URL

  @override
  State<AppWebView> createState() => _AppWebViewState();
}

class _AppWebViewState extends State<AppWebView> {
  WebViewController? _controller; // null on web
  int _progress = 0;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();

    // In-app WebView only on Android/iOS. Chrome preview has no in-app WebView.
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.transparent)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (p) => setState(() => _progress = p),
            onWebResourceError: (_) => setState(() => _hasError = true),
          ),
        )
        ..loadRequest(Uri.parse(widget.initialUrl));

      _controller = controller;
    }
  }

  Future<void> _reload() async {
    setState(() => _hasError = false);
    await _controller?.reload();
  }

  PreferredSizeWidget _progressBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(2),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: (_controller != null && _progress < 100 && !_hasError) ? 2 : 0,
        width: MediaQuery.of(context).size.width * (_progress / 100),
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Chrome preview stub
    if (kIsWeb) {
      return Scaffold(
        appBar: _ModernBrandAppBar(title: widget.title),
        body: const Center(
          child: Text('In-app WebView is available on Android/iOS builds.'),
        ),
      );
    }

    // Android/iOS: stay inside the app
    return Scaffold(
      appBar: _ModernBrandAppBar(
        title: widget.title,
        trailing: IconButton(
          tooltip: 'Refresh',
          icon: const Icon(Icons.refresh),
          onPressed: _controller == null ? null : _reload,
        ),
        bottom: _progressBar(context),
      ),
      body: _hasError
          ? _ErrorBody(onRetry: _reload)
          : (_controller == null
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _reload,
                  child: WebViewWidget(controller: _controller!),
                )),
    );
  }
}

/* ───────────────────── Modern AppBar: pill back + logo + country name ───────────────────── */

class _ModernBrandAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ModernBrandAppBar({
    required this.title,
    this.trailing,
    this.bottom,
  });

  final String title;                       // country name
  final Widget? trailing;                   // optional right-side action (e.g., Refresh)
  final PreferredSizeWidget? bottom;        // optional progress bar

  @override
  Size get preferredSize =>
      Size.fromHeight(56 + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t  = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      titleSpacing: 0,
      leadingWidth: 60,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: InkWell(
          onTap: () => Navigator.of(context).maybePop(),
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest.withOpacity(.60),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: cs.outline.withOpacity(.18)),
            ),
            child: Center(
              child: Icon(Icons.arrow_back_rounded, size: 22, color: cs.onSurface),
            ),
          ),
        ),
      ),

      // Brand + country name row, balanced and responsive
      title: Row(
        children: [
          // Logo (adaptive to theme)
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 130, maxHeight: 34),
            child: Image.asset(
              isDark
                  ? 'assets/images/brand/edufriends_logo_dark.png'
                  : 'assets/images/brand/edufriends_logo.png',
              fit: BoxFit.contain,
              filterQuality: FilterQuality.medium,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),

          // Vertical divider for a premium feel
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width: 1,
            height: 20,
            color: cs.outlineVariant.withOpacity(.5),
          ),

          // Country name
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: t.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: .2,
              ),
            ),
          ),
        ],
      ),

      actions: [
        if (trailing != null)
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: trailing!,
          ),
      ],

      // Subtle bottom divider (or the progress bar when provided)
      bottom: bottom ??
          PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              height: 1,
              color: cs.outlineVariant.withOpacity(.4),
            ),
          ),
    );
  }
}

/* ───────────────────────────────── Error UI ───────────────────────────────── */

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.onRetry});
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off, size: 36),
          const SizedBox(height: 8),
          Text('Failed to load page', style: t.titleMedium),
          const SizedBox(height: 6),
          Text('Check your connection and try again.', style: t.bodySmall),
          const SizedBox(height: 12),
          FilledButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
