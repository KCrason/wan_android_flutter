class Constants {
  static const String popularBannerUrl =
      'https://www.wanandroid.com/banner/json';

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

  static String unCollectionForMyCollectionPage(int articleId) {
    return 'https://www.wanandroid.com/lg/uncollect/$articleId/json';
  }

//  static String collectionOtherArticleUrl = 'https://www.wanandroid.com/lg/collect/add/json';

  static const String projectClassifyTabUrl =
      'https://www.wanandroid.com/project/tree/json';

  static String generateProjectListDataUrl(int classifyId, int curPage) {
    return 'https://www.wanandroid.com/project/list/$curPage/json?cid=$classifyId';
  }

  static String generateSystemArticleListDataUrl(int classifyId, int curPage) {
    return 'https://www.wanandroid.com/article/list/$curPage/json?cid=$classifyId';
  }

  static String generatePublicArticleListDataUrl(int publicId, int curPage) {
    return 'https://wanandroid.com/wxarticle/list/$publicId/$curPage/json';
  }

  static String generateNewArticleListDataUrl(int curPage) {
    return 'https://wanandroid.com/article/listproject/$curPage/json';
  }

  static String generateMyCollectionDataUrl(int curPage) {
    return 'https://www.wanandroid.com/lg/collect/list/$curPage/json';
  }

  static String generateSearchDataUrl(int curPage) {
    return 'https://www.wanandroid.com/article/query/$curPage/json';
  }

  static const String loginUrl = 'https://www.wanandroid.com/user/login';

  static const String registerUrl = 'https://www.wanandroid.com/user/register';

  static const String loginOutUrl =
      'https://www.wanandroid.com/user/logout/json';

  static const String publicTabDataUrl =
      'https://wanandroid.com/wxarticle/chapters/json';

  static const String preferenceKeyIsLogin = 'preferences_key_is_login';

  static const String preferenceKeyUserName = 'preferences_key_user_name';

  static const String systemDataUrl = 'https://www.wanandroid.com/tree/json';

  static const String topArticleDataUrl =
      'https://www.wanandroid.com/article/top/json';
}
