import 'package:flutter/material.dart';

class CurrencyService {
  // Complete mapping of currencies to country codes for flags
  static const Map<String, String> currencyToCountryCode = {
    // Major currencies
    'USD': 'us',
    'EUR': 'eu',
    'GBP': 'gb',
    'JPY': 'jp',
    'CAD': 'ca',
    'AUD': 'au',
    'CHF': 'ch',
    'CNY': 'cn',

    // Asia-Pacific
    'INR': 'in',
    'KRW': 'kr',
    'SGD': 'sg',
    'HKD': 'hk',
    'MYR': 'my',
    'THB': 'th',
    'PHP': 'ph',
    'IDR': 'id',
    'VND': 'vn',
    'TWD': 'tw',
    'BND': 'bn',
    'KHR': 'kh',
    'LAK': 'la',
    'MMK': 'mm',
    'NPR': 'np',
    'PKR': 'pk',
    'LKR': 'lk',
    'BDT': 'bd',
    'BTN': 'bt',
    'MVR': 'mv',
    'AFN': 'af',
    'KZT': 'kz',
    'KGS': 'kg',
    'UZS': 'uz',
    'TJS': 'tj',
    'TMT': 'tm',
    'MNT': 'mn',
    'KID': 'ki',
    'TVD': 'tv',
    'VUV': 'vu',
    'WST': 'ws',
    'TOP': 'to',
    'FJD': 'fj', 'PGK': 'pg', 'SBD': 'sb',

    // Europe
    'NOK': 'no',
    'SEK': 'se',
    'DKK': 'dk',
    'PLN': 'pl',
    'CZK': 'cz',
    'HUF': 'hu',
    'RON': 'ro',
    'BGN': 'bg',
    'HRK': 'hr',
    'RSD': 'rs',
    'MKD': 'mk',
    'BAM': 'ba',
    'ALL': 'al',
    'MDL': 'md',
    'UAH': 'ua',
    'BYN': 'by',
    'RUB': 'ru',
    'GEL': 'ge',
    'AMD': 'am',
    'AZN': 'az',
    'TRY': 'tr',
    'ISK': 'is',
    'FOK': 'fo',

    // Middle East
    'AED': 'ae',
    'SAR': 'sa',
    'QAR': 'qa',
    'KWD': 'kw',
    'BHD': 'bh',
    'OMR': 'om',
    'JOD': 'jo',
    'LBP': 'lb',
    'SYP': 'sy', 'IQD': 'iq', 'IRR': 'ir', 'YER': 'ye', 'ILS': 'il',

    // Africa
    'ZAR': 'za',
    'EGP': 'eg',
    'MAD': 'ma',
    'DZD': 'dz',
    'TND': 'tn',
    'LYD': 'ly',
    'NGN': 'ng',
    'GHS': 'gh',
    'KES': 'ke',
    'UGX': 'ug',
    'TZS': 'tz',
    'ETB': 'et',
    'RWF': 'rw',
    'ZMW': 'zm',
    'BWP': 'bw',
    'NAD': 'na',
    'SZL': 'sz',
    'LSL': 'ls',
    'MUR': 'mu',
    'SCR': 'sc',
    'MGA': 'mg',
    'KMF': 'km',
    'CVE': 'cv',
    'GMD': 'gm',
    'GNF': 'gn',
    'SLE': 'sl',
    'LRD': 'lr',
    'BIF': 'bi',
    'CDF': 'cd',
    'AOA': 'ao',
    'MZN': 'mz',
    'MWK': 'mw',
    'SDG': 'sd',
    'SSP': 'ss',
    'ERN': 'er',
    'DJF': 'dj',
    'SOS': 'so',
    'STN': 'st',
    'MRU': 'mr',
    'XOF': 'sn', // West African CFA franc - using Senegal as representative
    'XAF': 'cm', // Central African CFA franc - using Cameroon as representative
    // Americas
    'BRL': 'br',
    'MXN': 'mx',
    'ARS': 'ar',
    'COP': 'co',
    'PEN': 'pe',
    'CLP': 'cl',
    'UYU': 'uy',
    'PYG': 'py',
    'BOB': 'bo',
    'VES': 've',
    'GYD': 'gy',
    'SRD': 'sr',
    'TTD': 'tt',
    'JMD': 'jm',
    'BBD': 'bb',
    'BSD': 'bs',
    'HTG': 'ht',
    'DOP': 'do',
    'CUP': 'cu',
    'GTQ': 'gt',
    'BZD': 'bz',
    'HNL': 'hn',
    'NIO': 'ni',
    'CRC': 'cr',
    'PAB': 'pa',
    'AWG': 'aw',
    'ANG': 'cw',
    'BMD': 'bm',
    'KYD': 'ky',
    'XCD': 'ag', // East Caribbean Dollar - using Antigua
    // Special territories and dependencies
    'GGP': 'gg', // Guernsey Pound
    'IMP': 'im', // Isle of Man Pound
    'JEP': 'je', // Jersey Pound
    'FKP': 'fk', // Falkland Islands Pound
    'GIP': 'gi', // Gibraltar Pound
    'SHP': 'sh', // Saint Helena Pound
    'MOP': 'mo', // Macanese Pataca
    'XPF': 'pf', // CFP Franc - using French Polynesia
    'XCG': 'cw', // Caribbean Guilder - using Curaçao
  };

  static String getFlagUrl(String currencyCode, {int size = 580}) {
    final countryCode = currencyToCountryCode[currencyCode];
    if (countryCode != null) {
      // Using Flagpedia - reliable and high quality
      return 'https://flagpedia.net/data/flags/w$size/$countryCode.webp';
    }
    return '';
  }

  // Alternative sizes available: w160, w320, w580, w1160
  static String getFlagUrlWithSize(String currencyCode, String sizeVariant) {
    final countryCode = currencyToCountryCode[currencyCode];
    if (countryCode != null) {
      // sizeVariant can be: w160, w320, w580, w1160
      return 'https://flagpedia.net/data/flags/$sizeVariant/$countryCode.webp';
    }
    return '';
  }

  static bool hasFlagMapping(String currencyCode) {
    return currencyToCountryCode.containsKey(currencyCode);
  }
}

class SpecialCurrencyIcons {
  static Widget getSpecialIcon(String currencyCode, double size) {
    switch (currencyCode) {
      case 'XDR':
        return Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
          ),
          child: Center(
            child: Text(
              'SDR',
              style: TextStyle(
                color: Colors.white,
                fontSize: size * 0.2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );

      case 'XOF':
      case 'XAF':
        return Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.orange,
          ),
          child: Center(
            child: Text(
              'CFA',
              style: TextStyle(
                color: Colors.white,
                fontSize: size * 0.2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );

      default:
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[600],
          ),
          child: Center(
            child: Text(
              currencyCode.length >= 2
                  ? currencyCode.substring(0, 2)
                  : currencyCode,
              style: TextStyle(
                color: Colors.white,
                fontSize: size * 0.25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
    }
  }
}
