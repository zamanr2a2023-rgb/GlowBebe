import 'package:flutter/material.dart';
import 'package:glowbebe/features/auth/view/forgot_password_screen.dart';
import 'package:glowbebe/features/auth/view/login_screen.dart';
import 'package:glowbebe/features/auth/view/otp_screen.dart';
import 'package:glowbebe/features/auth/view/register_screen.dart';
import 'package:glowbebe/features/community/view/community_home_screen.dart';
import 'package:glowbebe/features/community/view/community_profile_screen.dart';
import 'package:glowbebe/features/community/view/create_post_screen.dart';
import 'package:glowbebe/features/community/view/post_detail_screen.dart';
import 'package:glowbebe/features/consult/view/consult_chat_screen.dart';
import 'package:glowbebe/features/consult/view/consult_concerns_screen.dart';
import 'package:glowbebe/features/consult/view/consult_history_screen.dart';
import 'package:glowbebe/features/consult/view/consult_start_screen.dart';
import 'package:glowbebe/features/consult/view/consult_summary_screen.dart';
import 'package:glowbebe/features/home/view/home_screen.dart';
import 'package:glowbebe/features/notifications/view/notifications_screen.dart';
import 'package:glowbebe/features/onboarding/view/onboarding_screen.dart';
import 'package:glowbebe/features/onboarding/view/permissions_screen.dart';
import 'package:glowbebe/features/profile/view/edit_profile_screen.dart';
import 'package:glowbebe/features/profile/view/membership_screen.dart';
import 'package:glowbebe/features/profile/view/profile_screen.dart';
import 'package:glowbebe/features/routine/view/routine_active_step_screen.dart';
import 'package:glowbebe/features/routine/view/routine_complete_screen.dart';
import 'package:glowbebe/features/routine/view/routine_overview_screen.dart';
import 'package:glowbebe/features/routine/view/routine_steps_screen.dart';
import 'package:glowbebe/features/routine/view/todays_routine_screen.dart';
import 'package:glowbebe/features/settings/view/settings_screen.dart';
import 'package:glowbebe/features/shell/main_shell.dart';
import 'package:glowbebe/features/shop/view/barcode_scanner_screen.dart';
import 'package:glowbebe/features/shop/view/cart_screen.dart';
import 'package:glowbebe/features/shop/view/checkout_screen.dart';
import 'package:glowbebe/features/shop/view/glow_analysis_screen.dart';
import 'package:glowbebe/features/shop/view/order_history_screen.dart';
import 'package:glowbebe/features/shop/view/order_status_screen.dart';
import 'package:glowbebe/features/shop/view/product_detail_screen.dart';
import 'package:glowbebe/features/shop/view/product_list_screen.dart';
import 'package:glowbebe/features/shop/view/recommendations_screen.dart';
import 'package:glowbebe/features/shop/view/shop_home_screen.dart';
import 'package:glowbebe/features/skin/view/beauty_forecast_screen.dart';
import 'package:glowbebe/features/skin/view/scan/skin_regimen_screen.dart';
import 'package:glowbebe/features/skin/view/scan/skin_scan_analyzing_screen.dart';
import 'package:glowbebe/features/skin/view/scan/skin_scan_camera_screen.dart';
import 'package:glowbebe/features/skin/view/scan/skin_scan_confirm_screen.dart';
import 'package:glowbebe/features/skin/view/scan/skin_scan_intro_screen.dart';
import 'package:glowbebe/features/skin/view/scan/skin_scan_prepare_screen.dart';
import 'package:glowbebe/features/skin/view/scan/skin_scan_results_screen.dart';
import 'package:glowbebe/features/skin/view/skin_evolution_screen.dart';
import 'package:glowbebe/features/skin/view/skin_health_screen.dart';
import 'package:glowbebe/features/skin/view/skin_questionnaire_screen.dart';
import 'package:glowbebe/features/splash/view/splash_screen.dart';
import 'package:glowbebe/features/try_on/view/analysis_results_screen.dart';
import 'package:glowbebe/features/try_on/view/camera_mirror_screen.dart';
import 'package:glowbebe/features/try_on/view/capture_comparison_screen.dart';
import 'package:glowbebe/features/try_on/view/color_shade_match_screen.dart';
import 'package:glowbebe/features/try_on/view/customize_look_screen.dart';
import 'package:glowbebe/features/try_on/view/makeup_hub_screen.dart';
import 'package:glowbebe/features/try_on/view/placement_advice_screen.dart';
import 'package:glowbebe/features/try_on/view/realtime_tryon_screen.dart';
import 'package:glowbebe/features/try_on/view/shade_matched_shop_screen.dart';
import 'package:glowbebe/routes/route_names.dart';

class AppRoutes {
  AppRoutes._();

  static const String login = RouteNames.login;
  static const String makeupHub = RouteNames.makeupHub;

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RouteNames.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case RouteNames.permissions:
        return MaterialPageRoute(builder: (_) => const PermissionsScreen());
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case RouteNames.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case RouteNames.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case RouteNames.otp:
        return MaterialPageRoute(builder: (_) => const OtpScreen());
      case RouteNames.mainShell:
        final index = settings.arguments is int ? settings.arguments as int : 0;
        return MaterialPageRoute(
          builder: (_) => MainShell(initialIndex: index),
        );
      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case RouteNames.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case RouteNames.editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case RouteNames.membership:
        return MaterialPageRoute(builder: (_) => const MembershipScreen());
      case RouteNames.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      // Skin
      case RouteNames.skinHealth:
        return MaterialPageRoute(builder: (_) => const SkinHealthScreen());
      case RouteNames.skinEvolution:
        return MaterialPageRoute(builder: (_) => const SkinEvolutionScreen());
      case RouteNames.beautyForecast:
        return MaterialPageRoute(builder: (_) => const BeautyForecastScreen());
      case RouteNames.skinQuestionnaire:
        final args = settings.arguments;
        final fromRegister =
            args is Map && args['fromRegister'] == true;
        return MaterialPageRoute(
          builder: (_) => SkinQuestionnaireScreen(
            fromRegister: fromRegister,
          ),
        );
      case RouteNames.skinScanIntro:
        return MaterialPageRoute(builder: (_) => const SkinScanIntroScreen());
      case RouteNames.skinScanPrepare:
        return MaterialPageRoute(builder: (_) => const SkinScanPrepareScreen());
      case RouteNames.skinScanCamera:
        return MaterialPageRoute(builder: (_) => const SkinScanCameraScreen());
      case RouteNames.skinScanConfirm:
        return MaterialPageRoute(builder: (_) => const SkinScanConfirmScreen());
      case RouteNames.skinScanAnalyzing:
        return MaterialPageRoute(
          builder: (_) => const SkinScanAnalyzingScreen(),
        );
      case RouteNames.skinScanResults:
        return MaterialPageRoute(builder: (_) => const SkinScanResultsScreen());
      case RouteNames.skinRegimen:
        return MaterialPageRoute(builder: (_) => const SkinRegimenScreen());

      // Routine
      case RouteNames.todaysRoutine:
        return MaterialPageRoute(builder: (_) => const TodaysRoutineScreen());
      case RouteNames.routineOverview:
        return MaterialPageRoute(builder: (_) => const RoutineOverviewScreen());
      case RouteNames.routineSteps:
        return MaterialPageRoute(builder: (_) => const RoutineStepsScreen());
      case RouteNames.routineActiveStep:
        return MaterialPageRoute(
          builder: (_) => const RoutineActiveStepScreen(),
          settings: settings,
        );
      case RouteNames.routineComplete:
        return MaterialPageRoute(builder: (_) => const RoutineCompleteScreen());

      // Notifications & consult
      case RouteNames.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case RouteNames.consultStart:
        return MaterialPageRoute(builder: (_) => const ConsultStartScreen());
      case RouteNames.consultConcerns:
        return MaterialPageRoute(builder: (_) => const ConsultConcernsScreen());
      case RouteNames.consultChat:
        return MaterialPageRoute(builder: (_) => const ConsultChatScreen());
      case RouteNames.consultSummary:
        return MaterialPageRoute(builder: (_) => const ConsultSummaryScreen());
      case RouteNames.consultHistory:
        return MaterialPageRoute(builder: (_) => const ConsultHistoryScreen());

      // Shop
      case RouteNames.shopHome:
        return MaterialPageRoute(builder: (_) => const ShopHomeScreen());
      case RouteNames.productList:
        return MaterialPageRoute(builder: (_) => const ProductListScreen());
      case RouteNames.productDetail:
        return MaterialPageRoute(builder: (_) => const ProductDetailScreen());
      case RouteNames.cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());
      case RouteNames.checkout:
        return MaterialPageRoute(builder: (_) => const CheckoutScreen());
      case RouteNames.orderHistory:
        return MaterialPageRoute(builder: (_) => const OrderHistoryScreen());
      case RouteNames.orderStatus:
        return MaterialPageRoute(builder: (_) => const OrderStatusScreen());
      case RouteNames.barcodeScanner:
        return MaterialPageRoute(builder: (_) => const BarcodeScannerScreen());
      case RouteNames.glowAnalysis:
        return MaterialPageRoute(builder: (_) => const GlowAnalysisScreen());
      case RouteNames.recommendations:
        return MaterialPageRoute(builder: (_) => const RecommendationsScreen());

      // Community
      case RouteNames.communityHome:
        return MaterialPageRoute(builder: (_) => const CommunityHomeScreen());
      case RouteNames.postDetail:
        return MaterialPageRoute(builder: (_) => const PostDetailScreen());
      case RouteNames.createPost:
        return MaterialPageRoute(builder: (_) => const CreatePostScreen());
      case RouteNames.communityProfile:
        return MaterialPageRoute(
          builder: (_) => const CommunityProfileScreen(),
        );

      // Try-on flow
      case RouteNames.makeupHub:
        return MaterialPageRoute(builder: (_) => const MakeupHubScreen());
      case RouteNames.cameraMirror:
        return MaterialPageRoute(builder: (_) => const CameraMirrorScreen());
      case RouteNames.realtimeTryOn:
        return MaterialPageRoute(
          builder: (_) {
            final args = settings.arguments as Map<String, dynamic>?;
            return RealtimeTryOnScreen(
              imagePath: args?['imagePath'] as String?,
              mirror: args?['mirror'] as bool? ?? false,
            );
          },
        );
      case RouteNames.customizeLook:
        return MaterialPageRoute(
          builder: (_) {
            final args = settings.arguments as Map<String, dynamic>?;
            return CustomizeLookScreen(
              imagePath: args?['imagePath'] as String?,
              mirror: args?['mirror'] as bool? ?? false,
            );
          },
        );
      case RouteNames.captureComparison:
        return MaterialPageRoute(
          builder: (_) {
            final args = settings.arguments as Map<String, dynamic>?;
            return CaptureComparisonScreen(
              imagePath: args?['imagePath'] as String?,
              beforePath: args?['beforePath'] as String?,
              afterPath: args?['afterPath'] as String?,
              mirror: args?['mirror'] as bool? ?? false,
            );
          },
        );
      case RouteNames.colorShadeMatch:
        return MaterialPageRoute(builder: (_) => const ColorShadeMatchScreen());
      case RouteNames.shadeMatchedShop:
        return MaterialPageRoute(
          builder: (_) => const ShadeMatchedShopScreen(),
        );
      case RouteNames.placementAdvice:
        return MaterialPageRoute(builder: (_) => const PlacementAdviceScreen());
      case RouteNames.analysisResults:
        return MaterialPageRoute(builder: (_) => const AnalysisResultsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}
