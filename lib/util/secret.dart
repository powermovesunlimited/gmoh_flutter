class Secret {
  final String googleApiKey;
  Secret({this.googleApiKey = ""});
  factory Secret.fromJson(Map<String, dynamic> jsonMap) {
    return new Secret(googleApiKey: jsonMap["google_api_key"]);
  }
}