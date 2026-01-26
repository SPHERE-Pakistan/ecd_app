class BabyArticleResponseModel {
  bool? success;
  Data? data;

  BabyArticleResponseModel({this.success, this.data});

  BabyArticleResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Articles>? articles;
  Pagination? pagination;

  Data({this.articles, this.pagination});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['articles'] != null) {
      articles = <Articles>[];
      json['articles'].forEach((v) {
        articles!.add(new Articles.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.articles != null) {
      data['articles'] = this.articles!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Articles {
  int? id;
  String? title;
  String? content;
  String? summary;
  String? imageUrl;
  String? category;
  int? monthNumber;
  String? author;
  bool? isPublished;
  int? viewCount;
  String? createdAt;
  String? updatedAt;

  Articles(
      {this.id,
        this.title,
        this.content,
        this.summary,
        this.imageUrl,
        this.category,
        this.monthNumber,
        this.author,
        this.isPublished,
        this.viewCount,
        this.createdAt,
        this.updatedAt});

  Articles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    summary = json['summary'];
    imageUrl = json['image_url'];
    category = json['category'];
    monthNumber = json['month_number'];
    author = json['author'];
    isPublished = json['is_published'];
    viewCount = json['view_count'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    data['summary'] = this.summary;
    data['image_url'] = this.imageUrl;
    data['category'] = this.category;
    data['month_number'] = this.monthNumber;
    data['author'] = this.author;
    data['is_published'] = this.isPublished;
    data['view_count'] = this.viewCount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Pagination {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;

  Pagination({this.currentPage, this.lastPage, this.perPage, this.total});

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['last_page'] = this.lastPage;
    data['per_page'] = this.perPage;
    data['total'] = this.total;
    return data;
  }
}
