class AppUrls {
  static String baseUrl = "https://api.scan2home.co.uk/api/v1";
  static String imageUrl = "https://api.scan2home.co.uk";
  //authetication
  static String login = "/user/auth/login/";
  static String loginAgent = "/agent/auth/login/";
  static String signUp = "/user/auth/register/";
  static String signUpAgent = "/agent/auth/register/";
  static String authDetails = "/auth/users/me/";

  static String forgotPasswordAgent = "/agent/auth/forgot-password/";
  static String forgotPassword = '/user/auth/forgot-password/';

  static String verfiyOtpAgent = "/agent/auth/verify-otp/";
  static String verfiyOtpUser = "/user/auth/verify-otp/";

  static String resetPasswordAgent = "/agent/auth/reset-password/";
  static String resetPassword = "/user/auth/reset-password/";

  static String createPassword = "/user/auth/reset-password/";
  static String createPaswordAgent = "/agent/auth/reset-password/";

  //profile section
  static String profile = "/user/auth/profile/";
  static String profileAgent = "/agent/auth/profile/";

  static String editProfile = "/user/auth/profile/";
  static String editProfileAgents = "/agent/auth/profile/";

  static String chnagePassword = "/user/auth/change-password/";
  static String chnagePasswordAgent = "/user/auth/change-password/";

  //user or customer portion
  static String chatAi = "/user/chat/";
  static String getProperty = "/user/properties/";
  static String getPropertyType = "/admin/settings/property-types/";
  static String addPropertyFav = "/user/properties/";
  static String propertyDetails = "/user/properties/";
  static String getSimilerProperty = "/user/properties/";
  static String makeOffer = "/user/offers/";
  static String bookingMeeting = "/user/bookings/";
  static String giveRating = "/user/properties/agent/";
  static String searchFilter = "/user/properties/";
  static String favourite = "/user/properties/favourites/";


  //agent portion
  static String agentDashboard = "/agent/properties/dashboard/";
  static String getPropertyAgent = "/agent/properties/";
  static String agentProfile = "/agent/auth/profile/";
  static String updateAgentProfile = "/agent/auth/profile/";
  static String addProperty = "";
  static String getPropertyTypeAgent = "/user/properties/types/";
  static String agentPropertySearch = "/user/properties/";
  static String getOffer = "/agent/offers/";
  static String offerAccept = "/agent/offers/";
  static String markLead = "/agent/offers/";
  static String counterOffer = "/agent/offers/";
  static String getnotificaiton = "/agent/notifications/";

  static String markAsRead = "/agent/notifications/";

  static String getMyPropertyAgent = "/agent/properties/";

  static String createBoard = "/agent/boards/";

  static String assignBoard = "/agent/boards/";
}
