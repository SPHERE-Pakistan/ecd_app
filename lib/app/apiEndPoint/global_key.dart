import 'dart:io';

import 'package:flutter/material.dart';
final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

class KeyConstants {
  static const String accessToken = 'accessToken';
  static const String refreshToken = 'refreshToken';
  static const String userId = 'userId';
  static const String fcmToken = 'fcmToken';


}

class GlobalVariables {
  static String globalCurrency = "";
  static String about = "";
  static String userId = "";
  static bool isBusiness = false;
  static bool isGuest = false;

  // Method to set global currency
  static void setGlobalCurrency(String currency) {
    globalCurrency = currency;
  }

  static void setAbout(String about2) {
    about = about2;
  }

  // Method to get global currency
  static String getGlobalCurrency() {
    return globalCurrency;
  }

  static void setUserId(String id) {
    userId = id;
  }

  static String getUserId() {
    return userId;
  }

  static String getAbout() {
    return about;
  }

  static void setBusiness(bool business){
    isBusiness = business;
  }

  static void setGuest(bool guest){
    isGuest = guest;
  }

  static bool getGuest(){
    return isGuest;
  }

  static bool getBusiness(){
    return isBusiness;
  }

  static bool getIphone() => Platform.isIOS;

}
