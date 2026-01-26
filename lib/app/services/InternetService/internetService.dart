import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class ConnectivityService {
  static final Connectivity _connectivity = Connectivity();
  static String connectionStatus = 'Unknown';
  static late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  static void Function()? onConnectedCallback;
  static OverlayEntry? _toastOverlayEntry; // Keep track of the current overlay entry

  static void initialize({void Function()? onConnected}) {
    onConnectedCallback = onConnected;
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    checkConnectivity();
  }

  static Future<void> checkConnectivity() async {
    List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      print('Could not check connectivity status: $e');
      connectionStatus = 'Error';
      return;
    }

    _updateConnectionStatus(result);
  }

  static void _updateConnectionStatus(List<ConnectivityResult> result) {
    connectionStatus = _getConnectionStatus(result);
    print('Current connectivity status: $connectionStatus');

    // Show or remove toast based on connection status
    if (result == ConnectivityResult.none) {
      _showToast('No Internet Connection');
    } else {
      _removeToast(); // Remove the toast when connection is restored
      onConnectedCallback?.call();
    }
  }

  // static String _getConnectionStatus(List<ConnectivityResult> result) {
  //   switch (result) {
  //     case ConnectivityResult.mobile:
  //       return 'Connected to Mobile Network';
  //     case ConnectivityResult.wifi:
  //       return 'Connected to WiFi';
  //     case ConnectivityResult.none:
  //       return 'No Internet Connection';
  //     default:
  //       return 'No Internet Connection';
  //   }
  // }

  static String _getConnectionStatus(List<ConnectivityResult> results) {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return 'No Internet Connection';
    }

    if (results.contains(ConnectivityResult.wifi)) {
      return 'Connected to WiFi';
    }

    if (results.contains(ConnectivityResult.mobile)) {
      return 'Connected to Mobile Network';
    }

    return 'No Internet Connection';
  }


  static void dispose() {
    _connectivitySubscription.cancel();
    _removeToast(); // Clean up the overlay entry on dispose
  }

  static void _showToast(String message) {
    if (_toastOverlayEntry != null) return; // Prevent multiple toasts

    // Define the overlay entry variable
    _toastOverlayEntry = OverlayEntry(
      builder: (BuildContext context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.85,
        left: MediaQuery.of(context).size.width * 0.25,
        right: MediaQuery.of(context).size.width * 0.25,
        child: Material(
          color: Colors.transparent,
          child: GestureDetector(
            // onTap: _removeToast, // Remove the toast on tap
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // Access the global overlay state
    final OverlayState? overlayState = navigatorKey.currentState?.overlay;
    if (overlayState != null) {
      overlayState.insert(_toastOverlayEntry!);
    }
  }

  static void _removeToast() {
    if (_toastOverlayEntry != null) {
      _toastOverlayEntry!.remove();
      _toastOverlayEntry = null;
    }
  }
}