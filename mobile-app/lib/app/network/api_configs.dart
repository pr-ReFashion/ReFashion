class ApiConfig {
  static const String baseUrl = 'http://195.251.8.72:9000';
  static const String frontendUrl = 'http://195.251.8.72:3000';

  // You can add more API-related configurations here
  static const String apiVersion = 'v1';

  /// [END_POINTS]
  /// [AUTH]
  static const String authCustomerEmailpassRegister = 'auth/customer/emailpass/register';
  static const String authSellerEmailpassRegister = 'auth/seller/emailpass/register';
  static const String authCustomerEmailpassLogin = 'auth/customer/emailpass';
  static const String authSellerEmailpassLogin = 'auth/seller/emailpass';
  static const String storeCustomers = 'store/customers';

  static const String customerResetPassword = 'auth/customer/emailpass/reset-password';
  static const String customerUpdatePassword = 'auth/customer/emailpass/update';

  /// [PRODUCTS]
  static const String storeProductCategories = 'store/product-categories';
  static const String storeCollections = 'store/collections';
  static const String storeProducts = 'store/products';

  static String storeProductsId(String id) => 'store/products/$id';
  static const String storeFilters = 'store/custom/product-filters';
  static const String ecoScore = 'eco-score';
  static const String storeReviews = 'store/reviews';

  /// [SETTINGS]
  static const String storeCurrencies = 'store/currencies';
  static const String storeLocales = 'store/locales';

  /// [CART]
  static const String storeCarts = 'store/carts';

  static String storeCartLineItems(String cartId) => 'store/carts/$cartId/line-items';

  static String storeCartLineItemDelete(String cartId, String lineId) => 'store/carts/$cartId/line-items/$lineId';

  static String storeCart(String cartId) => 'store/carts/$cartId';

  static String storeCartPromotions(String cartId) => 'store/carts/$cartId/promotions';

  static String storeCartShippingMethods(String cartId) => 'store/carts/$cartId/shipping-methods';

  /// [CUSTOMER_ADDRESS]
  static const String customerMeAddresses = 'store/customers/me/addresses';
  static const String customerAddress = 'store/customer/address';

  static String customerAddressById(String id) => 'store/customers/me/addresses/$id';

  /// [REGIONS]
  static const String storeRegions = 'store/regions';

  /// [CUSTOMER]
  static const String storeCustomerMe = 'store/customers/me';

  /// [CHECKOUT]
  static String storeShippingOptions(String cartId) => 'store/shipping-options?cart_id=$cartId';
  static const String storePaymentCollections = 'store/payment-collections';

  static String storePaymentSessions(String id) => 'store/payment-collections/$id/payment-sessions';

  static String storeCartComplete(String id) => 'store/carts/$id/complete';

  /// [CREATE_PRODUCT]
  static const String storeProductTags = 'store/product-tags';
  static const String storeProductTypes = 'store/product-types';
  static const String vendorSalesChannels = 'vendor/sales-channels';
  static const String vendorProducts = 'vendor/products';

  static String vendorProductById(String id) => 'vendor/products/$id';
  static const String vendorUploads = 'vendor/uploads';
  static const String storeStockLocations = 'vendor/stock-locations';

  static String storeStockLocationsSalesChannels(String id) => 'vendor/stock-locations/$id/sales-channels';

  static String vendorInventoryItemsBatch(String id) => 'vendor/inventory-items/$id/location-levels/batch';

  static String vendorInventoryItemsLocation(String inventoryId, String locationId) => 'vendor/inventory-items/$inventoryId/location-levels/$locationId';

  /// [SELLER]
  static const String vendorSellers = 'vendor/sellers';
  static const String vendorSellersMe = 'vendor/sellers/me';

  static String vendorProductsIdSeller(String id) => 'products/$id/seller';

  /// [ORDERS]
  static const String storeOrders = 'store/orders';

  static String storeOrdersId(String id) => 'store/orders/$id';
  static const String storeReturnReasons = 'store/return-reasons';
  static const String storeReturns = 'store/returns';
  static const String vendorOrders = 'vendor/orders';

  static String vendorOrdersId(String id) => 'vendor/orders/$id';

  static String adminCustomerForceDelete(String id) => 'admin/customers/$id/force-delete';

  /// [WISHLIST]
  static const String storeWishlist = 'store/wishlist';

  static String storeWishlistProduct(String wishlistId, String productId) => 'store/wishlist/$wishlistId/product/$productId';

  /// [REWARDS]
  static String storeRewardsId(String customerId) => 'store/rewards/$customerId';
}
