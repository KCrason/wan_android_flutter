class Constants {
  static String popularBannerUrl = 'https://www.wanandroid.com/banner/json';

  static String generatePopularArticleUrl(int _curPage) {
    return 'https://www.wanandroid.com/article/list/$_curPage/json';
  }

  static String loginUrl = 'https://www.wanandroid.com/user/login';

  static String registerUrl = 'https://www.wanandroid.com/user/register';
}
