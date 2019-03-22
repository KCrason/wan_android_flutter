class Constants {
  static String popularBannerUrl = 'https://www.wanandroid.com/banner/json';

  static String generatePopularArticleUrl(int _curPage) {
    return 'https://www.wanandroid.com/article/list/$_curPage/json';
  }

  static String generateCollectionListUrl(int _curPage) {
    return 'https://www.wanandroid.com/lg/collect/list/$_curPage/json';
  }

  static String generateCollectionWebsiteArticleUrl(String articleId) {
    return 'https://www.wanandroid.com/lg/collect/$articleId/json';
  }

  static String generateUnCollectionWebsiteArticleUrl(String articleId) {
    return 'https://www.wanandroid.com/lg/uncollect_originId/$articleId/json';
  }

//  static String collectionOtherArticleUrl = 'https://www.wanandroid.com/lg/collect/add/json';

  static String loginUrl = 'https://www.wanandroid.com/user/login';

  static String registerUrl = 'https://www.wanandroid.com/user/register';

  static String preferenceKeyIsLogin = 'preferences_key_is_login';
}
