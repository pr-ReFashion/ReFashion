import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refashion/app/constant/comman_app_bar.dart';
import 'package:refashion/app/constant/common_button.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/extension.dart';
import 'package:refashion/app/widget/base_scaffold.dart';
import 'package:refashion/app/widget/custom_dropdown.dart';
import 'package:refashion/app/modules/profile/model/currency_model.dart';
import 'package:refashion/app/modules/address/model/country_list_model.dart';
import 'package:refashion/app/modules/profile/shimmer/currency_shimmer.dart';
import '../controllers/language_currency_controller.dart';

class LanguageCurrencyView extends GetView<LanguageCurrencyController> {
  const LanguageCurrencyView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: ColorHelper.offWhite,
      appBar: CommonAppBar(title: locale.value.ragionAndCurrency),
      body: Obx(() {
        if (controller.currencyController.isInitialLoading.value) {
          return const CurrencyShimmer();
        }
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(height: 8.h),
                    // Text(
                    //   locale.value.languageAndCurrency,
                    //   style: TextStyleHelper.urSemiBold600().copyWith(
                    //     fontSize: 18.sp,
                    //     color: ColorHelper.headingColor,
                    //   ),
                    // ),
                    // SizedBox(height: 12.h),
                    // CustomDropdown<LocaleModel>(
                    //   label: locale.value.language,
                    //   value: controller.tempSelectedLocale.value,
                    //   isLoading: controller.isLocalesLoading.value,
                    //   items: controller.availableLocales
                    //       .map(
                    //         (e) => DropdownItem(value: e, label: e.name ?? ''),
                    //       )
                    //       .toList(),
                    //   onChanged: controller.onLanguageChanged,
                    //   activeLabelBgColor: ColorHelper.transparent,
                    // ),
                    SizedBox(height: 12.h),
                    CustomDropdown<Region>(
                      label: locale.value.region,
                      value: controller.tempSelectedRegion.value,
                      isLoading: controller.regionController.isLoading.value,
                      items: controller.regionController.availableRegions
                          .map(
                            (e) => DropdownItem(value: e, label: e.name ?? ''),
                          )
                          .toList(),
                      onChanged: controller.onRegionChanged,
                      activeLabelBgColor: ColorHelper.transparent,
                    ),
                    SizedBox(height: 12.h),
                    CustomDropdown<Country>(
                      label: locale.value.countryNameText,
                      value: controller.tempSelectedCountry.value,
                      items:
                          controller.tempSelectedRegion.value?.countries
                              ?.map(
                                (e) => DropdownItem(
                                  value: e,
                                  label:
                                      '${(e.iso2 ?? '').toFlagEmoji()}  ${e.displayName ?? e.name ?? ''}',
                                ),
                              )
                              .toList() ??
                          [],
                      onChanged: controller.onCountryChanged,
                      activeLabelBgColor: ColorHelper.transparent,
                    ),
                    SizedBox(height: 12.h),
                    CustomDropdown<CurrencyModel>(
                      label: locale.value.currency,
                      value: controller.tempSelectedCurrency.value,
                      // isSearchable: true,
                      onSearchChanged: controller.currencyController.onSearch,
                      isLoading: controller.currencyController.isFetching.value,
                      items: controller.currencyController.availableCurrencies
                          .where((e) => e.code?.toLowerCase() == 'eur')
                          .map(
                            (e) => DropdownItem(
                              value: e,
                              label:
                                  '${e.symbolNative ?? e.symbol} ${e.name} (${e.code?.toUpperCase()})',
                            ),
                          )
                          .toList(),
                      onChanged: controller.onCurrencyChanged,
                      activeLabelBgColor: ColorHelper.transparent,
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: CommonBtn(
                text: locale.value.saveChanges,
                onTap: controller.onUpdateTap,
                width: double.infinity,
              ),
            ),
            SizedBox(height: 14.h),
          ],
        );
      }),
    );
  }
}
