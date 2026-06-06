import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:nb_utils/nb_utils.dart';

class NetworkService {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;
  NetworkService._internal() {
    _initialize();
  }

  final ValueNotifier<bool> isNetworkAvailable = ValueNotifier<bool>(true);

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  final Connectivity _connectivity = Connectivity();

  void _initialize() {
    checkInstantNetworkReflact();

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      _handleConnectivityChange(results);
    });
  }

  Future<void> _handleConnectivityChange(
    List<ConnectivityResult> results,
  ) async {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      isNetworkAvailable.value = false;
      log('No internet connection');
    } else {
      isNetworkAvailable.value = true;
      log('Internet connection available');
    }
  }

  Future<void> checkInstantNetworkReflact() async {
    try {
      final results = await _connectivity.checkConnectivity();
      if (results.isEmpty || results.contains(ConnectivityResult.none)) {
        isNetworkAvailable.value = false;
      } else {
        isNetworkAvailable.value = true;
      }
    } catch (e) {
      isNetworkAvailable.value = false;
    }
  }

  Future<bool> checkNetwork() async {
    try {
      final results = await _connectivity.checkConnectivity();
      return results.isNotEmpty && !results.contains(ConnectivityResult.none);
    } catch (e) {
      return false;
    }
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    isNetworkAvailable.dispose();
  }
}
