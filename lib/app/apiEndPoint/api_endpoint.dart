import 'package:flutter/cupertino.dart';

@immutable
class ApiEndPoint {
  const ApiEndPoint._();
  static const baseUrl = 'http://ecd.mhn.services/';
  static const getBabyArticles = "api/baby-articles";
  static const getPregnancyArticles = "api/pregnancy-articles";

}