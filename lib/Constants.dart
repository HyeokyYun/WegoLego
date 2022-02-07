enum Environment { LOCAL, PROD }

class Constants {
  static Map<String, dynamic>? _config;

  static void setEnvironment(Environment env) {
    switch (env) {
      case Environment.LOCAL:
        _config = _Config.localConstants;
        break;
      case Environment.PROD:
        _config = _Config.prodConstants;
        break;
    }
  }

  static get API {
    return _config![_Config.API];
  }
}

class _Config {
  static const API = "API";

  static Map<String, dynamic> localConstants = {
    API: "http://localhost:5001/wegolego/asia-east1/api/",
  };

  static Map<String, dynamic> prodConstants = {
    API: "https://asia-east1-wegolego.cloudfunctions.net/api/",
  };
}
