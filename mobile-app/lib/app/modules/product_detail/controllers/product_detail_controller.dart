import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/locale/locale_controller.dart';
import 'package:refashion/app/modules/bag/service/cart_api_service.dart';
import 'package:refashion/app/modules/profile/controllers/currency_controller.dart';
import 'package:refashion/app/utills/hive/hive_keys.dart';
import 'package:refashion/app/utills/hive/hive_utils.dart';
import 'package:refashion/app/network/api_configs.dart';
import 'package:refashion/app/services/cart_controller.dart';
import '../models/eco_score_model.dart';
import '../models/product_list_model.dart';
import '../models/seller_info_model.dart';
import '../models/review_model.dart';
import '../service/product_service.dart';
import 'package:refashion/app/services/wishlist_controller.dart';
import '../../../routes/app_pages.dart';

class ProductDetailController extends GetxController {
  final ProductService _productService = ProductService();
  final CartApiService _cartApiService = CartApiService();
  final PageController pageController = PageController();
  final RxInt currentImageIndex = 0.obs;

  final Rxn<Product> product = Rxn<Product>();
  final Rxn<SellerInfo> sellerInfo = Rxn<SellerInfo>();
  final Rxn<EcoScoreModel> ecoScore = Rxn<EcoScoreModel>();
  final RxList<ReviewModel> reviewsList = <ReviewModel>[].obs;
  final RxBool isReviewsLoading = false.obs;
  final RxBool isSellerInfoLoading = false.obs;
  final RxBool isLoading = true.obs;
  final RxBool isBagLoading = false.obs;
  final RxBool isShippingReturnsExpanded = false.obs;
  final RxBool isDescriptionExpanded = false.obs;
  final RxBool isEcoScoreExpanded = false.obs;

  final GlobalKey descriptionKey = GlobalKey();
  final GlobalKey shippingKey = GlobalKey();
  final GlobalKey ecoScoreKey = GlobalKey();

  void toggleShippingReturns() {
    isShippingReturnsExpanded.value = !isShippingReturnsExpanded.value;
    if (isShippingReturnsExpanded.value) {
      _scrollTo(shippingKey);
    }
  }

  void toggleDescription() {
    isDescriptionExpanded.value = !isDescriptionExpanded.value;
    if (isDescriptionExpanded.value) {
      _scrollTo(descriptionKey);
    }
  }

  void toggleEcoScore() {
    isEcoScoreExpanded.value = !isEcoScoreExpanded.value;
    if (isEcoScoreExpanded.value) {
      _scrollTo(ecoScoreKey);
    }
  }

  void _scrollTo(GlobalKey key) {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (key.currentContext != null) {
        Scrollable.ensureVisible(
          key.currentContext!,
          duration: const Duration(milliseconds: 300),
          alignment: 0.0,
          curve: Curves.easeInOut,
        );
      }
    });
  }

  bool get isWishlisted =>
      WishlistController.to.wishlistedIds.contains(product.value?.id);

  // Variant selection
  final RxMap<String, String> selectedOptions = <String, String>{}.obs;
  final Rxn<ProductVariant> selectedVariant = Rxn<ProductVariant>();

  DateTime? _lastShareTapTime;

  @override
  void onInit() {
    super.onInit();
    _loadProductData();
  }

  Future<void> _loadProductData() async {
    try {
      isLoading(true);
      final dynamic args = Get.arguments;
      String? productId;

      if (args is String) {
        productId = args;
      } else if (args is Product) {
        productId = args.id;
        product.value = args;
        _autoSelectVariant();
      }

      if (productId != null) {
        final fetchedProduct = await _productService.fetchProductDetail(
          productId,
        );
        product.value = fetchedProduct;

        _autoSelectVariant();

        // Fetch seller info in parallel (non-blocking)
        _loadSellerInfo(productId);
        // _loadEcoScore(productId);
      }
    } catch (e) {
      debugPrint('Error loading product details: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> _loadSellerInfo(String productId) async {
    try {
      isSellerInfoLoading(true);
      final seller = await _productService.fetchSellerInfo(productId);
      sellerInfo.value = seller;
      if (seller != null) {
        _loadReviews(sellerId: seller.id);
      } else {
        _loadReviews();
      }
    } catch (e) {
      debugPrint('Error loading seller info: $e');
      _loadReviews();
    } finally {
      isSellerInfoLoading(false);
    }
  }

  // Future<void> _loadEcoScore(String productId) async {
  //   try {
  //     final score = await _productService.fetchEcoScore(productId);
  //     ecoScore.value = score;
  //   } catch (e) {
  //     debugPrint('Error loading eco score: $e');
  //   }
  // }

  Future<void> onWishlistTap() async {
    if (product.value?.id == null) return;
    await WishlistController.to.toggleWishlist(product.value!.id!);
  }

  bool isVariantInStock(ProductVariant? variant) {
    if (variant == null) return false;

    // If stock management is not enabled for this variant
    if (variant.manageInventory == false) return true;

    if (variant.inventoryItems == null || variant.inventoryItems!.isEmpty) {
      return true;
    }

    for (var item in variant.inventoryItems!) {
      if (item.inventory?.locationLevels != null) {
        int totalAvailable = 0;
        for (var level in item.inventory!.locationLevels!) {
          totalAvailable += (level.availableQuantity ?? 0);
        }
        if (totalAvailable <= 0) return false;
      }
    }

    return true;
  }

  void _autoSelectVariant() {
    if (product.value == null) return;

    final variants = product.value!.variants;
    if (variants != null && variants.isNotEmpty) {
      // Prefer the first IN-STOCK variant
      ProductVariant variant = variants.firstWhere(
        (v) => isVariantInStock(v),
        orElse: () => variants.first,
      );

      selectedVariant.value = variant;

      // Update selected options based on the auto-selected variant
      if (variant.options != null) {
        selectedOptions.clear();
        for (var optionValue in variant.options!) {
          if (optionValue.optionId != null && optionValue.id != null) {
            selectedOptions[optionValue.optionId!] = optionValue.id!;
          }
        }
      }
    }
  }

  void onOptionSelected(String optionId, String optionValueId) {
    selectedOptions[optionId] = optionValueId;
    _findSelectedVariant();
  }

  void _findSelectedVariant() {
    if (product.value == null || product.value!.variants == null) return;

    final variants = product.value!.variants!;

    // A variant matches if its options match ALL user selections (by ID)
    final variant = variants.firstWhereOrNull((v) {
      if (v.options == null) return false;

      return selectedOptions.entries.every((entry) {
        return v.options!.any(
          (optVal) => optVal.optionId == entry.key && optVal.id == entry.value,
        );
      });
    });

    selectedVariant.value = variant;
    if (variant != null) {
      debugPrint('Selected Option IDs: $selectedOptions');
      debugPrint('Selected Variant ID: ${variant.id}');
    }
  }

  /// Helper to get the human-readable text for a selected option ID
  String? getSelectedOptionValueText(String optionId) {
    if (product.value == null || product.value!.options == null) return null;

    final valueId = selectedOptions[optionId];
    if (valueId == null) return null;

    final option = product.value!.options!.firstWhereOrNull(
      (o) => o.id == optionId,
    );
    if (option == null || option.values == null) return null;

    final valueObj = option.values!.firstWhereOrNull((v) => v.id == valueId);
    return valueObj?.value;
  }

  /// Checks if a specific option value is available for any variant of the product.
  bool isOptionAvailable(
    String optionId,
    String optionValueId, {
    bool checkCurrentSelection = true,
  }) {
    if (product.value == null || product.value!.variants == null) return false;

    final variants = product.value!.variants!;

    return variants.any((v) {
      if (v.options == null) return false;

      // Stock check
      if (!isVariantInStock(v)) return false;

      // 1. Check if this variant has this specific option-value pair (by ID)
      final hasValue = v.options!.any(
        (optVal) => optVal.optionId == optionId && optVal.id == optionValueId,
      );
      if (!hasValue) return false;

      // 2. Verify it matches all OTHER selected options
      if (checkCurrentSelection) {
        return selectedOptions.entries.every((entry) {
          if (entry.key == optionId) {
            return true; // Skip the one we are checking
          }

          return v.options!.any(
            (optVal) =>
                optVal.optionId == entry.key && optVal.id == entry.value,
          );
        });
      }

      return true;
    });
  }

  void onPageChanged(int index) {
    currentImageIndex.value = index;
  }

  void onShareTap() {
    final now = DateTime.now();
    if (_lastShareTapTime != null &&
        now.difference(_lastShareTapTime!) < const Duration(seconds: 1)) {
      return;
    }
    _lastShareTapTime = now;

    if (product.value == null) return;

    final String title = product.value?.title ?? "";
    final String description = product.value?.description ?? "";
    final String handle = product.value?.handle ?? "";

    // Professional share message
    final String shareText =
        'Check out this $title on Re-Fashion!\n\n${description.length > 100 ? '${description.substring(0, 100)}...' : description}\n\nView more details here:\n${ApiConfig.frontendUrl}/products/$handle';

    final box = Get.context?.findRenderObject() as RenderBox?;
    SharePlus.instance.share(
      ShareParams(
        text: shareText,
        subject: 'Take a look at $title',
        sharePositionOrigin: box != null
            ? box.localToGlobal(Offset.zero) & box.size
            : null,
      ),
    );
  }

  void onBagTap() {
    Get.toNamed(Routes.bag);
  }

  void onFollowTap() {
    // Handle follow tap
  }

  void onChatTap() {
    Get.toNamed(Routes.chat);
  }

  void onMakeOfferTap() {
    Get.toNamed(Routes.makeAnOffer, arguments: product.value);
  }

  Future<void> onAddToBagTap() async {
    if (isBagLoading.value) return;

    if (selectedVariant.value == null) {
      toast(locale.value.toastSelectVariant);
      return;
    }

    try {
      isBagLoading(true);

      // 1. Get required data
      final String regionId =
          HiveUtils.get(HiveKeys.regionId) ??
          "reg_01K15HJ2CS7G3MWPPQM3G8QFNV"; // Fallback to default
      final String email = HiveUtils.get(HiveKeys.userEmail) ?? '';

      final String currencyCode =
          CurrencyController.to.selectedCurrency.code ?? "eur";

      String? cartId = HiveUtils.get(HiveKeys.cartId);

      // 2. Create Cart if not exists
      if (cartId == null || cartId.isEmpty) {
        final cartResponse = await _cartApiService.createCart(
          regionId: regionId,
          email: email,
          currencyCode: currencyCode,
        );

        if (cartResponse != null && cartResponse['cart'] != null) {
          cartId = cartResponse['cart']['id'];
          HiveUtils.set(HiveKeys.cartId, cartId);
        }
      }

      // 3. Fetch Seller ID and details
      if (sellerInfo.value == null && product.value?.id != null) {
        await _loadSellerInfo(product.value!.id!);
      }

      String? sellerId;
      if (product.value?.id != null) {
        sellerId = await _productService.fetchProductSeller(product.value!.id!);
      }

      final Map<String, dynamic> metadata = {};
      if (sellerId != null) {
        metadata["seller_id"] = sellerId;
      }
      if (sellerInfo.value?.name != null) {
        metadata["seller_name"] = sellerInfo.value!.name;
      }
      if (sellerInfo.value?.photo != null) {
        metadata["seller_photo"] = sellerInfo.value!.photo;
      }

      // 4. Add Line Item if we have a cartId
      if (cartId != null && cartId.isNotEmpty) {
        final lineItemResponse = await _cartApiService.addLineItem(
          cartId: cartId,
          variantId: selectedVariant.value!.id!,
          quantity: 1,
          metadata: metadata.isNotEmpty ? metadata : null,
        );

        if (lineItemResponse != null) {
          CartController.to.refreshCartCount();
          toast(locale.value.toastAddedToBag);
        }
      }
    } catch (e) {
      debugPrint('Error adding to bag: $e');
      toast(e.toString());
    } finally {
      isBagLoading(false);
    }
  }

  Future<void> _loadReviews({String? sellerId}) async {
    try {
      isReviewsLoading(true);
      final response = await _productService.fetchSellerReviews(
        sellerId: sellerId,
      );
      if (response != null &&
          response.reviews != null &&
          response.reviews!.isNotEmpty) {
        reviewsList.assignAll(response.reviews!);
      } else {
        reviewsList.clear();
      }
    } catch (e) {
      debugPrint('Error loading reviews: $e');
      reviewsList.clear();
    } finally {
      isReviewsLoading(false);
    }
  }

  double get averageRating {
    if (reviewsList.isEmpty) return 0.0;
    final total = reviewsList.fold<double>(
      0,
      (sum, r) => sum + (r.rating ?? 0),
    );
    return total / reviewsList.length;
  }

  Future<void> onRefresh() async {
    await _loadProductData();
  }
}
