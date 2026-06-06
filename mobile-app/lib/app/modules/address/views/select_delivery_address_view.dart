import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/modules/address/model/google_map_model.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/base_scaffold.dart';

import '../controllers/address_controller.dart';

/// [SelectDeliveryAddressView] allows users to pick a delivery location
/// using an interactive map and search functionality.
class SelectDeliveryAddressView extends GetView<AddressController> {
  const SelectDeliveryAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CommonAppBar(title: locale.value.selectDeliveryAddressText),
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                _buildSearchField(),
                SizedBox(height: 16.h),
                _buildGoogleMap(context),
              ],
            ),
          ),
          _buildBottomCard(),
        ],
      ),
    );
  }

  /// Builds the Google Map background
  Widget _buildGoogleMap(BuildContext context) {
    return Obx(
      () => GoogleMap(
        onMapCreated: controller.onMapCreated,
        initialCameraPosition: controller.cameraPosition.value,
        onCameraMoveStarted: controller.onCameraMoveStarted,
        onCameraMove: controller.onCameraMove,
        onCameraIdle: controller.onCameraIdle,
        onTap: (latLng) {
          hideKeyboard(context);
          controller.onMapTap(latLng);
        },
        markers: controller.markers,
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
        compassEnabled: false,
        mapToolbarEnabled: false,
      ),
    ).expand();
  }

  /// Builds the address search input
  Widget _buildSearchField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: TypeAheadField<GooglePlacesModel>(
        controller: controller.searchController,
        builder: (context, searchFieldController, focusNode) {
          return TextField(
            controller: searchFieldController,
            focusNode: focusNode,
            style: TextStyleHelper.urMedium500().copyWith(
              fontSize: 14.sp,
              color: ColorHelper.headingColor,
            ),
            onChanged: (val) {
              controller.searchQuery.value = val;
            },
            decoration: InputDecoration(
              hintText: locale.value.searchForAreaText,
              prefixIcon: CachedImageView(
                imagePath: ImageHelper.icSearch,
                size: 16.sp,
              ).paddingAll(16.sp),
              suffixIcon: Obx(
                () => controller.searchQuery.value.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.close,
                          size: 22.sp,
                          color: ColorHelper.iconColor,
                        ),
                        onPressed: () => controller.clearSearch(),
                      )
                    : const SizedBox.shrink(),
              ),
              fillColor: ColorHelper.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(color: ColorHelper.lightGrey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(color: ColorHelper.lightGrey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(color: ColorHelper.primary),
              ),
            ),
          );
        },
        suggestionsCallback: (search) =>
            controller.getAddressSuggestions(search),
        itemBuilder: (context, suggestion) {
          return _searchResultItem(
            title:
                suggestion.structuredFormatting?.mainText ??
                suggestion.description ??
                '',
            subtitle: suggestion.structuredFormatting?.secondaryText,
          );
        },
        emptyBuilder: (context) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Text(
              locale.value.noSuggestionsFoundText,
              style: TextStyleHelper.dmRegular400().copyWith(
                color: ColorHelper.hintColor,
              ),
            ),
          );
        },
        onSelected: (suggestion) => controller.onSuggestionSelected(suggestion),
      ),
    );
  }

  Widget _searchResultItem({required String title, String? subtitle}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Row(
        children: [
          CachedImageView(
            imagePath: ImageHelper.icLocation,
            size: 20.sp,
            color: ColorHelper.iconColor,
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyleHelper.urMedium500().copyWith(
                  fontSize: 14.sp,
                  color: ColorHelper.headingColor,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: TextStyleHelper.urRegular400().copyWith(
                    fontSize: 12.sp,
                    color: ColorHelper.hintColor,
                  ),
                ),
            ],
          ).expand(),

          SizedBox(width: 8.w),
          Icon(Icons.north_west, color: ColorHelper.iconColor, size: 18.sp),
        ],
      ),
    );
  }

  /// Builds the bottom info card with address details and confirmation
  Widget _buildBottomCard() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 30.h),
        color: ColorHelper.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBottomCardHeader(),
            const Divider(color: ColorHelper.borderColor, height: 1),
            SizedBox(height: 12.h),
            _buildAddressSelectionBox(),
          ],
        ),
      ),
    );
  }

  /// Builds the header row of the bottom card
  Widget _buildBottomCardHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          locale.value.deliverToText,
          style: TextStyleHelper.urMedium500().copyWith(
            fontSize: 20.sp,
            color: ColorHelper.headingColor,
          ),
        ),
        IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.close, color: ColorHelper.iconColor, size: 22.sp),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  /// Builds the address info box and confirmation button
  Widget _buildAddressSelectionBox() {
    return Container(
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: ColorHelper.primaryLightColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedImageView(
                imagePath: ImageHelper.icLocation,
                height: 24.r,
                width: 24.r,
                color: ColorHelper.black,
              ),
              SizedBox(width: 12.w),
              Expanded(child: _buildAddressTextInfo()),
            ],
          ),
          SizedBox(height: 24.h),
          CommonBtn(
            onTap: () => controller.onConfirmLocation(),
            text: locale.value.confirmLocationText,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  /// Builds the address name and full address strings
  Widget _buildAddressTextInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(
          () => Text(
            controller.selectedAddressName.value,
            style: TextStyleHelper.urMedium500().copyWith(
              fontSize: 14.sp,
              color: ColorHelper.headingColor,
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Obx(
          () => Text(
            controller.selectedFullAddress.value,
            style: TextStyleHelper.dmRegular400().copyWith(
              fontSize: 12.sp,
              color: ColorHelper.subHeadingColor,
            ),
          ),
        ),
      ],
    );
  }
}
