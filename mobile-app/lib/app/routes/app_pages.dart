import 'package:get/get.dart';

import '../modules/address/bindings/address_binding.dart';
import '../modules/address/views/address_form_view.dart';
import '../modules/address/views/address_search_view.dart';
import '../modules/address/views/address_view.dart';
import '../modules/address/views/select_delivery_address_view.dart';
import '../modules/auth/binding/auth_binding.dart';
import '../modules/auth/views/create_password_view.dart';
import '../modules/auth/views/forget_password_view.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/sign_in_option_view.dart';
import '../modules/auth/views/sign_up_view.dart';
import '../modules/bag/bindings/bag_binding.dart';
import '../modules/bag/views/bag_view.dart';
import '../modules/buying/bindings/buying_binding.dart';
import '../modules/buying/views/buying_view.dart';
import '../modules/categories/bindings/categories_binding.dart';
import '../modules/categories/views/categories_view.dart';
import '../modules/categories/views/category_products_view.dart';
import '../modules/categories/views/filter_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/bindings/support_chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/chat/views/support_chat_view.dart';
import '../modules/checkout/bindings/checkout_binding.dart';
import '../modules/checkout/views/checkout_view.dart';
import '../modules/checkout/views/order_confirmed_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/favorite/bindings/favorite_binding.dart';
import '../modules/favorite/views/favorite_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/make_an_offer/bindings/make_an_offer_binding.dart';
import '../modules/make_an_offer/views/make_an_offer_view.dart';
import '../modules/my_activity/bindings/my_activity_binding.dart';
import '../modules/my_activity/views/my_activity_view.dart';
import '../modules/news_area/bindings/news_area_binding.dart';
import '../modules/news_area/views/news_area_view.dart';
import '../modules/news_area/views/news_detail_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/order_details/bindings/order_details_binding.dart';
import '../modules/order_details/views/order_details_view.dart';
import '../modules/product_detail/bindings/product_detail_binding.dart';
import '../modules/product_detail/views/product_detail_view.dart';
import '../modules/profile/bindings/follow_binding.dart';
import '../modules/profile/bindings/help_center_binding.dart';
import '../modules/profile/bindings/language_currency_binding.dart';
import '../modules/profile/bindings/notification_settings_binding.dart';
// import '../modules/profile/bindings/payment_info_binding.dart';
// import '../modules/profile/bindings/paypal_binding.dart';
import '../modules/profile/bindings/personal_info_binding.dart';
// import '../modules/profile/bindings/privacy_binding.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/bindings/profile_settings_binding.dart';
// import '../modules/profile/views/edit_card_view.dart';
import '../modules/profile/views/follow_view.dart';
import '../modules/profile/views/help_center_screen.dart';
import '../modules/profile/views/language_currency_view.dart';
import '../modules/profile/views/notification_settings_view.dart';
// import '../modules/profile/views/payment_info_view.dart';
// import '../modules/profile/views/paypal_view.dart';
import '../modules/profile/views/personal_info_view.dart';
// import '../modules/profile/views/privacy_view.dart';
import '../modules/profile/views/profile_settings_view.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/search_view/bindings/search_view_binding.dart';
import '../modules/search_view/views/search_view.dart';
import '../modules/sell/bindings/add_item_binding.dart';
import '../modules/sell/bindings/sell_binding.dart';
import '../modules/sell/views/add_item_view.dart';
import '../modules/sell/views/add_photos_view.dart';
import '../modules/sell/views/description_view.dart';
import '../modules/sell/views/listing_an_item_view.dart';
import '../modules/sell/views/optional_details_view.dart';
import '../modules/sell/views/product_address_view.dart';
import '../modules/sell/views/product_details_view.dart';
import '../modules/sell/views/product_price_view.dart';
import '../modules/sell/views/review_and_submit_view.dart';
import '../modules/sell/views/select_brand_view.dart';
import '../modules/sell/views/organize_view.dart';
import '../modules/sell/views/product_variants_view.dart';
import '../modules/sell/views/sell_view.dart';
import '../modules/selling/bindings/selling_binding.dart';
import '../modules/selling/views/selling_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/bindings/walkthrough_binding.dart';
import '../modules/splash/views/splash_screen.dart';
import '../modules/splash/views/walkthrough_view.dart';
import '../modules/stats/bindings/achievement_history_binding.dart';
import '../modules/stats/bindings/impact_history_binding.dart';
import '../modules/stats/bindings/stats_binding.dart';
import '../modules/stats/bindings/token_history_binding.dart';
import '../modules/stats/views/achievement_history_view.dart';
import '../modules/stats/views/impact_history_view.dart';
import '../modules/stats/views/stats_view.dart';
import '../modules/stats/views/token_history_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();
  static const initialRoute = Routes.splash;
  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.walkthrough,
      page: () => const WalkthroughView(),
      binding: WalkthroughBinding(),
    ),
    GetPage(
      name: Routes.signInOption,
      page: () => const SignInOptionView(),
      binding: AuthBinding(),
    ),
    GetPage(name: Routes.walkthrough, page: () => const WalkthroughView()),
    GetPage(
      name: Routes.signUp,
      page: () => const SignUpView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.logIn,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.forgotPassword,
      page: () => const ForgetPasswordView(),
      binding: AuthBinding(),
    ),
    // GetPage(
    //   name: Routes.otpVerification,
    //   page: () => const OtpVerification(),
    //   binding: AuthBinding(),
    // ),
    GetPage(
      name: Routes.createPassword,
      page: () => const CreatePasswordView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.dashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.favorite,
      page: () => const FavoriteView(),
      binding: FavoriteBinding(),
    ),
    GetPage(
      name: Routes.stats,
      page: () => const StatsView(),
      binding: StatsBinding(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.sell,
      page: () => const SellView(),
      binding: SellBinding(),
    ),
    GetPage(
      name: Routes.searchView,
      page: () => const SearchView(),
      binding: SearchViewBinding(),
    ),
    GetPage(
      name: Routes.productDetail,
      page: () => const ProductDetailView(),
      binding: ProductDetailBinding(),
    ),
    GetPage(
      name: Routes.makeAnOffer,
      page: () => const MakeAnOfferView(),
      binding: MakeAnOfferBinding(),
    ),
    GetPage(
      name: Routes.newsArea,
      page: () => const NewsAreaView(),
      binding: NewsAreaBinding(),
    ),
    GetPage(
      name: Routes.newsDetail,
      page: () => const NewsDetailView(),
      binding: NewsAreaBinding(),
    ),
    GetPage(
      name: Routes.notification,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: Routes.chat,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: Routes.bag,
      page: () => const BagView(),
      binding: BagBinding(),
    ),
    GetPage(
      name: Routes.checkout,
      page: () => const CheckoutView(),
      binding: CheckoutBinding(),
    ),
    GetPage(
      name: Routes.orderConfirmed,
      page: () => const OrderConfirmedView(),
      binding: CheckoutBinding(),
    ),
    GetPage(
      name: Routes.address,
      page: () => const AddressView(),
      binding: AddressBinding(),
    ),
    GetPage(
      name: Routes.addressForm,
      page: () => const AddressFormView(),
      binding: AddressBinding(),
    ),
    // GetPage(
    //   name: Routes.addAddress,
    //   page: () => const AddAddressView(),
    //   binding: AddressBinding(),
    // ),
    GetPage(
      name: Routes.addressSearch,
      page: () => const AddressSearchView(),
      binding: AddressBinding(),
    ),
    GetPage(
      name: Routes.selectDeliveryAddress,
      page: () => const SelectDeliveryAddressView(),
      binding: AddressBinding(),
    ),
    GetPage(
      name: Routes.categories,
      page: () => const CategoriesView(),
      binding: CategoriesBinding(),
    ),
    GetPage(
      name: Routes.categoryProducts,
      page: () => const CategoryProductsView(),
      binding: CategoriesBinding(),
    ),
    GetPage(
      name: Routes.filter,
      page: () => const FilterView(),
      binding: CategoriesBinding(),
    ),
    GetPage(
      name: Routes.addItemBasicInfo,
      page: () => const AddItemView(),
      binding: AddItemBinding(),
    ),
    GetPage(
      name: Routes.selectBrand,
      page: () => const SelectBrandView(),
      binding: AddItemBinding(),
    ),
    GetPage(
      name: Routes.listingAnItem,
      page: () => const ListingAnItemView(),
      binding: AddItemBinding(),
    ),
    GetPage(
      name: Routes.productDetails,
      page: () => const ProductDetailsView(),
      binding: AddItemBinding(),
    ),
    GetPage(
      name: Routes.addPhotos,
      page: () => const AddPhotosView(),
      binding: AddItemBinding(),
    ),
    GetPage(
      name: Routes.description,
      page: () => const DescriptionView(),
      binding: AddItemBinding(),
    ),
    GetPage(
      name: Routes.productAddress,
      page: () => const ProductAddressView(),
      binding: AddItemBinding(),
    ),
    GetPage(
      name: Routes.productPrice,
      page: () => const ProductPriceView(),
      binding: AddItemBinding(),
    ),
    GetPage(
      name: Routes.addItemOptionalDetails,
      page: () => const OptionalDetailsView(),
      binding: AddItemBinding(),
    ),
    GetPage(
      name: Routes.reviewAndSubmit,
      page: () => const ReviewAndSubmitView(),
      binding: AddItemBinding(),
    ),
    GetPage(
      name: Routes.organize,
      page: () => const OrganizeView(),
      binding: AddItemBinding(),
    ),
    GetPage(
      name: Routes.productVariants,
      page: () => const ProductVariantsView(),
      binding: AddItemBinding(),
    ),
    GetPage(
      name: Routes.tokenHistory,
      page: () => const TokenHistoryView(),
      binding: TokenHistoryBinding(),
    ),
    GetPage(
      name: Routes.impactHistory,
      page: () => const ImpactHistoryView(),
      binding: ImpactHistoryBinding(),
    ),
    GetPage(
      name: Routes.achievementHistory,
      page: () => const AchievementHistoryView(),
      binding: AchievementHistoryBinding(),
    ),
    GetPage(
      name: Routes.supportChat,
      page: () => const SupportChatView(),
      binding: SupportChatBinding(),
    ),
    GetPage(
      name: Routes.profileSettings,
      page: () => const ProfileSettingsView(),
      binding: ProfileSettingsBinding(),
    ),
    GetPage(
      name: Routes.personalInfo,
      page: () => const PersonalInfoView(),
      binding: PersonalInfoBinding(),
    ),

    // GetPage(
    //   name: Routes.paymentInfo,
    //   page: () => const PaymentInfoView(),
    //   binding: PaymentInfoBinding(),
    // ),
    // GetPage(
    //   name: Routes.editCard,
    //   page: () => const EditCardView(),
    //   binding: PaymentInfoBinding(),
    // ),
    // GetPage(
    //   name: Routes.payPal,
    //   page: () => const PayPalView(),
    //   binding: PayPalBinding(),
    // ),
    GetPage(
      name: Routes.notificationSettings,
      page: () => const NotificationSettingsView(),
      binding: NotificationSettingsBinding(),
    ),
    GetPage(
      name: Routes.languageAndCurrency,
      page: () => const LanguageCurrencyView(),
      binding: LanguageCurrencyBinding(),
    ),

    // GetPage(
    //   name: Routes.privacy,
    //   page: () => const PrivacyView(),
    //   binding: PrivacyBinding(),
    // ),
    // GetPage(
    //   name: Routes.deleteAccount,
    //   page: () => const DeleteAccountView(),
    //   binding: DeleteAccountBinding(),
    // ),
    GetPage(
      name: Routes.followers,
      page: () => const FollowView(),
      binding: FollowBinding(),
    ),
    GetPage(
      name: Routes.following,
      page: () => const FollowView(),
      binding: FollowBinding(),
    ),
    GetPage(
      name: Routes.selling,
      page: () => const SellingView(),
      binding: SellingBinding(),
    ),
    GetPage(
      name: Routes.buying,
      page: () => const BuyingView(),
      binding: BuyingBinding(),
    ),
    GetPage(
      name: Routes.orderDetails,
      page: () => const OrderDetailsView(),
      binding: OrderDetailsBinding(),
    ),
    GetPage(
      name: Routes.myActivity,
      page: () => const MyActivityView(),
      binding: MyActivityBinding(),
    ),
    GetPage(
      name: Routes.helpCenter,
      page: () => const HelpCenterScreen(),
      binding: HelpCenterBinding(),
    ),
  ];
}
