import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/network/api_configs.dart';
import 'package:refashion/app/network/api_service.dart';
import '../model/locale_list_model.dart';

class LocaleApiService {
  final ApiService _apiService = ApiService();

  Future<LocaleListModel> fetchLocales() async {
    try {
      final response = await _apiService.get(ApiConfig.storeLocales);
      return LocaleListModel.fromJson(response);
    } catch (e) {
      log(e.toString());
      return LocaleListModel();
    }
  }
}
