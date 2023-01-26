import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkConnection
{
  static Future<bool> isNotConnected() async {

    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      return false;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      return false;
    }

    return true;
  }
}