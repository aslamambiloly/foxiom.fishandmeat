import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final isConnected = false.obs;
  late final StreamSubscription<List<ConnectivityResult>> _connectivitySub;
  late final InternetConnectionChecker _internetChecker;
  late final StreamSubscription<InternetConnectionStatus> _internetSub;

  @override
  void onInit() {
    super.onInit();

    _connectivitySub = Connectivity().onConnectivityChanged.listen((results) {
      final result =
          results.isNotEmpty ? results.first : ConnectivityResult.none;
      _onConnectivityChanged(result);
    });

    _internetChecker = InternetConnectionChecker.createInstance();
    _internetSub = _internetChecker.onStatusChange.listen(
      _onInternetStatusChanged,
    );

    _initStatus();
  }

  Future<void> _initStatus() async {
    final raw = await Connectivity().checkConnectivity();
    final first = raw.isNotEmpty ? raw.first : ConnectivityResult.none;
    _onConnectivityChanged(first);

    final hasInternet = await _internetChecker.hasConnection;
    isConnected.value = hasInternet;
  }

  void _onConnectivityChanged(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      isConnected.value = false;
    }
  }

  void _onInternetStatusChanged(InternetConnectionStatus status) {
    isConnected.value = status == InternetConnectionStatus.connected;
  }

  void retry() {
    _initStatus();
  }

  @override
  void onClose() {
    _connectivitySub.cancel();
    _internetSub.cancel();
    super.onClose();
  }
}
