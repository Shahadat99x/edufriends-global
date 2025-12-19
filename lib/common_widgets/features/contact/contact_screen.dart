import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:edufriends_global/core/utils/launchers.dart';
import 'package:edufriends_global/common_widgets/glass_container.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  // Update these to your real values
  static const phoneBD = '+8801512716362';
  static const waNumber = '48571577245'; // WhatsApp intl format WITHOUT +
  static const email = 'info@edufriendsglobal.com';
  static const officeAddress =
      '32 Purana Paltan, Dhaka 1000';
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    Widget sectionTitle(String text) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
          child: Text(text,
              style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        );

    return SafeArea(
      top: false,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 28),
        children: [
          // Hero/info panel (glass)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: GlassContainer(
              borderRadius: BorderRadius.circular(14),
              padding: const EdgeInsets.all(14),
              blur: 10,
              child: Row(
                children: [
                  // support badge
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: cs.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.support_agent_rounded, color: cs.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'We’re here to help with admissions, TRP & visa queries. Reach us via phone, WhatsApp, email or visit our office.',
                      style: t.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),

          sectionTitle('Phone & WhatsApp'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GlassContainer(
              padding: const EdgeInsets.symmetric(vertical: 8),
              borderRadius: BorderRadius.circular(12),
              blur: 10,
              child: Column(
                children: [
                  ContactRow(
                    leadingIcon: Icons.phone_rounded,
                    leadingColor: cs.primary,
                    title: 'Phone',
                    subtitle: phoneBD,
                    onTap: () => openTel(phoneBD),
                  ),
                  const Divider(height: 1),
                  ContactRow(
                    leadingIcon: FontAwesomeIcons.whatsapp,
                    leadingColor: const Color(0xFF25D366),
                    title: 'WhatsApp',
                    subtitle: '+$waNumber',
                    onTap: () =>
                        openWhatsApp(waNumber, text: 'Hello EduFriends!'),
                  ),
                ],
              ),
            ),
          ),

          sectionTitle('Email'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GlassContainer(
              padding: const EdgeInsets.symmetric(vertical: 8),
              borderRadius: BorderRadius.circular(12),
              blur: 10,
              child: ContactRow(
                leadingIcon: Icons.mail_rounded,
                leadingColor: cs.secondary,
                title: email,
                onTap: () =>
                    openEmail(email, subject: 'Inquiry from EduFriends app'),
              ),
            ),
          ),

          sectionTitle('Office'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GlassContainer(
              padding: const EdgeInsets.symmetric(vertical: 8),
              borderRadius: BorderRadius.circular(12),
              blur: 10,
              child: ContactRow(
                leadingIcon: Icons.place_rounded,
                leadingColor: cs.primary,
                title: 'Find us on Maps',
                subtitle: officeAddress,
                onTap: () => openMaps(officeAddress),
              ),
            ),
          ),

          sectionTitle('Follow us'),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 6, 16, 8),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _SocialPill(
                  icon: FontAwesomeIcons.facebookF,
                  label: 'Facebook',
                  url: 'https://facebook.com/EduFriendsGlobal',
                ),
                _SocialPill(
                  icon: FontAwesomeIcons.linkedinIn,
                  label: 'LinkedIn',
                  url: 'https://linkedin.com/company/EdufriendsGlobal',
                ),
                _SocialPill(
                  icon: FontAwesomeIcons.youtube,
                  label: 'YouTube',
                  url: 'https://youtube.com/EdufriendsGlobal',
                ),
                _SocialPill(
                  icon: FontAwesomeIcons.xTwitter,
                  label: 'X',
                  url: 'https://x.com/edufriendsgbl',
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),
        ],
      ),
    );
  }
}

/// Small reusable row used on the contact page.
/// Shows a circular leading icon, title, optional subtitle and a small chevron.
class ContactRow extends StatelessWidget {
  const ContactRow({
    super.key,
    required this.leadingIcon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.leadingColor,
  });

  final IconData leadingIcon;
  final Color? leadingColor;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: (leadingColor ?? cs.primary).withOpacity(0.12),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: cs.outline.withOpacity(.06)),
        ),
        child: Center(
          child: Icon(leadingIcon, color: leadingColor ?? cs.primary, size: 20),
        ),
      ),
      title: Text(title, style: t.titleSmall),
      subtitle: subtitle == null ? null : Text(subtitle!, style: t.bodySmall),
      trailing: Icon(Icons.chevron_right_rounded, color: cs.outline),
    );
  }
}

/// Social pill button (rounded)
class _SocialPill extends StatelessWidget {
  const _SocialPill({
    required this.icon,
    required this.label,
    required this.url,
  });

  final IconData icon;
  final String label;
  final String url;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () => openLink(url),
      borderRadius: BorderRadius.circular(24),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: cs.outline.withOpacity(.12)),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withOpacity(.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(icon, size: 16, color: cs.primary),
            const SizedBox(width: 8),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
