enum Environment { STAGING, PRODUCTION }

class AppConfig {
  // Yeh variable environment status ko hold karega (staging ya production)
  final Environment environment;

  // Yeh aapka base URL hold karega
  final String baseUrl;

  // Constructor
  AppConfig({required this.environment, required this.baseUrl});

  // Yeh ek static variable hai jo AppConfig ka instance store karega
  static AppConfig? _instance;

  // Jab app shuru hoga, to hum is function ko call karke environment set karenge
  static void init(Environment env) {
    if (_instance == null) {
      String baseUrl;
      switch (env) {
        case Environment.STAGING:
          baseUrl = 'https://staging.zaika.ltd';
          break;
        case Environment.PRODUCTION:
          baseUrl = 'https://zaika.ltd';
          break;
      }
      _instance = AppConfig(environment: env, baseUrl: baseUrl);
    }
  }

  // Is getter se hum AppConfig ka instance poore app mein kahin bhi access kar sakte hain
  static AppConfig get instance {
    if (_instance == null) {
      throw Exception(
          "AppConfig has not been initialized. Call AppConfig.init() first.");
    }
    return _instance!;
  }
}
