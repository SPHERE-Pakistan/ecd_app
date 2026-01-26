import 'package:babysafe/models/BabyArticleResponseModel.dart';
import 'package:get/get.dart';

class BabyArticleController extends GetxController {
  // Reactive list of articles
  var articles = <Articles>[].obs;

  // Setter to update the articles list from API
  set setBabyArticleList(BabyArticleResponseModel model) {
    articles.value = model.data?.articles ?? [];
  }
}