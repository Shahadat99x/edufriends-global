import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openTel(String phone) async {
  final uri = Uri.parse('tel:$phone');
  if (!await launchUrl(uri)) debugPrint('Could not dial $phone');
}

Future<void> openWhatsApp(String phone, {String text = ''}) async {
  // number should be in international format without +
  final wa = Uri.parse('whatsapp://send?phone=$phone&text=${Uri.encodeComponent(text)}');
  final waWeb = Uri.parse('https://wa.me/$phone?text=${Uri.encodeComponent(text)}');
  if (!await launchUrl(wa, mode: LaunchMode.externalApplication)) {
    await launchUrl(waWeb, mode: LaunchMode.externalApplication);
  }
}

Future<void> openEmail(String to, {String subject = '', String body = ''}) async {
  final uri = Uri(
    scheme: 'mailto',
    path: to,
    queryParameters: {
      if (subject.isNotEmpty) 'subject': subject,
      if (body.isNotEmpty) 'body': body,
    },
  );
  await launchUrl(uri);
}

Future<void> openMaps(String query) async {
  final gmaps = Uri.parse('geo:0,0?q=${Uri.encodeComponent(query)}'); // Android
  final web = Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}');
  if (!await launchUrl(gmaps)) {
    await launchUrl(web, mode: LaunchMode.externalApplication);
  }
}

Future<void> openLink(String url) async {
  final uri = Uri.parse(url);
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}
