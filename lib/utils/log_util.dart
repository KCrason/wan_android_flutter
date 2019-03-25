class LogUtil {
  static const logName = 'KCrason';
  static const isPrintLog = true;

  static void printLog(String logMessage) {
    if (isPrintLog) {
      print('$logName：$logMessage');
    }
  }

  static void printLogForName(String name, String logMessage) {
    if (isPrintLog) {
      print('$name：$logMessage');
    }
  }
}
