import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/modules/bag/controllers/bag_controller.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/utills/price_formatter.dart';
import 'package:refashion/app/modules/checkout/model/shipping_option_model.dart';
import 'package:refashion/app/widget/base_scaffold.dart';
import 'package:refashion/app/widget/custom_check_box.dart';
import 'package:refashion/app/constant/comman_text_field.dart';
import 'package:refashion/app/modules/checkout/controllers/checkout_controller.dart';
import 'package:refashion/app/modules/address/model/address_model.dart';
import 'package:refashion/app/modules/address/shimmer/address_shimmer.dart';
import 'package:refashion/app/modules/checkout/shimmer/delivery_shimmer.dart';
import 'package:refashion/app/widget/custom_dropdown.dart';
// import 'package:refashion/app/utills/card_details_formatter.dart';
// import 'package:refashion/app/widget/wallet_bg_box_paint.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CommonAppBar(title: locale.value.checkoutText),
      body: Column(
        children: [
          Expanded(
            child: AnimatedScrollView(
              children: [
                SizedBox(height: 16.h),
                _shippingSection().paddingSymmetric(horizontal: 16.w),
                SizedBox(height: 12.h),
                _deliverySection().paddingSymmetric(horizontal: 16.w),
                SizedBox(height: 12.h),
                _paymentSection().paddingSymmetric(horizontal: 16.w),
                SizedBox(height: 12.h),
                _promoCodeSection().paddingSymmetric(horizontal: 16.w),
                SizedBox(height: 20.h),
                _itemsSection(),
                SizedBox(height: 32.h),
              ],
            ),
          ),
          _bottomSection(),
        ],
      ),
    );
  }

  Widget _shippingSection() {
    return Obx(
      () => _expansionTile(
        title: locale.value.shippingText,
        subtitle: locale.value.addAShippingAddress,
        isExpanded: controller.isShippingExpanded.value,
        onTap: controller.toggleShipping,
        expandedChild: Column(
          children: [
            if (controller.isLoadingAddresses.value)
              const AddressShimmer()
            else if (controller.addresses.isEmpty)
              _emptyState(
                message: locale.value.yourAddressListIsEmpty,
                description: locale.value.yourAddressListIsEmptyDesc,
              )
            else
              ...controller.addresses.map((addr) => _addressItem(addr)),
            SizedBox(height: 12.h),
            InkWell(
              onTap: controller.onAddNewAddressTap,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  border: Border.all(color: ColorHelper.borderColor),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 20.sp, color: ColorHelper.primary),
                    SizedBox(width: 8.w),
                    Text(
                      locale.value.addNewAddress,
                      style: TextStyleHelper.urSemiBold600().copyWith(
                        fontSize: 14.sp,
                        color: ColorHelper.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        collapsedSummary: controller.selectedAddress.value != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        controller.selectedAddress.value!.name,
                        style: TextStyleHelper.urMedium500().copyWith(
                          fontSize: 16.sp,
                          color: ColorHelper.headingColor,
                        ),
                      ),
                      // SizedBox(width: 8.w),
                      // Container(
                      //   padding: EdgeInsets.symmetric(
                      //     horizontal: 8.w,
                      //     vertical: 4.h,
                      //   ),
                      //   decoration: BoxDecoration(
                      //     border: Border.all(color: ColorHelper.primary),
                      //     borderRadius: BorderRadius.circular(8.r),
                      //   ),
                      //   child: Text(
                      //     controller.selectedAddress.value!.tag,
                      //     style: TextStyleHelper.urMedium500().copyWith(
                      //       fontSize: 10.sp,
                      //       color: ColorHelper.primary,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    controller.selectedAddress.value!.address,
                    style: TextStyleHelper.dmRegular400().copyWith(
                      fontSize: 12.sp,
                      color: ColorHelper.subHeadingColor,
                    ),
                  ),
                ],
              )
            : null,
      ),
    );
  }

  Widget _deliverySection() {
    return Obx(() {
      final groupedOptions = controller.groupedShippingOptions;
      final selectedOptions = controller.selectedOptionsPerSeller;
      final hasSelection = selectedOptions.isNotEmpty;

      return _expansionTile(
        title: locale.value.deliveryOptionText,
        subtitle: hasSelection ? null : locale.value.selectADeliveryOptionText,
        isExpanded: controller.isDeliveryExpanded.value,
        onTap: controller.toggleDelivery,
        collapsedSummary: hasSelection
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: selectedOptions.values.map((option) {
                  final sellerName = option.sellerName ?? "Seller";
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: "$sellerName: ",
                            style: TextStyleHelper.urMedium500().copyWith(
                              fontSize: 14.sp,
                              color: ColorHelper.headingColor,
                              fontWeight: FontWeight.w600,
                            ),
                            children: [
                              TextSpan(
                                text: option.name,
                                style: TextStyleHelper.urMedium500().copyWith(
                                  fontSize: 14.sp,
                                  color: ColorHelper.subHeadingColor,
                                ),
                              ),
                            ],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        (option.amount ?? 0).toDouble().toPrice(),
                        style: TextStyleHelper.urMedium500().copyWith(
                          fontSize: 14.sp,
                          color: ColorHelper.headingColor,
                        ),
                      ),
                    ],
                  ).paddingOnly(bottom: 4.h);
                }).toList(),
              )
            : null,
        expandedChild: controller.isLoadingShippingOptions.value
            ? const DeliveryShimmer()
            : groupedOptions.isEmpty
            ? _emptyState(
                message: locale.value.noDeliveryOptionsAvailable,
                description: '',
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...groupedOptions.entries.map((entry) {
                    final sellerId = entry.key;
                    final options = entry.value;
                    final sellerName = options.first.sellerName ?? "Seller";
                    final selectedOption = selectedOptions[sellerId];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sellerName,
                          style: TextStyleHelper.urMedium500().copyWith(
                            fontSize: 14.sp,
                            color: ColorHelper.subHeadingColor,
                          ),
                        ).paddingOnly(bottom: 8.h),
                        CustomDropdown<ShippingOption>(
                          label: "",
                          hint: locale.value.chooseDeliveryOption,
                          value: selectedOption,
                          items: options.map((opt) {
                            final price = (opt.amount ?? 0)
                                .toDouble()
                                .toPrice();
                            return DropdownItem<ShippingOption>(
                              value: opt,
                              label: "${opt.name} - $price",
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              controller.selectShippingOption(val);
                            }
                          },
                        ),
                        SizedBox(height: 16.h),
                      ],
                    );
                  }),
                  SizedBox(height: 8.h),
                  CommonBtn(
                    text: controller.isShippingApplied.value
                        ? locale.value.shippingApplied
                        : locale.value.applyShippingOptions,
                    disabledColor: ColorHelper.lightGrey,
                    onTap: controller.applyGroupedShippingOptions,
                    isLoading: controller.isShippingApplying.value,
                    enabled:
                        selectedOptions.length == groupedOptions.length &&
                        !controller.isShippingApplied.value,
                    width: double.infinity,
                    color: controller.isShippingApplied.value
                        ? ColorHelper.subHeadingColor.withValues(alpha: 0.2)
                        : ColorHelper.primary,
                    textColor: controller.isShippingApplied.value
                        ? ColorHelper.subHeadingColor
                        : ColorHelper.white,
                  ),
                ],
              ),
      );
    });
  }

  // _deliveryItem is no longer used, removed.

  Widget _paymentSection() {
    return Obx(
      () => _expansionTile(
        title: locale.value.payment,
        subtitle: controller.selectedPaymentMethod.value.isNotEmpty
            ? null
            : locale.value.addAPaymentMethod,
        isExpanded: controller.isPaymentExpanded.value,
        onTap: controller.togglePayment,
        collapsedSummary: controller.selectedPaymentMethod.value.isNotEmpty
            ? Text(
                controller.selectedPaymentMethod.value,
                style: TextStyleHelper.urMedium500().copyWith(
                  fontSize: 16.sp,
                  color: ColorHelper.headingColor,
                ),
              )
            : null,
        expandedChild: Form(
          key: controller.paymentFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _paymentItem(
                locale.value.cashOnDelivery,
                isSelected:
                    controller.selectedPaymentMethod.value ==
                    locale.value.cashOnDelivery,
                onTap: () =>
                    controller.selectPaymentMethod(locale.value.cashOnDelivery),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: ColorHelper.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${locale.value.attentionText}:',
                      style: TextStyleHelper.urSemiBold600().copyWith(
                        fontSize: 12.sp,
                        color: ColorHelper.primary,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        locale.value.paymentAttentionText,
                        style: TextStyleHelper.dmRegular400().copyWith(
                          fontSize: 12.sp,
                          color: ColorHelper.subHeadingColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              /*_paymentItem(
                locale.value.creditDebitCard,
                isSelected:
                    controller.selectedPaymentMethod.value ==
                    locale.value.creditDebitCard,
                onTap: () => controller.selectPaymentMethod(
                  locale.value.creditDebitCard,
                ),
              ),
              _paymentItem(
                locale.value.walletRTFTokens,
                isSelected:
                    controller.selectedPaymentMethod.value ==
                    locale.value.walletRTFTokens,
                onTap: () => controller.selectPaymentMethod(
                  locale.value.walletRTFTokens,
                ),
              ),
              _paymentItem(
                locale.value.payPal,
                isSelected:
                    controller.selectedPaymentMethod.value ==
                    locale.value.payPal,
                onTap: () =>
                    controller.selectPaymentMethod(locale.value.payPal),
              ),*/
              /*if (controller.selectedPaymentMethod.value ==
                  locale.value.creditDebitCard) ...[
                SizedBox(height: 16.h),
                Text(
                  locale.value.creditCardDetails,
                  style: TextStyleHelper.urMedium500().copyWith(
                    fontSize: 16.sp,
                    color: ColorHelper.headingColor,
                  ),
                ),
                SizedBox(height: 16.h),
                CommanTextField(
                  controller: controller.cardNumberController,
                  textFieldType: TextFieldType.NUMBER,
                  maxLength: 19,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CardNumberInputFormatter(),
                  ],
                  validator: controller.validateCardNumber,
                  decoration:
                      _inputDecoration(
                        hintText: locale.value.cardNumber,
                      ).copyWith(
                        counterText: '',
                        suffixIcon: CachedImageView(
                          imagePath: ImageHelper.icCreditCard,
                          height: 18.h,
                          width: 18.w,
                          color: ColorHelper.iconColor,
                        ).paddingAll(18.sp),
                      ),
                ),
                SizedBox(height: 12.h),
                CommanTextField(
                  controller: controller.cardHolderNameController,
                  textFieldType: TextFieldType.NAME,
                  validator: (value) => (value == null || value.isEmpty)
                      ? locale.value.errorFieldRequired
                      : null,
                  decoration: _inputDecoration(
                    hintText: locale.value.nameOnCard,
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: CommanTextField(
                        controller: controller.expiryDateController,
                        textFieldType: TextFieldType.NUMBER,
                        maxLength: 5,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CardMonthInputFormatter(),
                        ],
                        validator: controller.validateExpiryDate,
                        decoration: _inputDecoration(
                          hintText: locale.value.expiryDate,
                        ).copyWith(counterText: ''),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: CommanTextField(
                        controller: controller.cvvController,
                        textFieldType: TextFieldType.NUMBER,
                        maxLength: 3,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: controller.validateCVV,
                        decoration: _inputDecoration(hintText: locale.value.cvv)
                            .copyWith(
                              counterText: '',
                              suffixIcon: CachedImageView(
                                imagePath: ImageHelper.icInfo,
                                height: 18.h,
                                width: 18.w,
                                color: ColorHelper.iconColor,
                              ).paddingAll(18.sp),
                            ),
                      ),
                    ),
                  ],
                ),
              ],
              if (controller.selectedPaymentMethod.value ==
                  locale.value.walletRTFTokens) ...[
                SizedBox(height: 16.h),
                _walletSection(),
              ],*/
            ],
          ),
        ),
      ),
    );
  }

  /*Widget _walletSection() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CustomPaint(
              size: Size(double.infinity, 130.h),
              painter: WalletBackgroundPainter(),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 22.w, vertical: 26.h),
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: ColorHelper.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  CachedImageView(
                    imagePath: ImageHelper.icWallet,
                    height: 18.h,
                    width: 18.w,
                    color: ColorHelper.subHeadingColor,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    locale.value.walletText,
                    style: TextStyleHelper.urMedium500().copyWith(
                      fontSize: 16.sp,
                      color: ColorHelper.headingColor,
                    ),
                  ),
                  const Spacer(),
                  /*Text(
                    '5000 RFT',
                    style: TextStyleHelper.urMedium500().copyWith(
                      fontSize: 16.sp,
                      color: ColorHelper.headingColor,
                    ),
                  ),*/
                  SizedBox(width: 8.w),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16.sp,
                    color: ColorHelper.iconColor,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          decoration: BoxDecoration(
            gradient: ColorHelper.offerNotificationBgGradient,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Obx(
            () => CustomCheckbox(
              value: controller.useWalletCredits.value,
              onChanged: controller.toggleWalletCredits,
              borderColor: ColorHelper.iconColor,
              size: 18.sp,
              label: locale.value.useWalletCreditsText,
              labelStyle: TextStyleHelper.dmRegular400().copyWith(
                fontSize: 12.sp,
                color: ColorHelper.subHeadingColor,
              ),
            ),
          ),
        ),
      ],
    );
  }*/

  Widget _paymentItem(
    String method, {
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            Container(
              height: 20.sp,
              width: 20.sp,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: ColorHelper.primary, width: 1.5),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        height: 10.sp,
                        width: 10.sp,
                        decoration: const BoxDecoration(
                          color: ColorHelper.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 12.w),
            Text(
              method,
              style: TextStyleHelper.urMedium500().copyWith(
                fontSize: 14.sp,
                color: ColorHelper.headingColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hintText}) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: ColorHelper.transparent,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: ColorHelper.lightGrey),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: ColorHelper.lightGrey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: ColorHelper.lightGrey),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: ColorHelper.lightGrey),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: ColorHelper.primary),
      ),
    );
  }

  Widget _expansionTile({
    required String title,
    String? subtitle,
    required bool isExpanded,
    required VoidCallback onTap,
    required Widget expandedChild,
    Widget? collapsedSummary,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ColorHelper.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: ColorHelper.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(12.sp),
            child: InkWell(
              onTap: onTap,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyleHelper.urMedium500().copyWith(
                            fontSize: 16.sp,
                            color: ColorHelper.headingColor,
                          ),
                        ),
                        if (collapsedSummary == null && subtitle != null)
                          Text(
                            subtitle,
                            style: TextStyleHelper.dmRegular400().copyWith(
                              fontSize: 12.sp,
                              color: ColorHelper.subHeadingColor,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: ColorHelper.iconColor,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            // SizedBox(height: 16.h),
            const Divider(color: ColorHelper.borderColor, height: 1),
            SizedBox(height: 12.h),
            expandedChild.paddingSymmetric(horizontal: 12.w),
            SizedBox(height: 12.h),
          ] else if (collapsedSummary != null) ...[
            SizedBox(height: 12.h),
            collapsedSummary.paddingSymmetric(horizontal: 12.w),
            SizedBox(height: 12.h),
          ],
        ],
      ),
    );
  }

  Widget _addressItem(AddressModel address) {
    bool isSelected = controller.selectedAddress.value == address;
    return InkWell(
      onTap: () => controller.selectAddress(address),
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.all(12.sp),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? ColorHelper.primary : ColorHelper.borderColor,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        address.name,
                        style: TextStyleHelper.urMedium500().copyWith(
                          fontSize: 14.sp,
                          color: ColorHelper.headingColor,
                        ),
                      ),
                      // SizedBox(width: 8.w),
                      // Container(
                      //   padding: EdgeInsets.symmetric(
                      //     horizontal: 8.w,
                      //     vertical: 4.h,
                      //   ),
                      //   decoration: BoxDecoration(
                      //     border: Border.all(color: ColorHelper.primary),
                      //     borderRadius: BorderRadius.circular(8.r),
                      //   ),
                      //   child: Text(
                      //     address.tag,
                      //     style: TextStyleHelper.urMedium500().copyWith(
                      //       fontSize: 10.sp,
                      //       color: ColorHelper.primary,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    address.address,
                    style: TextStyleHelper.dmRegular400().copyWith(
                      fontSize: 12.sp,
                      color: ColorHelper.subHeadingColor,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => controller.onEditAddressTap(address),
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              icon: CachedImageView(
                imagePath: ImageHelper.icPen,
                height: 18.h,
                width: 18.w,
                color: ColorHelper.iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemsSection() {
    final selectedItems = controller.bagController.cartItems;
    return Container(
      decoration: const BoxDecoration(
        color: ColorHelper.white,
        border: Border(top: BorderSide(color: ColorHelper.borderColor)),
      ),
      child: Column(
        children: [
          SizedBox(height: 16.h),
          ...selectedItems.map((item) => _itemWidget(item)),
          const Divider(color: ColorHelper.borderColor, height: 1),
          _priceDetailsSection(),
          _termsSection(),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Widget _emptyState({required String message, String? description}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: TextStyleHelper.urMedium500().copyWith(
              fontSize: 16.sp,
              color: ColorHelper.headingColor,
            ),
            textAlign: TextAlign.center,
          ),
          if (description != null) ...[
            SizedBox(height: 4.h),
            Text(
              description,
              style: TextStyleHelper.dmRegular400().copyWith(
                fontSize: 12.sp,
                color: ColorHelper.subHeadingColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _itemWidget(CartItem item) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: CachedImageView(
              imagePath: item.image,
              height: 100.h,
              width: 100.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyleHelper.urMedium500().copyWith(
                    fontSize: 16.sp,
                    color: ColorHelper.headingColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  item.description,
                  style: TextStyleHelper.dmRegular400().copyWith(
                    fontSize: 12.sp,
                    color: ColorHelper.subHeadingColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                if (item.variantTitle.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    item.variantTitle,
                    style: TextStyleHelper.dmRegular400().copyWith(
                      fontSize: 12.sp,
                      color: ColorHelper.headingColor,
                    ),
                  ),
                ],
                SizedBox(height: 4.h),
                Text(
                  '${locale.value.quantityText}: ${item.quantity}',
                  style: TextStyleHelper.dmRegular400().copyWith(
                    fontSize: 12.sp,
                    color: ColorHelper.headingColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${locale.value.soldByText} ${item.vendor}',
                  style: TextStyleHelper.urRegular400().copyWith(
                    fontSize: 12.sp,
                    color: ColorHelper.hintColor,
                  ),
                ),
                SizedBox(height: 8.h),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Obx(
                        () => Text(
                          item.priceEuro.toPrice(),
                          style: TextStyleHelper.urSemiBold600().copyWith(
                            fontSize: 14.sp,
                            color: ColorHelper.headingColor,
                          ),
                        ),
                      ),
                      /*SizedBox(width: 8.w),
                      const VerticalDivider(
                        width: 1,
                        color: ColorHelper.borderColor,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '${item.priceRFT} RFT',
                        style: TextStyleHelper.urSemiBold600().copyWith(
                          fontSize: 14.sp,
                          color: ColorHelper.primary,
                        ),
                      ),*/
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceDetailsSection() {
    return Padding(
      padding: EdgeInsets.all(16.sp),
      child: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _priceRow(
              locale.value.priceDetailsWithCount(
                controller.bagController.cartItemCount,
              ),
              controller.bagController.itemSubtotalEuro,
            ),
            if (controller.isPromoApplied.value ||
                controller.bagController.discountTotalEuro > 0) ...[
              SizedBox(height: 8.h),
              _priceRow(
                locale.value.discount,
                -(controller.discountAmount.value > 0
                    ? controller.discountAmount.value
                    : controller.bagController.discountTotalEuro),
              ),
            ],
            if (controller.bagController.taxTotalEuro > 0) ...[
              SizedBox(height: 8.h),
              _priceRow(
                locale.value.tax,
                controller.bagController.taxTotalEuro,
              ),
            ],
            if (controller.bagController.shippingTotalEuro > 0) ...[
              SizedBox(height: 8.h),
              _priceRow(
                locale.value.shippingText,
                controller.bagController.shippingTotalEuro,
              ),
            ],
            SizedBox(height: 8.h),
            _priceRow(
              locale.value.totalText,
              controller.bagController.totalEuro,
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _promoCodeSection() {
    return Obx(
      () => _expansionTile(
        title: locale.value.promotionCode,
        subtitle: controller.isPromoApplied.value
            ? controller.appliedPromoCode.value
            : null,
        isExpanded: controller.isPromoExpanded.value,
        onTap: controller.togglePromo,
        expandedChild: Row(
          children: [
            Expanded(
              child: CommanTextField(
                enabled: !controller.isPromoApplied.value,
                controller: controller.promoCodeController,
                textFieldType: TextFieldType.NAME,
                decoration:
                    _inputDecoration(
                      hintText: locale.value.enterPromotionCode,
                    ).copyWith(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                    ),
              ),
            ),
            SizedBox(width: 12.w),
            CommonBtn(
              onTap: controller.isPromoLoading.value
                  ? null
                  : (controller.isPromoApplied.value
                        ? controller.removePromoCode
                        : controller.applyPromoCode),
              color: controller.isPromoApplied.value
                  ? ColorHelper.error
                  : ColorHelper.primary,
              isLoading: controller.isPromoLoading.value,
              disabledColor: ColorHelper.lightGrey,
              text: controller.isPromoApplied.value
                  ? locale.value.removeText
                  : locale.value.applyText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceRow(
    String label,
    double euro /*int rft,*/, {
    bool isTotal = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: isTotal
                ? TextStyleHelper.urBold700().copyWith(
                    fontSize: 16.sp,
                    color: ColorHelper.primary,
                  )
                : TextStyleHelper.urMedium500().copyWith(
                    fontSize: 16.sp,
                    color: ColorHelper.headingColor,
                  ),
          ),
        ),
        IntrinsicHeight(
          child: Row(
            children: [
              Text(
                euro.toPrice(),
                style: TextStyleHelper.urRegular400().copyWith(
                  fontSize: 14.sp,
                  fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
                  color: euro < 0
                      ? ColorHelper.success
                      : ColorHelper.headingColor,
                ),
              ),
              /*SizedBox(width: 8.w),
              const VerticalDivider(width: 1, color: ColorHelper.borderColor),
              SizedBox(width: 8.w),
              Text(
                '$rft RFT',
                style: TextStyleHelper.urRegular400().copyWith(
                  fontSize: 14.sp,
                  fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
                  color: isTotal ? ColorHelper.primary : ColorHelper.hintColor,
                ),
              ),*/
            ],
          ),
        ),
      ],
    );
  }

  Widget _termsSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: ColorHelper.offerNotificationBgGradient,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => CustomCheckbox(
              value: controller.isTermsAccepted.value,
              onChanged: controller.onTermsChanged,
              size: 18.sp,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              locale
                  .value
                  .byPlacingYourOrderYouAgreeToOurBuyerTermsAndConditions,
              style: TextStyleHelper.dmRegular400().copyWith(
                fontSize: 12.sp,
                color: ColorHelper.headingColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomSection() {
    return Obx(() {
      final isReady = controller.isReadyToOrder;
      return CommonBtn(
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
        enabled: !controller.isPlaceOrderLoading.value && isReady,
        isLoading: controller.isPlaceOrderLoading.value,
        onTap: controller.onPlaceOrder,
        text: controller.checkoutButtonText,
        disabledColor: ColorHelper.lightGrey,
        color: isReady
            ? ColorHelper.primary
            : ColorHelper.inputDecorationBorder,
        textColor: isReady ? ColorHelper.white : ColorHelper.subHeadingColor,
      );
    });
  }
}
