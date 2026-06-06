import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/network/api_configs.dart';
import 'package:refashion/app/network/api_service.dart';
import '../model/currency_model.dart';

class CurrencyApiService {
  final ApiService _apiService = ApiService();

  Future<CurrenciesModel> fetchCurrencies({
    int limit = 250,
    String? search,
  }) async {
    try {
      String url = '${ApiConfig.storeCurrencies}?limit=$limit';
      if (search != null && search.isNotEmpty) {
        url += '&q=$search';
      }
      final response = await _apiService.get(url);
      return CurrenciesModel.fromJson(response);
    } catch (e) {
      log(e.toString());
      return CurrenciesModel();
    }
  }
}
