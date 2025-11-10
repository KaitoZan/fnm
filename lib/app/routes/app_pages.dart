import 'package:food_near_me_app/app/bindings/aboutapp_binding.dart';
import 'package:food_near_me_app/app/bindings/contact_us_binding.dart';
import 'package:food_near_me_app/app/bindings/edit_profile_binding.dart';
import 'package:food_near_me_app/app/bindings/favourite_binding.dart';
import 'package:food_near_me_app/app/bindings/forgot_password_binding.dart';
import 'package:food_near_me_app/app/bindings/home_binding.dart';
import 'package:food_near_me_app/app/bindings/my_profile_binding.dart';
import 'package:food_near_me_app/app/bindings/my_shop_binding.dart';
import 'package:food_near_me_app/app/bindings/navbar_binding.dart';
import 'package:food_near_me_app/app/bindings/otp_binding.dart';
import 'package:food_near_me_app/app/bindings/privacypolicy_binding.dart';
import 'package:food_near_me_app/app/bindings/register_binding.dart';
import 'package:food_near_me_app/app/bindings/reset_password_binding.dart';
import 'package:food_near_me_app/app/bindings/setting_binding.dart';
import 'package:food_near_me_app/app/bindings/splash_binding.dart';
import 'package:food_near_me_app/app/bindings/terms_conditions_binding.dart';
import 'package:food_near_me_app/app/ui/pages/aboutapp_page/aboutapp_page.dart';
import 'package:food_near_me_app/app/ui/pages/contact_us_page/contact_us_page.dart';
import 'package:food_near_me_app/app/ui/pages/edit_profile_page/edit_profile_page.dart';
import 'package:food_near_me_app/app/ui/pages/edit_restaurant_detail_page/edit_restaurant_detail_page.dart';
import 'package:food_near_me_app/app/ui/pages/favourite_page/favourite_page.dart';
import 'package:food_near_me_app/app/ui/pages/forgot_password_page/forgot_password_page.dart';
import 'package:food_near_me_app/app/ui/pages/home_page/home_page.dart';
import 'package:food_near_me_app/app/ui/pages/my_profile_page/my_profile_page.dart';
import 'package:food_near_me_app/app/ui/pages/my_shop_page/my_shop_page.dart';
import 'package:food_near_me_app/app/ui/pages/navbar_page/navbar_page.dart';
import 'package:food_near_me_app/app/ui/pages/otp_page/otp_page.dart';
import 'package:food_near_me_app/app/ui/pages/privacypolicy_page/privacypolicy_page.dart';
import 'package:food_near_me_app/app/ui/pages/register_page/register_page.dart';
import 'package:food_near_me_app/app/ui/pages/reset_password_page/reset_password_page.dart';
import 'package:food_near_me_app/app/ui/pages/restaurant_detail_page/restaurant_detail_page.dart';

import 'package:food_near_me_app/app/ui/pages/setting_page/setting_page.dart';
import 'package:food_near_me_app/app/ui/pages/splash_page/splash_page.dart';
import 'package:food_near_me_app/app/ui/pages/terms_conditions_page/terms_conditions_page.dart';
import 'package:get/get.dart';

// --- แก้ไข imports ---
import '../bindings/add_restaurant_binding.dart';
import '../bindings/edit_restaurant_detail_binding.dart'; // ใช้ Binding ที่ถูกต้อง
import '../bindings/login_binding.dart';
import '../bindings/restaurant_detail_binding.dart'; // ใช้ Binding ที่ถูกต้อง
import '../bindings/resubmit_request_binding.dart';
import '../bindings/unknown_route_binding.dart';

import '../ui/pages/add_restaurant_page/add_restaurant_page.dart';
import '../ui/pages/login_page/login_page.dart';

import '../ui/pages/resubmit_request_page/resubmit_request_page.dart';
import '../ui/pages/unknown_route_page/unknown_route_page.dart';
import 'app_routes.dart';

const _defaultTransition = Transition.native;

class AppPages {
  static final unknownRoutePage = GetPage(
    name: AppRoutes.UNKNOWN,
    page: () => UnknownRoutePage(),
    binding: UnknownRouteBinding(),
    transition: _defaultTransition,
  );

  static final List<GetPage> pages = [
    unknownRoutePage,

    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginPage(),
      binding: LoginBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.ABOUTAPP,
      page: () => AboutAppPage(),
      binding: AboutappBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.CONTACTUS,
      page: () => ContactUsPage(),
      binding: ContactUsBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.EDITPROFILE,
      page: () => EditProfilePage(),
      binding: EditProfileBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.FAVOURITE,
      page: () => FavouritePage(),
      binding: FavouriteBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.FORGOTPASSWORD,
      page: () => ForgotPasswordPage(),
      binding: ForgotPasswordBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.HOME, // *** ควรเปลี่ยนเป็น AppRoutes.HOME ***
      page: () => HomePage(),
      binding: HomeBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.MYPROFILE,
      page: () => MyProfilePage(),
      binding: MyProfileBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.MYSHOP,
      page: () => MyShopPage(),
      binding: MyShopBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.NAVBAR,
      page: () => NavbarPage(),
      binding: NavbarBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.OTP,
      page: () => OtpPage(),
      binding: OtpBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.PRIVACYPOLICY,
      page: () => PrivacypolicyPage(),
      binding: PrivacypolicyBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.REGISTER,
      page: () => RegisterPage(),
      binding: RegisterBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.RESETPASSWORD,
      page: () => ResetPasswordPage(),
      binding: ResetPasswordBinding(),
      transition: _defaultTransition,
    ),
    // --- แก้ไข GetPage สำหรับ RESTAURANTDETAIL ---
    GetPage(
      name:
          AppRoutes.RESTAURANTDETAIL +
          '/:restaurantId', // ใช้ parameter ใน route name
      page: () {
        final String restaurantId =
            Get.parameters['restaurantId'] ?? ''; // ดึง id จาก parameters
        return RestaurantDetailPage(
          restaurantId: restaurantId,
        ); // ส่ง id ไปยัง Page
      },
      binding: RestaurantDetailBinding(), // ใช้ Binding ที่ถูกต้อง
      transition: _defaultTransition,
    ),
    // --- แก้ไข GetPage สำหรับ EDITRESTAURANTDETAIL ---
    GetPage(
      name:
          AppRoutes.EDITRESTAURANTDETAIL +
          '/:restaurantId', // ใช้ parameter ใน route name
      page: () {
        final String restaurantId =
            Get.parameters['restaurantId'] ?? ''; // ดึง id จาก parameters
        return EditRestaurantDetailsPage(
          restaurantId: restaurantId,
        ); // ส่ง id ไปยัง Page
      },
      binding: EditRestaurantDetailBinding(), // ใช้ Binding ที่ถูกต้อง
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.ADDRESTAURANT,
      page: () => AddRestaurantPage(),
      binding: AddRestaurantBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.SETTING,
      page: () => SettingPage(),
      binding: SettingBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => SplashPage(),
      binding: SplashBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.TERMSCONDITIONS,
      page: () => TermsConditionsPage(),
      binding: TermsConditionsBinding(),
      transition: _defaultTransition,
    ),
    // --- เพิ่ม GetPage สำหรับ RESUBMITREQUEST ---
    GetPage(
      name: AppRoutes.RESUBMITREQUEST + '/:requestEditId', // ใช้ parameter
      page: () {
        final String requestEditId = Get.parameters['requestEditId'] ?? '';
        return ResubmitRequestPage(
          requestEditId: requestEditId,
        ); // ส่ง id ไปยัง Page
      },
      binding: ResubmitRequestBinding(), // ใช้ Binding ใหม่
      transition: _defaultTransition,
    ),
  ];
}
