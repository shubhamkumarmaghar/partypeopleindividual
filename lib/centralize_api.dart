class API {
  static const String baseUrl = 'http://app.partypeople.in/v1';

  static const String login = '$baseUrl/account/login';

  static const String otp = '$baseUrl/account/otp_verify';

  static const String updateType = '$baseUrl/account/update_user_type';

  static const String individualProfileCreation =
      '$baseUrl/party/create_individual_organization';

  static const String individualProfileUpdate =
      '$baseUrl/party/update_individual_organization';

  static const String individualProfileData =
      '$baseUrl/party/organization_details';

  static const String individualCities =
      '$baseUrl/party/cities';
}
