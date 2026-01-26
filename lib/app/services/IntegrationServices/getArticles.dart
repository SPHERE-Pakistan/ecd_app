import 'dart:convert';

import 'package:babysafe/app/apiEndPoint/api_endpoint.dart';
import 'package:babysafe/app/controllers/babyArticleController.dart';
import 'package:babysafe/app/controllers/pregnancyArticleController.dart';
import 'package:babysafe/models/BabyArticleResponseModel.dart';
import 'package:babysafe/app/services/ApiResponse/apiResponse.dart';
import 'package:babysafe/app/services/ApiServices/apiServices.dart';
import 'package:babysafe/app/utils/logUtils.dart';
import 'package:babysafe/app/utils/showMessages.dart';
import 'package:babysafe/app/widgets/loadingWidget.dart';
import 'package:babysafe/models/pregnancyArticlesModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class ArticleService {
  static final ArticleService instance = ArticleService._internal();

  final BabyArticleController babyArticleController = Get.find<BabyArticleController>();
  final PregnancyArticleController pregArticleController = Get.find<PregnancyArticleController>();

  factory ArticleService() {
    return instance;
  }

  ArticleService._internal();

  Future<void> getAllBabyArticles(BuildContext context, {bool isLoading = true}) async {
    try {
      if (isLoading) {
        LoaderWidget.instance.showLoading(
          message: "Getting baby articles\nplease wait",
        );
      }

      final result = await ApiService.getRequestData(
        ApiEndPoint.baseUrl+ApiEndPoint.getBabyArticles,
        context,
        useToken: false,
      );

      BabyArticleResponseModel responseModel = BabyArticleResponseModel.fromJson(result);

      // Update reactive list
      babyArticleController.setBabyArticleList = responseModel;

      if (isLoading) LoaderWidget.instance.hideLoading();
    } catch (e) {
      if (isLoading) LoaderWidget.instance.hideLoading();
      print("ApiException: $e");

      if (e is ApiException) {
        Map<String, dynamic> errorMessageJson = json.decode(e.message);
        String errorMessage = errorMessageJson['error'] ?? 'An error occurred';
        ShowMessage.notify(context, errorMessage.capitalizeFirst.toString());
      } else {
        ShowMessage.notify(context, e.toString());
      }
    }
  }

  Future<void> getAllPregArticles(BuildContext context, {bool isLoading = true}) async {
    try {
      if (isLoading) {
        LoaderWidget.instance.showLoading(
          message: "Getting pregnancy articles\nplease wait",
        );
      }

      final result = await ApiService.getRequestData(
        ApiEndPoint.baseUrl+ApiEndPoint.getPregnancyArticles,
        context,
        useToken: false,
      );

      PregnancyArticleResponseModel responseModel = PregnancyArticleResponseModel.fromJson(result);

      // Update reactive list
      pregArticleController.setBabyArticleList = responseModel;

      if (isLoading) LoaderWidget.instance.hideLoading();
    } catch (e) {
      if (isLoading) LoaderWidget.instance.hideLoading();
      print("ApiException: $e");

      if (e is ApiException) {
        Map<String, dynamic> errorMessageJson = json.decode(e.message);
        String errorMessage = errorMessageJson['error'] ?? 'An error occurred';
        ShowMessage.notify(context, errorMessage.capitalizeFirst.toString());
      } else {
        ShowMessage.notify(context, e.toString());
      }
    }
  }
}
