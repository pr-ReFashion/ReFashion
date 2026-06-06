import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/modules/address/model/address_model.dart';
import 'package:refashion/app/modules/address/services/address_service.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/routes/app_pages.dart';
import 'package:refashion/app/modules/bag/controllers/bag_controller.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/modules/checkout/model/shipping_option_model.dart';
import 'package:refashion/app/modules/checkout/services/checkout_service.dart';
import 'package:refashion/app/utills/hive/hive_keys.dart';
import 'package:refashion/app/utills/hive/hive_utils.dart';
import 'package:refashion/app/modules/checkout/model/order_set_model.dart';
import 'package:refashion/app/services/cart_controller.dart' as cart_service;

class CheckoutController extends GetxController {
  final BagController bagController = Get.find<BagController>();
  final GlobalKey<FormState> paymentFormKey = GlobalKey<FormState>();

  final RxBool isShippingExpanded = false.obs;
  final RxBool isPaymentExpanded = false.obs;
  final RxBool isTermsAccepted = false.obs;
  final RxBool useWalletCredits = false.obs;

  final RxBool isLoadingAddresses = false.obs;
  final RxList<AddressModel> addresses = <AddressModel>[].obs;
  final Rxn<AddressModel> selectedAddress = Rxn<AddressModel>();

  // Shipping Options State
  final RxBool isLoadingShippingOptions = false.obs;
  final RxList<ShippingOption> shippingOptions = <ShippingOption>[].obs;
  final RxMap<String, ShippingOption> selectedOptionsPerSeller = <String, ShippingOption>{}.obs;
  final RxBool isDeliveryExpanded = false.obs;
  final RxBool isShippingApplying = false.obs;
  final RxBool isShippingApplied = false.obs;

  // Payment State
  final RxString selectedPaymentMethod = ''.obs;

  // Card Details Controllers
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cardHolderNameController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController promoCodeController = TextEditingController();

  final RxDouble discountAmount = 0.0.obs;
  final RxBool isPromoApplied = false.obs;
  final RxBool isPromoLoading = false.obs;
  final RxString appliedPromoCode = "".obs;
  final RxBool isPromoExpanded = false.obs;
  final RxBool isPlaceOrderLoading = false.obs;
  final Rxn<OrderSetModel> orderSetRes = Rxn<OrderSetModel>();

  String get checkoutButtonText => (isPaymentExpanded.value && selectedPaymentMethod.value.isNotEmpty) ? locale.value.pay : locale.value.placeOrder;

  /// Whether all checkout prerequisites are met.
  bool get isReadyToOrder => selectedAddress.value != null && isShippingApplied.value && selectedPaymentMethod.value.isNotEmpty && isTermsAccepted.value;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      orderSetRes.value = OrderSetModel.fromJson(Get.arguments);
    }
    fetchAddresses();
    fetchShippingOptions();
    _checkAndAutoApplyPromotions();
  }

  void togglePromo() {
    isPromoExpanded.toggle();
    if (isPromoExpanded.value) {
      isShippingExpanded.value = false;
      isPaymentExpanded.value = false;
      isDeliveryExpanded.value = false;
    }
  }

  void _checkAndAutoApplyPromotions() {
    final promotions = bagController.bagModel.value?.cart?.promotions;
    if (promotions != null && promotions.isNotEmpty) {
      final promotion = promotions.first;
      if (promotion.code != null) {
        isPromoApplied.value = true;
        appliedPromoCode.value = promotion.code!;
        promoCodeController.text = promotion.code!;
        discountAmount.value = bagController.discountTotalEuro;
        isPromoExpanded.value = true;
      }
    }
  }

  Future<void> fetchShippingOptions() async {
    final String? cartId = HiveUtils.get(HiveKeys.cartId);
    if (cartId == null || cartId.isEmpty) return;

    isLoadingShippingOptions.value = true;
    try {
      final options = await CheckoutService().fetchShippingOptions(cartId);
      shippingOptions.assignAll(options);

      // Initialize selected options from cart
      final cartShippingMethods = bagController.bagModel.value?.cart?.shippingMethods ?? [];
      selectedOptionsPerSeller.clear();
      for (var method in cartShippingMethods) {
        final optionId = method['shipping_option_id'];
        final option = shippingOptions.firstWhereOrNull((o) => o.id == optionId);
        if (option != null && option.sellerId != null) {
          selectedOptionsPerSeller[option.sellerId!] = option;
        }
      }
      isShippingApplied.value = selectedOptionsPerSeller.length == groupedShippingOptions.length && groupedShippingOptions.isNotEmpty;
    } catch (e) {
      debugPrint('Error fetching shipping options: $e');
    } finally {
      isLoadingShippingOptions.value = false;
    }
  }

  Future<void> fetchAddresses() async {
    isLoadingAddresses.value = true;
    try {
      final response = await AddressService().fetchAddresses();
      if (response != null && response['addresses'] != null) {
        final addressList = AddressListModel.fromJson(response);
        addresses.assignAll(addressList.addresses ?? []);

        // Auto-select address if the cart already has a shipping address set
        if (addresses.isNotEmpty && selectedAddress.value == null) {
          _autoSelectAddressFromCart();
        }
      }
    } catch (e) {
      debugPrint('Error fetching addresses in checkout: $e');
    } finally {
      isLoadingAddresses.value = false;
    }
  }

  /// Matches the cart's existing shipping_address to one of the user's
  /// addresses so that the previously selected address is shown on re-entry.
  void _autoSelectAddressFromCart() {
    final cartShippingAddress = bagController.bagModel.value?.cart?.shippingAddress;
    if (cartShippingAddress == null || cartShippingAddress is! Map) return;

    final cartAddr = cartShippingAddress as Map<String, dynamic>;
    final cartFirstName = (cartAddr['first_name'] ?? '').toString().trim().toLowerCase();
    final cartLastName = (cartAddr['last_name'] ?? '').toString().trim().toLowerCase();
    final cartPhone = (cartAddr['phone'] ?? '').toString().trim().toLowerCase();
    final cartAddress1 = (cartAddr['address_1'] ?? '').toString().trim().toLowerCase();

    // Skip if the cart has no meaningful address data
    if (cartFirstName.isEmpty && cartAddress1.isEmpty) return;

    for (var addr in addresses) {
      final matchesName = (addr.firstName ?? '').trim().toLowerCase() == cartFirstName && (addr.lastName ?? '').trim().toLowerCase() == cartLastName;
      final matchesPhone = (addr.phone ?? '').trim().toLowerCase() == cartPhone;
      final matchesAddress = (addr.address1 ?? '').trim().toLowerCase() == cartAddress1;

      if (matchesName && matchesPhone && matchesAddress) {
        selectedAddress.value = addr;
        break;
      }
    }
  }

  Future<void> updateCartShippingAddress(AddressModel address) async {
    final String? cartId = HiveUtils.get(HiveKeys.cartId);
    final String email = HiveUtils.get(HiveKeys.userEmail) ?? '';
    if (cartId == null || cartId.isEmpty) return;

    final Map<String, dynamic> body = {
      "email": email,
      "shipping_address": {
        "company": address.company ?? "",
        "first_name": address.firstName ?? "",
        "last_name": address.lastName ?? "",
        "address_1": address.address1 ?? "",
        "city": address.city ?? "",
        "province": address.province ?? "",
        "postal_code": address.postalCode ?? "",
        "country_code": address.countryCode ?? "",
        "phone": address.phone ?? "",
      },
      // "billing_address": {
      //   "company": address.company ?? "",
      //   "first_name": address.firstName ?? "",
      //   "last_name": address.lastName ?? "",
      //   "address_1": address.address1 ?? "",
      //   "city": address.city ?? "",
      //   "province": address.province ?? "",
      //   "postal_code": address.postalCode ?? "",
      //   "country_code": address.countryCode ?? "",
      //   "phone": address.phone ?? "",
      // },
    };

    try {
      await CheckoutService().updateCart(cartId, body);

      // Clear the current shipping selection when address changes
      selectedOptionsPerSeller.clear();
      isShippingApplied.value = false;

      // Re-fetch cart data so totals (including tax) reflect the new address
      await bagController.fetchCartData();

      // After updating address, shipping options might change
      await fetchShippingOptions();
    } catch (e) {
      debugPrint('Error updating shipping address: $e');
    }
  }

  @override
  void onClose() {
    cardNumberController.dispose();
    cardHolderNameController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    promoCodeController.dispose();
    super.onClose();
  }

  void toggleShipping() {
    isShippingExpanded.toggle();
    if (isShippingExpanded.value) {
      isPaymentExpanded.value = false;
      isDeliveryExpanded.value = false;
    }
  }

  void toggleDelivery() {
    isDeliveryExpanded.toggle();
    if (isDeliveryExpanded.value) {
      isShippingExpanded.value = false;
      isPaymentExpanded.value = false;
    }
  }

  void togglePayment() {
    isPaymentExpanded.toggle();
    if (isPaymentExpanded.value) {
      isShippingExpanded.value = false;
      isDeliveryExpanded.value = false;
    }
  }

  void selectShippingOption(ShippingOption option) {
    if (option.sellerId == null || option.id == null) return;
    if (selectedOptionsPerSeller[option.sellerId]?.id == option.id) return;

    selectedOptionsPerSeller[option.sellerId!] = option;
    isShippingApplied.value = false;
  }

  Future<void> applyGroupedShippingOptions() async {
    final String? cartId = HiveUtils.get(HiveKeys.cartId);
    if (cartId == null || cartId.isEmpty) return;

    if (selectedOptionsPerSeller.length < groupedShippingOptions.length) {
      toast(locale.value.selectShippingOptionForAllSellers);
      return;
    }

    try {
      isShippingApplying.value = true;
      // We call addShippingMethod for each selected option
      for (var option in selectedOptionsPerSeller.values) {
        if (option.id != null) {
          await CheckoutService().addShippingMethod(cartId, option.id!);
        }
      }

      await bagController.fetchCartData();
      isShippingApplied.value = true;
      toast(locale.value.shippingOptionsAppliedSuccessfully);
    } catch (e) {
      debugPrint('Error applying shipping options: $e');
      toast(locale.value.failedToApplyShippingOptions);
    } finally {
      isShippingApplying.value = false;
    }
  }

  Map<String, List<ShippingOption>> get groupedShippingOptions {
    final groups = <String, List<ShippingOption>>{};
    for (var option in shippingOptions) {
      final key = option.sellerId ?? "default";
      if (!groups.containsKey(key)) {
        groups[key] = [];
      }
      groups[key]!.add(option);
    }
    return groups;
  }

  void selectAddress(AddressModel address) {
    if (selectedAddress.value?.id == address.id) return;
    selectedAddress.value = address;
    updateCartShippingAddress(address);
  }

  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  String? validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return locale.value.errorFieldRequired;
    }
    if (value.replaceAll(' ', '').length < 16) {
      return locale.value.invalidCardNumber;
    }
    return null;
  }

  String? validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return locale.value.errorFieldRequired;
    }
    if (value.length < 5) {
      return locale.value.invalidExpiryDate;
    }
    // Basic date validation
    final parts = value.split('/');
    if (parts.length != 2) return locale.value.invalidExpiryDate;
    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);

    if (month == null || month < 1 || month > 12) {
      return locale.value.invalidExpiryDate;
    }
    if (year == null) return locale.value.invalidExpiryDate;

    // Check if card is expired
    final now = DateTime.now();
    final currentYear = now.year % 100; // Get last 2 digits
    final currentMonth = now.month;

    if (year < currentYear) {
      return locale.value.cardExpired;
    }
    if (year == currentYear && month < currentMonth) {
      return locale.value.cardExpired;
    }

    return null;
  }

  String? validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return locale.value.errorFieldRequired;
    }
    if (value.length < 3) {
      return locale.value.invalidCVV;
    }
    return null;
  }

  void onAddNewAddressTap() {
    Get.toNamed(Routes.address)?.then((_) => fetchAddresses());
  }

  void onEditAddressTap(AddressModel address) {
    Get.toNamed(Routes.addressForm, arguments: address)?.then((_) => fetchAddresses());
  }

  void onTermsChanged(bool? value) {
    isTermsAccepted.value = value ?? false;
  }

  void toggleWalletCredits(bool? value) {
    useWalletCredits.value = value ?? false;
  }

  Future<void> applyPromoCode() async {
    if (isPromoApplied.value) return;
    Get.focusScope?.unfocus();

    final String? cartId = HiveUtils.get(HiveKeys.cartId);
    if (cartId == null || cartId.isEmpty) return;

    final String promoCode = promoCodeController.text.trim();
    if (promoCode.isEmpty) {
      toast(locale.value.enterPromotionCode);
      return;
    }

    try {
      isPromoLoading.value = true;
      final response = await CheckoutService().applyPromotionCode(cartId, promoCode);

      if (response != null && response['cart'] != null && response['cart']['promotions'] != null && (response['cart']['promotions'] as List).isNotEmpty) {
        final promotion = (response['cart']['promotions'] as List).first;
        final applicationMethod = promotion['application_method'];
        final String type = applicationMethod['type'] ?? '';
        // final double value = (applicationMethod['value'] ?? 0).toDouble();

        if (type == 'fixed' || type == 'percentage') {
          isPromoApplied.value = true;
          appliedPromoCode.value = promoCode;

          // Re-fetch cart data to ensure all totals (discount, tax, etc.) are synced
          await bagController.fetchCartData();

          // Update local discount amount from the refreshed bag model
          discountAmount.value = bagController.discountTotalEuro;

          toast(locale.value.promoCodeApplied);
        } else {
          isPromoApplied.value = false;
          discountAmount.value = 0.0;
          appliedPromoCode.value = "";
          toast(locale.value.invalidPromoCode);
        }
      } else {
        isPromoApplied.value = false;
        discountAmount.value = 0.0;
        appliedPromoCode.value = "";
        toast(locale.value.invalidPromoCode);
      }
    } catch (e) {
      debugPrint('Error applying promo code: $e');
      toast(e.toString());
    } finally {
      isPromoLoading.value = false;
    }
  }

  Future<void> removePromoCode() async {
    final String? cartId = HiveUtils.get(HiveKeys.cartId);
    if (cartId == null || cartId.isEmpty) return;

    if (appliedPromoCode.value.isEmpty) return;
    isPromoLoading.value = true;

    try {
      final response = await CheckoutService().removePromotionCode(cartId, appliedPromoCode.value);

      if (response != null && response['cart'] != null && (response['cart']['promotions'] as List).isEmpty) {
        // Re-fetch cart data to ensure all totals are synced after removal
        await bagController.fetchCartData();

        isPromoApplied.value = false;
        discountAmount.value = 0.0;
        appliedPromoCode.value = "";
        promoCodeController.clear();
        toast("Promotion code removed successfully");
      }
    } catch (e) {
      debugPrint('Error removing promo code: $e');
      toast(e.toString());
    } finally {
      isPromoLoading.value = false;
    }
  }

  Future<void> onPlaceOrder() async {
    if (selectedAddress.value == null) {
      toast(locale.value.addAShippingAddress);
      isShippingExpanded.value = true;
      return;
    }

    if (!isShippingApplied.value) {
      toast(locale.value.selectADeliveryOptionText);
      isDeliveryExpanded.value = true;
      return;
    }

    if (selectedPaymentMethod.value.isEmpty) {
      toast(locale.value.addAPaymentMethod);
      isPaymentExpanded.value = true;
      return;
    }

    if (!isTermsAccepted.value) return;

    if (selectedPaymentMethod.value == locale.value.creditDebitCard) {
      if (!(paymentFormKey.currentState?.validate() ?? false)) {
        isPaymentExpanded.value = true;
        isShippingExpanded.value = false;
        return;
      }
    }

    // Start Place Order Process
    final String? cartId = HiveUtils.get(HiveKeys.cartId);
    if (cartId == null || cartId.isEmpty) {
      toast(locale.value.errorUnknown);
      return;
    }

    try {
      isPlaceOrderLoading.value = true;

      // 1. Create Payment Collection
      final collectionRes = await CheckoutService().createPaymentCollection(cartId);
      final paymentCollectionId = collectionRes?['payment_collection']?['id'];

      if (collectionRes != null && paymentCollectionId != null) {
        // 2. Create Payment Session
        final sessionRes = await CheckoutService().createPaymentSession(paymentCollectionId);

        if (sessionRes != null) {
          // 3. Complete Cart
          final completeRes = await CheckoutService().completeCart(cartId);

          if (completeRes != null) {
            // Success
            await HiveUtils.remove(HiveKeys.cartId);
            cart_service.CartController.to.clearCartCount();
            Get.offAllNamed(Routes.orderConfirmed, arguments: completeRes);
            // Optionally clear cart data
            bagController.cartItems.clear();
            bagController.fetchCartData();
          } else {
            toast(locale.value.errorUnknown);
          }
        } else {
          toast(locale.value.errorUnknown);
        }
      } else {
        toast(locale.value.errorUnknown);
      }
    } catch (e) {
      debugPrint('Error placing order: $e');
      toast(e.toString());
    } finally {
      isPlaceOrderLoading.value = false;
    }
  }

  void onContinueShoppingTap() {
    Get.offAllNamed(Routes.dashboard);
  }

  void onTrackOrderTap() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: ColorHelper.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(8.r), topRight: Radius.circular(8.r)),
        ),
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 8.w, 30.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  locale.value.track,
                  style: TextStyleHelper.urMedium500().copyWith(fontSize: 20.sp, color: ColorHelper.headingColor),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints(),
                  icon: Icon(Icons.close, color: ColorHelper.iconColor, size: 22.sp),
                ),
              ],
            ),
            const Divider(color: ColorHelper.borderColor, height: 1).paddingOnly(right: 8.w),
            SizedBox(height: 8.h),
            Text(
              locale.value.status,
              style: TextStyleHelper.urMedium500().copyWith(fontSize: 16.sp, color: ColorHelper.headingColor),
            ),
            SizedBox(height: 12.h),
            _buildTrackItem(title: locale.value.arriving, subtitle: 'by 11 Dec - 13 Dec', isCompleted: false, isFirst: true),
            _buildTrackItem(title: locale.value.shipped, subtitle: 'by Thu - 9 Dec', isCompleted: false),
            _buildTrackItem(title: locale.value.orderPlaced, subtitle: 'on Fri, 5 Dec', isCompleted: true, isLast: true),
            SizedBox(height: 12.h),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildTrackItem({required String title, required String subtitle, required bool isCompleted, bool isFirst = false, bool isLast = false}) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 28.w,
                height: 28.h,
                decoration: BoxDecoration(color: isCompleted ? ColorHelper.primary : ColorHelper.subHeadingColor.withValues(alpha: 0.2), shape: BoxShape.circle),
                child: Center(
                  child: Icon(Icons.check, color: ColorHelper.white, size: 16.sp),
                ),
              ),
              if (!isLast) Expanded(child: Container(width: 1, color: isCompleted ? ColorHelper.primary : ColorHelper.subHeadingColor.withValues(alpha: 0.2))),
            ],
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: title,
                        style: TextStyleHelper.urBold700().copyWith(fontSize: 16.sp, color: isCompleted ? ColorHelper.primary : ColorHelper.headingColor),
                      ),
                      WidgetSpan(child: SizedBox(width: 8.w)),
                      TextSpan(
                        text: subtitle,
                        style: TextStyleHelper.urMedium500().copyWith(fontSize: 16.sp, color: ColorHelper.subHeadingColor),
                      ),
                    ],
                  ),
                ),
                if (!isLast) SizedBox(height: 48.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onOrderConfirmedCloseTap() {
    Get.offAllNamed(Routes.dashboard);
  }
}
