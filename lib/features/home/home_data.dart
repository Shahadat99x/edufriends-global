import 'package:flutter/material.dart';

class HomeCountry {
  final String name;
  final String flagAsset;
  final String coverAsset;
  final String url;

  const HomeCountry({
    required this.name,
    required this.flagAsset,
    required this.coverAsset,
    required this.url,
  });
}

const popularCountries = <HomeCountry>[
  HomeCountry(
    name: 'Lithuania',
    flagAsset: 'assets/images/flags/lt.png',
    coverAsset: 'assets/images/countries/lt-cover.jpg',
    url: 'https://edufriendsglobal.com/lithuania',
  ),
  HomeCountry(
    name: 'Romania',
    flagAsset: 'assets/images/flags/ro.png',
    coverAsset: 'assets/images/countries/ro-cover.jpg',
    url: 'https://edufriendsglobal.com/romania',
  ),
  HomeCountry(
    name: 'Austria',
    flagAsset: 'assets/images/flags/at.png',
    coverAsset: 'assets/images/countries/at-cover.jpg',
    url: 'https://edufriendsglobal.com/austria',
  ),
  HomeCountry(
    name: 'Bulgaria',
    flagAsset: 'assets/images/flags/bg.png',
    coverAsset: 'assets/images/countries/bg-cover.jpg',
    url: 'https://edufriendsglobal.com/bulgaria',
  ),
  HomeCountry(
    name: 'Estonia',
    flagAsset: 'assets/images/flags/ee.png',
    coverAsset: 'assets/images/countries/ee-cover.jpg',
    url: 'https://edufriendsglobal.com/estonia',
  ),
  HomeCountry(
    name: 'Latvia',
    flagAsset: 'assets/images/flags/lv.png',
    coverAsset: 'assets/images/countries/lv-cover.jpg',
    url: 'https://edufriendsglobal.com/latvia',
  ),
  HomeCountry(
    name: 'Hungary',
    flagAsset: 'assets/images/flags/hu.png',
    coverAsset: 'assets/images/countries/hu-cover.jpg',
    url: 'https://edufriendsglobal.com/hungary',
  ),
  HomeCountry(
    name: 'Denmark',
    flagAsset: 'assets/images/flags/dk.png',
    coverAsset: 'assets/images/countries/dk-cover.jpg',
    url: 'https://edufriendsglobal.com/denmark',
  ),
];

class HomeService {
  final String title;
  final IconData icon;
  final String? url;

  const HomeService({
    required this.title,
    required this.icon,
    this.url,
  });
}

const homeServices = <HomeService>[
  HomeService(
    title: 'Profile Evaluation',
    icon: Icons.assignment_turned_in_outlined,
    url: 'https://...',
  ),
  HomeService(
    title: 'Visa & TRP Support',
    icon: Icons.badge_outlined,
    url: 'https://...',
  ),
  HomeService(
    title: 'Financial Docs',
    icon: Icons.receipt_long_outlined,
    url: 'https://...',
  ),
  HomeService(
    title: 'Interview Prep',
    icon: Icons.support_agent_outlined,
    url: 'https://...',
  ),
  HomeService(
    title: 'Offer Letter Steps',
    icon: Icons.description_outlined,
    url: 'https://...',
  ),
  HomeService(
    title: 'Document Attestation',
    icon: Icons.verified_outlined,
    url: 'https://...',
  ),
];
