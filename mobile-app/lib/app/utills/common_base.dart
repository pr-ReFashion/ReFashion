import 'package:country_picker/country_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/image_helper.dart';

List<LanguageDataModel> languageList() {
  return [
    LanguageDataModel(
      id: 2,
      name: 'English',
      languageCode: AppLanguage.defaultAppLang,
      fullLanguageCode: 'en-US',
      flag: ImageHelper.isUs,
    ),
  ];
}

Country get defaultCountry {
  return Country(
    phoneCode: '30',
    countryCode: 'GR',
    e164Sc: -1,
    geographic: false,
    level: -1,
    name: 'World Wide',
    example: '',
    displayName: 'World Wide (WW)',
    displayNameNoCountryCode: 'World Wide',
    e164Key: '',
  );
}
