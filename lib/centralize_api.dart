class API {

  static const String productionUrlString = 'https://app.partypeople.in/v1';

  static const String developmentUrl = 'https://65.2.59.129/app/v1';

  static const String baseUrl = productionUrlString;

  static const String login = '$baseUrl/account/login';

  static const String otp = '$baseUrl/account/otp_verify';

  static const String updateType = '$baseUrl/account/update_user_type';

  static const String deleteMyAccount = '$baseUrl/account/delete_my_account';

  static const String individualProfileCreation =
      '$baseUrl/party/create_individual_organization';

  static const String organizationInfo = '$baseUrl/party/organization_info';

  static const String individualProfileUpdate =
      '$baseUrl/party/update_individual_organization';

  static const String individualProfileData = '$baseUrl/party/organization_details';

  static const String getIndividualViewList = '$baseUrl/account/get_individual_view_list';

  static const String getUserSearch = '$baseUrl/home/users_search';

  static const String individualOrganizationAmenities = '$baseUrl/party/individual_organization_amenities';

  static const String partyAmenities = '$baseUrl/party/party_amenities';

  static const String individualCities = '$baseUrl/party/cities';

  static const String getAllIndividualParty = '$baseUrl/party/get_all_individual_party';

  static const String onlineStatus = '$baseUrl/account/update_online_time_expiry';

  static const String individualPeoplesNearby = '$baseUrl/home/near_by_users';

  static const String ongoingParty = '$baseUrl/party/party_ongoing';

  static const String partyLike = '$baseUrl/party/party_like';

  static const String partyView = '$baseUrl/party/party_view';

  static const String addToWishList = '$baseUrl/party/add_to_wish_list_party';

  static const String getWishListParty = '$baseUrl/party/get_wish_list_party';

  static const String deleteWishListParty = '$baseUrl/party/delete_to_wish_list_party';

  static const String getIndividualProfileView = '$baseUrl/account/get_individual_profile_view';

  static const String userLike = '$baseUrl/account/individual_user_like';

  static const String updateActiveCity = '$baseUrl/account/update_city';

  static const String blockUnblockApi = '$baseUrl/account/individual_user_block';

  static const String getBlockList = '$baseUrl/account/get_individual_block_list';

  static const String getChatUserList = '$baseUrl/chat/get_chat_user_list_data';

  static const String getSingleChatUser = '$baseUrl/account/get_single_user';

  static const String addChatUser = '$baseUrl/chat/add_chat';

  static const String updateChatMsg = '$baseUrl/chat/update_chat_message';

  static const String deleteChatPeopleApi = '$baseUrl/chat/delete_chat';

  static const String getSubscriptionPlan = '$baseUrl/subscription/subscription_plan';

  static const String getTransactionHistory = '$baseUrl/Subscription/transaction_history';

  static const String userSubscriptionPurchase = '$baseUrl/subscription/user_subscriptions_purchase';

  static const String updateSubscriptionStatus = '$baseUrl/subscription/user_subscription_plan_status_update';

  static const String getAllNotification = '$baseUrl/notification/get_all_notification';

  static const String updateNotificationStatus = '$baseUrl/account/update_notification_status';

  static const String singleNotificationReadStatus = '$baseUrl/notification/single_notification_read_status_update';

  static const String updateOnlineStatus = '$baseUrl/account/update_online_status';

  static const String updatePrivacyOnlineStatus = '$baseUrl/account/update_privacy_online_status';

  static const String getVisitorList = '$baseUrl/account/get_individual_visitor_list';

  static const String getViewList = '$baseUrl/account/get_individual_view_list';

  static const String getLikeList = '$baseUrl/account/get_individual_like_list';

  static const String addImage = '$baseUrl/party/add_image';















}
