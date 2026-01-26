import 'package:babysafe/models/pregnancyArticlesModel.dart';
import 'package:get/get.dart';

class PregnancyArticleController extends GetxController {
  // Reactive list of articles
  var articles = <PregnancyArticles>[].obs;

  // Setter to update the articles list from API
  set setBabyArticleList(PregnancyArticleResponseModel model) {
    articles.value = model.data?.articles ?? [];
  }
}