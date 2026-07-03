class CountryPhoneOption {
  const CountryPhoneOption({
    required this.name,
    required this.dialCode,
  });

  final String name;
  final String dialCode;
}

const countryPhoneOptions = <CountryPhoneOption>[
  CountryPhoneOption(name: 'Indonesia', dialCode: '+62'),
  CountryPhoneOption(name: 'Afghanistan', dialCode: '+93'),
  CountryPhoneOption(name: 'Albania', dialCode: '+355'),
  CountryPhoneOption(name: 'Algeria', dialCode: '+213'),
  CountryPhoneOption(name: 'Argentina', dialCode: '+54'),
  CountryPhoneOption(name: 'Australia', dialCode: '+61'),
  CountryPhoneOption(name: 'Austria', dialCode: '+43'),
  CountryPhoneOption(name: 'Bangladesh', dialCode: '+880'),
  CountryPhoneOption(name: 'Belgium', dialCode: '+32'),
  CountryPhoneOption(name: 'Brazil', dialCode: '+55'),
  CountryPhoneOption(name: 'Brunei', dialCode: '+673'),
  CountryPhoneOption(name: 'Cambodia', dialCode: '+855'),
  CountryPhoneOption(name: 'Canada', dialCode: '+1'),
  CountryPhoneOption(name: 'Chile', dialCode: '+56'),
  CountryPhoneOption(name: 'China', dialCode: '+86'),
  CountryPhoneOption(name: 'Colombia', dialCode: '+57'),
  CountryPhoneOption(name: 'Croatia', dialCode: '+385'),
  CountryPhoneOption(name: 'Czech Republic', dialCode: '+420'),
  CountryPhoneOption(name: 'Denmark', dialCode: '+45'),
  CountryPhoneOption(name: 'Egypt', dialCode: '+20'),
  CountryPhoneOption(name: 'Finland', dialCode: '+358'),
  CountryPhoneOption(name: 'France', dialCode: '+33'),
  CountryPhoneOption(name: 'Germany', dialCode: '+49'),
  CountryPhoneOption(name: 'Greece', dialCode: '+30'),
  CountryPhoneOption(name: 'Hong Kong', dialCode: '+852'),
  CountryPhoneOption(name: 'Hungary', dialCode: '+36'),
  CountryPhoneOption(name: 'India', dialCode: '+91'),
  CountryPhoneOption(name: 'Iraq', dialCode: '+964'),
  CountryPhoneOption(name: 'Ireland', dialCode: '+353'),
  CountryPhoneOption(name: 'Israel', dialCode: '+972'),
  CountryPhoneOption(name: 'Italy', dialCode: '+39'),
  CountryPhoneOption(name: 'Japan', dialCode: '+81'),
  CountryPhoneOption(name: 'Jordan', dialCode: '+962'),
  CountryPhoneOption(name: 'Kenya', dialCode: '+254'),
  CountryPhoneOption(name: 'Kuwait', dialCode: '+965'),
  CountryPhoneOption(name: 'Laos', dialCode: '+856'),
  CountryPhoneOption(name: 'Lebanon', dialCode: '+961'),
  CountryPhoneOption(name: 'Luxembourg', dialCode: '+352'),
  CountryPhoneOption(name: 'Macau', dialCode: '+853'),
  CountryPhoneOption(name: 'Malaysia', dialCode: '+60'),
  CountryPhoneOption(name: 'Mexico', dialCode: '+52'),
  CountryPhoneOption(name: 'Morocco', dialCode: '+212'),
  CountryPhoneOption(name: 'Myanmar', dialCode: '+95'),
  CountryPhoneOption(name: 'Netherlands', dialCode: '+31'),
  CountryPhoneOption(name: 'New Zealand', dialCode: '+64'),
  CountryPhoneOption(name: 'Nigeria', dialCode: '+234'),
  CountryPhoneOption(name: 'Norway', dialCode: '+47'),
  CountryPhoneOption(name: 'Pakistan', dialCode: '+92'),
  CountryPhoneOption(name: 'Philippines', dialCode: '+63'),
  CountryPhoneOption(name: 'Poland', dialCode: '+48'),
  CountryPhoneOption(name: 'Portugal', dialCode: '+351'),
  CountryPhoneOption(name: 'Qatar', dialCode: '+974'),
  CountryPhoneOption(name: 'Romania', dialCode: '+40'),
  CountryPhoneOption(name: 'Russia', dialCode: '+7'),
  CountryPhoneOption(name: 'Saudi Arabia', dialCode: '+966'),
  CountryPhoneOption(name: 'Singapore', dialCode: '+65'),
  CountryPhoneOption(name: 'Slovakia', dialCode: '+421'),
  CountryPhoneOption(name: 'South Africa', dialCode: '+27'),
  CountryPhoneOption(name: 'South Korea', dialCode: '+82'),
  CountryPhoneOption(name: 'Spain', dialCode: '+34'),
  CountryPhoneOption(name: 'Sri Lanka', dialCode: '+94'),
  CountryPhoneOption(name: 'Sweden', dialCode: '+46'),
  CountryPhoneOption(name: 'Switzerland', dialCode: '+41'),
  CountryPhoneOption(name: 'Taiwan', dialCode: '+886'),
  CountryPhoneOption(name: 'Thailand', dialCode: '+66'),
  CountryPhoneOption(name: 'Turkey', dialCode: '+90'),
  CountryPhoneOption(name: 'Ukraine', dialCode: '+380'),
  CountryPhoneOption(name: 'United Arab Emirates', dialCode: '+971'),
  CountryPhoneOption(name: 'United Kingdom', dialCode: '+44'),
  CountryPhoneOption(name: 'United States', dialCode: '+1'),
  CountryPhoneOption(name: 'Uruguay', dialCode: '+598'),
  CountryPhoneOption(name: 'Vietnam', dialCode: '+84'),
];

CountryPhoneOption defaultCountryPhoneOption = countryPhoneOptions.first;

({CountryPhoneOption country, String localNumber}) splitPhoneNumber(
  String raw,
) {
  final value = raw.trim();
  if (value.isEmpty) {
    return (country: defaultCountryPhoneOption, localNumber: '');
  }

  final sortedOptions = [...countryPhoneOptions]
    ..sort((a, b) => b.dialCode.length.compareTo(a.dialCode.length));

  for (final option in sortedOptions) {
    if (value.startsWith(option.dialCode)) {
      final localNumber = value.substring(option.dialCode.length).trim();
      return (country: option, localNumber: localNumber);
    }
  }

  return (country: defaultCountryPhoneOption, localNumber: value);
}
