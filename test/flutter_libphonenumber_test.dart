import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:flutter_libphonenumber/src/input_formatter/phone_mask.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PhoneMask', () {
    test('UK mobile international', () {
      final mask = PhoneMask(
        CountryWithPhoneCode.gb().getPhoneMask(
              format: PhoneNumberFormat.international,
              type: PhoneNumberType.mobile,
            ) ??
            '',
      );
      expect(mask.apply('+447752513731'), '+44 7752 513731');
    });

    test('Italian mobile international', () {
      final mask = PhoneMask('+00 000 000 0000');
      expect(mask.apply('+393937224790'), '+39 393 722 4790');
    });

    test('Austrian 11 character number', () {
      final mask = PhoneMask('+00 000 000 0000');
      expect(mask.apply('+393937224790'), '+39 393 722 4790');
    });

    group('getCountryDataByPhone', () {
      test('US number', () async {
        await CountryManager().loadCountries(overrides: {
          'US': CountryWithPhoneCode.us(),
        });

        final res = CountryWithPhoneCode.getCountryDataByPhone('+14199139457');
        expect(res?.countryCode, 'US');
      });
    });


    group('Check formatNumberSync method', () {
      test('US number without code', () async {
        await CountryManager().loadCountries(overrides: {
          'US': CountryWithPhoneCode.us(),
        });

        final res = FlutterLibphonenumber().formatNumberSync('+14199139457', removeCountryCode: true);
        expect(res, '419-913-9457');
      });

      test('US number with code', () async {
        await CountryManager().loadCountries(overrides: {
          'US': CountryWithPhoneCode.us(),
        });

        final res = FlutterLibphonenumber().formatNumberSync('+14199139457', removeCountryCode: false);
        expect(res, '+1 419-913-9457');
      });
    });

    group('Check LibPhonenumberTextFormatter', () {

      test('formater for TextField with contry code in text', () async {
        final res = LibPhonenumberTextFormatter(
          country: CountryWithPhoneCode.us(),
          phoneNumberType: PhoneNumberType.mobile,
          phoneNumberFormat: PhoneNumberFormat.international,
          hideCountryCode: false,
        ).formatEditUpdate(
            TextEditingValue.empty,
            TextEditingValue(
                text: '+14199139457',
            ),
        );
        expect(res.text, '+1 419-913-9457');
      });

      test('formater for TextField without contry code in text', () async {
        final res = LibPhonenumberTextFormatter(
          country: CountryWithPhoneCode.us(),
          phoneNumberType: PhoneNumberType.mobile,
          phoneNumberFormat: PhoneNumberFormat.international,
          hideCountryCode: true,
        ).formatEditUpdate(
          TextEditingValue.empty,
          TextEditingValue(
            text: '4199139457',
          ),
        );
        expect(res.text, '419-913-9457');
      });
    });

  });
}
