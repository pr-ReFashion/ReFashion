import 'package:flutter/material.dart';

abstract class BaseLanguage {
  const BaseLanguage();

  static BaseLanguage of(BuildContext context) =>
      Localizations.of<BaseLanguage>(context, BaseLanguage)!;

  String get next;

  String get letsStart;

  String get welcomeToReFashion;

  String get joinReFashion;

  String get setupProfile;

  String get continueWithGoogle;

  String get continueWithApple;

  String get createAnAccount;

  String get wantToJoinRefashion;

  String get login;

  String get createAccount;

  String get skip;

  String get byCreatingAccount;

  String get termsOfService;

  String get privacyPolicy;

  String get reFashion;

  String get reFashionForStylishAndSustainableFuture;

  String get getStarted;

  String get stepIntoSustainableStyle;

  String get and;

  String get homeText;

  String get favoriteText;

  String get statsText;

  String get profileText;

  String get signupToRefashion;

  String get hintEnterYourName;

  String get hintEnterYourEmail;

  String get lblName;

  String get lblEmail;

  String get lblPassword;

  String get hintEnterYourPassword;

  String get iHaveReadAndAccept;

  String get termsAndCondition;

  String get alreadyHaveAccount;

  String get signUP;

  String get forgotPassword;

  String get loginToRefashion;

  String get enterYourExistingAccountDetailsBelow;

  String get stepIntoSustainableStyleRegisterText;

  String get errorEmailRequired;

  String get errorEmailInvalid;

  String get errorPasswordRequired;

  String get errorPasswordInvalid;

  String get errorNameRequired;

  String get errorNameTooShort;

  String get errorTermsRequired;

  String get toastLoginSuccess;

  String get toastCompleteProfile;

  String get errorProfileFetch;

  String get toastInvalidEmailOrPassword;

  String get toastAccountCreated;

  String get toastRegistrationFailed;

  String get toastPasswordUpdatedSuccessfully;

  String get toastSelectVariant;

  String get toastAddedToBag;

  String get toastProfileUpdatedSuccessfully;

  String get toastNoChangesDetected;

  String get toastProductCreated;

  String get toastProductDeleted;

  String get toastAccountDeleted;

  String get weWillSendAResetLinkToYourRegisteredEmail;

  String get email;

  String get sendEmail;

  String get otpVerification;

  String get enterThe4DigitCodeSentToYourEmail;

  String resendOtpIn(String seconds);

  String get verify;

  String get createPassword;

  String get chooseANewPasswordToContinue;

  String get newPassword;

  String get confirmNewPassword;

  String get submit;

  String get createProduct;

  String get resendOtp;

  String get errorPasswordsDoNotMatch;

  String get lblResetToken;

  String get hintEnterResetToken;

  String get errorTokenRequired;

  String get lblInternetNotAvailableTitle;

  String get retryText;

  String get errorBadRequest;

  String get errorUnauthorized;

  String get errorForbidden;

  String get errorNotFound;

  String get errorInternalServer;

  String get errorBadGateway;

  String get errorServiceUnavailable;

  String get errorTimeout;

  String get errorUnknown;

  String get somethingWentWrong;

  String get errorDescription;

  String get tryAgain;

  String get noItemsFound;

  String get emptyDescription;

  String get refreshPage;

  String get seachHere;

  String get categoryText;

  String get menText;

  String get womenText;

  String get kidsText;

  String get newItemsText;

  String get trendingItemsText;

  String get newsText;

  String get readMoreText;

  String get viewAllText;

  String get searchText;

  String get clearSearch;

  String get itemsText;

  String get usersText;

  String get cancelText;

  String get recentSearchText;

  String get startExploringNow;

  String get yourFavoriteListIsEmpty;

  String get heartYourFavoriteItemsAndTheyWillShowUpHere;

  String get deleteText;

  String get moveFromFavorite;

  String get confirmMoveFromFavorite;

  String get addToBagText;

  String get descriptionText;

  String get detailsText;

  String get colorText;

  String get sizeText;

  String get quantityText;

  String get materialText;

  String get locationText;

  String get authenticationText;

  String get verifiedText;

  String get authenticityConfirmedViaSerialNumberVerification;

  String authenticatedOn(String date);

  String get followText;

  String get makeAnOffer;

  String get chatText;

  String get soldText;

  String get outOfStock;

  String get shippedText;

  String get cancelledText;

  String get conditionText;

  String get priceText;

  String get newOfferText;

  String get youReceivedAnOffer;

  String get acceptOffer;

  String get offerAmount;

  String get submitted;

  String get rejectOffer;

  String get buyerText;

  String hoursAgoText(String hours);

  String get offerDetailsText;

  String offersInProgressText(int count);

  String get buyNowText;

  String get offerRecommendationText;

  String get customOfferText;

  String get useRefashionTokensText;

  String get sendAnOfferText;

  String get soldByText;

  String get offerSentText;

  String get holdTightText;

  String get holdTightDescText;

  String get reallyIntoItText;

  String get reallyIntoItDescText;

  String get offersNotificationHintText;

  String get seeMyOffersText;

  String get viewByText;

  String get dateText;

  String get subjectText;

  String minReadText(int min);

  String get notificationText;

  String get updateText;

  String get messagesText;

  String get activeTodayText;

  String get youMadeAnOfferText;

  String get writeMessageHint;

  String get todayText;

  String get yesterdayText;

  String get bagText;

  String get yourBagIsEmpty;

  String get supportSustainableFashion;

  String get itemSelected;

  String get noItemSelectedSelectAtLeastOneItemToPlaceOrder;

  String get proceedToCheckout;

  String get moveFromBag;

  String get confirmMoveFromBag;

  String get moveToFavorite;

  String get movedToFavorite;

  String priceDetailsWithCount(int count);

  String get shippingText;

  String get tax;

  String get totalText;

  String get checkoutText;

  String get deliveryOptionText;

  String get selectADeliveryOptionText;

  String get noDeliveryOptionsAvailable;

  String get chooseDeliveryOption;

  String get applyShippingOptions;

  String get shippingApplied;

  String get shippingOptionsAppliedSuccessfully;

  String get selectShippingOptionForAllSellers;

  String get failedToApplyShippingOptions;

  String get addAShippingAddress;

  String get addAPaymentMethod;

  String get shippingAddress;

  String get billingAddress;

  String get payment;

  String get addNewAddress;

  String get placeOrder;

  String get pay;

  String get byPlacingYourOrderYouAgreeToOurBuyerTermsAndConditions;

  String get addressesText;

  String get myAddressesText;

  String get addAnAddressText;

  String get addressNameText;

  String get addressNameHintText;

  String get addressFormText;

  String get contactText;

  String get firstNameText;

  String get lastNameText;

  String get companyText;

  String get phoneCodeText;

  String get mobileNumberText;

  String get addressLocationText;

  String get countryNameText;

  String get addressText;

  String get cityText;

  String get provinceText;

  String get postcodeText;

  String get updateAddressText;

  String get addressUpdatedSuccessfully;

  String get addressAddedSuccessfully;

  String get yourAddressListIsEmpty;

  String get yourAddressListIsEmptyDesc;

  String get noCountriesAvailable;

  String get deleteAddress;

  String get confirmDeleteAddress;

  String get addressDeletedSuccessfully;

  String get noItemsFoundText;

  String get searchForAreaText;

  String get enterLocationManuallyText;

  String get doneText;

  String get useCurrentLocationText;

  String get search;

  String get selectDeliveryAddressText;

  String get deliverToText;

  String get confirmLocationText;

  String get movePinToChangeLocationText;

  String get noSuggestionsFoundText;

  String get noResultsFoundText;

  String get tryDifferentKeywordText;

  String get addAddressText;

  String get creditDebitCard;

  String get walletRTFTokens;

  String get payPal;

  String get creditCardDetails;

  String get cardNumber;

  String get nameOnCard;

  String get expiryDate;

  String get validThru;

  String get mmYyHint;

  String get cvv;

  String get invalidCardNumber;

  String get invalidExpiryDate;

  String get invalidCVV;

  String get cardExpired;

  String get errorFieldRequired;

  String get walletText;

  String get useWalletCreditsText;

  String get cashOnDelivery;

  String get paymentAttentionText;

  String get attentionText;

  String get orderConfirmed;

  String get thankYouForSupportingDescription;

  String get orderID;

  String get estimatedDelivery;

  String get totalCharged;

  String get continueShopping;

  String get trackOrder;

  String get track;

  String get status;

  String get arriving;

  String get shipped;

  String get orderPlaced;

  String get invalidPhoneNumber;

  String get pleaseEnterYourPhoneNumber;

  String get categoriesText;

  String allCategoryWithName(String name);

  String get sortByText;

  String get filterText;

  String get saveSearchText;

  String items(int count);

  String reviews(int count);

  String get filteredResultsText;

  String get applyText;

  String get promotionCode;

  String get enterPromotionCode;

  String get promoCodeApplied;

  String get invalidPromoCode;

  String get removeText;

  String get closeText;

  String get clearAllText;

  String get reFashionTokens;

  String get sellText;

  String get youHavntAddedAnythingToSellYet;

  String get addNewItem;

  String get draftText;

  String get deleteItem;

  String get areYouSureToDeleteItem;

  String get confirm;

  String get storePendingTitle;

  String get storePendingDesc;

  String get storeDeactivatedTitle;

  String get storeDeactivatedDesc;

  String get noSellerAccountTitle;

  String get noSellerAccountDesc;

  String get completeProfile;

  String get whoIsThisItemFor;

  String get genderText;

  String get selectBrandText;

  String get brandText;

  String get searchForBrand;

  String get cantFindYourBrand;

  String get listingAnItem;

  String get selectionComplete;

  String get details;

  String get titleCategoryCondition;

  String get photos;

  String get imageUploaded;

  String get description;

  String get describeWhatYoureSelling;

  String get address;

  String get yourProductLocation;

  String get addAddress;

  String get price;

  String get setAPriceForYourItem;

  String get optionalInfo;

  String get additionalInformationForYourItem;

  String get reviewAndPublish;

  String get productDetails;

  String get condition;

  String get selectCondition;

  String get color;

  String get selectColor;

  String get size;

  String get selectSize;

  String get material;

  String get materialHint;

  String get materialHelperText;

  String get saveAndContinue;

  String get addPhotos;

  String get uploadPhotosDescription;

  String get seeMore;

  String get photoPlaceholder;

  String get minPhotosRequired;

  String get photoTipsGuidelines;

  String get mainPhotos;

  String get mainPhotosDesc;

  String get labelCertificationPhotos;

  String get labelCertificationPhotosDesc;

  String get packagingPhotos;

  String get packagingPhotosDesc;

  String get beDetailed;

  String get beDetailedDesc;

  String get inspireTrust;

  String get inspireTrustDesc;

  String get rearrangePhotosInstructions;

  String get camera;

  String get gallery;

  String get addDescriptionAndSizeInfo;

  String get describeYourItem;

  String get addYourShippingAddress;

  String get selectALocation;

  String get searchForLocation;

  String get savedAddress;

  String get locationServicesDisabled;

  String get locationPermissionDenied;

  String get locationPermissionPermanentlyDenied;

  String get priceViewTitle;

  String get priceViewDesc;

  String get rft;

  String get euro;

  String get optionalDetails;

  String get vintage;

  String get thisIsAVintageItem;

  String get over15YearsOld;

  String get purchaseInfo;

  String get placeOfPurchase;

  String get placeOfPurchaseHint;

  String get year;

  String get yearHint;

  String purchasePriceHint(String symbol);

  String get uploadReceiptInvoice;

  String get uploadReceiptDesc;

  String get privacyInfo;

  String get packaging;

  String get cardOfCertificate;

  String get dustBag;

  String get originalBox;

  String get changeReceipt;

  String get reviewAndSubmit;

  String get reviewYourListingDesc;

  String get gender;

  String get category;

  String get brand;

  String get edit;

  String get additionalDetails;

  String get invoice;

  String get itemSubmitted;

  String get itemSubmittedDesc;

  String get shippingNotIncludedDesc;

  String get youAreMakingAnImpact;

  String get impactDescription;

  String get viewYourListing;

  String get viewText;

  String get myTokens;

  String get myImpact;

  String get myAchievements;

  String get achievements;

  String get co2Saved;

  String get waterSaved;

  String get landfillReduced;

  String get tokensText;

  String get last6Months;

  String get allToDate;

  String get earned;

  String get spent;

  String get monthlyTrend;

  String get recentTransaction;

  String get impact;

  String get sustainabilityImpact;

  String get co2SavedTitle;

  String get waterSavedTitle;

  String get landfillReducedTitle;

  String co2Equivalent(String value, String eq);

  String waterEquivalent(String value, String eq);

  String landfillEquivalent(String value, String eq);

  String get yourBadges;

  String get firstSale;

  String get firstSaleDesc;

  String get firstPurchase;

  String get firstPurchaseDesc;

  String get consistentSeller;

  String get consistentSellerDesc;

  String get superSeller;

  String get superSellerDesc;

  String get superBuyer;

  String get superBuyerDesc;

  String get vintageAmbassador;

  String get vintageAmbassadorDesc;

  String get personalImpact;

  String get personalImpactDesc;

  String get oneOfAKind;

  String get oneOfAKindDesc;

  String get refashionStar;

  String get refashionStarDesc;

  String get quickShipper;

  String get quickShipperDesc;

  String get levelText;

  String get seeHow;

  String toLevel(String percent, String level);

  String get achievementMotivation;

  String get levelUpTips;

  String get newcomer;

  String get newcomerDesc;

  String get gettingStarted;

  String get gettingStartedDesc;

  String get consciousContributor;

  String get consciousContributorDesc;

  String get impactMaker;

  String get impactMakerDesc;

  String get refashionChampion;

  String get refashionChampionDesc;

  String get reFashionBadges;

  String get myProfile;

  String get followers;

  String get following;

  String get buyingActivity;

  String get sellingActivity;

  String get purchased;

  String get received;

  String get returned;

  String get myProducts;

  String get chatWithUs;

  String get virtualAssistantWelcome;

  String get profileSettings;

  String get account;

  String get personalInfo;

  String get paymentInfo;

  String get others;

  String get ragionAndCurrency;

  String get privacy;

  String get help;

  String get manage;

  String get deleteAccount;

  String get logout;

  String get logoutConfirmation;

  String get loggedOutSuccessfully;

  String get no;

  String get yes;

  String get bio;

  String get female;

  String get male;

  String get other;

  String get refashionId;

  String get myCredentials;

  String get username;

  String get updateProfile;

  String get sellerDetails;

  String get sellerStatusPending;

  String get sellerStatusPendingDesc;

  String get companyName;

  String get storeName;

  String get vatNumber;

  String get taxOffice;

  String get sellerEmail;

  String get optional;

  String get paymentMethods;

  String get editCard;

  String get removeCard;

  String get saveChanges;

  String get rftWallet;

  String get removeCardConfirmation;

  String get cancel;

  String get connected;

  String get balance;

  String get walletId;

  String get payPalAccount;

  String get disconnectPayPal;

  String get disconnectPayPalConfirmation;

  String get unlink;

  String get connectNewAccount;

  String get pushNotifications;

  String get offers;

  String get favouriteOnYourListings;

  String get newFollowers;

  String get refashionNews;

  String get enableAll;

  String get language;

  String get currency;

  String get region;

  String get privacySetting;

  String get allowSearch;

  String get allowMessages;

  String get leavingSoSoon;

  String get deleteAccountInfo;

  String get deleteAccountConfirmation;

  String get searchInOrders;

  String get anytime;

  String get last30Days;

  String get lastYear;

  String get confirmed;

  String get inTransit;

  String get orderStatus;

  String get clear;

  String get apply;

  String shippedOn(String date);

  String arrivedOn(String date);

  String arrivingBy(String date);

  String onDate(String date);

  String get orderDetails;

  String get myActivity;

  String get changeDeliveryAddress;

  String get totalItemPrice;

  String get paidByWallet;

  String get updatesSentTo;

  String orderPlacedOn(String date);

  String byDate(String date);

  String get paymentInformation;

  String get mrp;

  String get itemTotal;

  String get discount;

  String get totalAmount;

  String get totalPaid;

  String get returnOrder;

  String get returnReasons;

  String get selectReason;

  String get noReasonsAvailable;

  String get toastReturnRequested;

  String get cancelOrder;

  String get orderDetailsNotFoundDesc;

  String get goBack;

  String get chooseRefundMode;

  String get refashionWallet;

  String refashionWalletRefundDesc(String amount);

  String get backToSource;

  String backToSourceRefundDesc(String amount);

  String get cancellationRequested;

  String get cancellationRequestedDesc;

  String itemIsCancelled(int count);

  String get refundDetails;

  String refundDetailsDesc(String amount);

  String get pleaseNote;

  String get pleaseNoteDesc;

  String get messageText;

  String get helpCenter;

  String get reFashionHelp;

  String get whatCanWeHelpYouWith;

  String get popularTopics;

  String get buyingInReFashion;

  String get sellingInReFashion;

  String get reFashionTokensHelp;

  String get reFashionAchievements;

  String get almostThere;

  String get completeProfileDesc;

  // Listing related
  String get titleAndSubtitleSection;

  String get titleAndSubtitleSectionDesc;

  String get descriptionSectionTitle;

  String get descriptionSectionSubtitle;

  String get generalSubtitle;

  String get titleLabel;

  String get titleHint;

  String get subtitleLabel;

  String get subtitleHint;

  String get optionalText;

  String get handleLabel;

  String get handleHint;

  String get handleTooltipText;

  String get descriptionLabel;

  String get descriptionHint;

  String get organizeTitle;

  String get organizeSubtitle;

  String get organizeDescription;

  String get classificationSubtitle;

  String get selectGenderText;

  String get selectCategoryText;

  String get variantsTitle;

  String get variantsSubtitle;

  String get variantsDescription;

  String get productWithVariantsText;

  String get defaultVariantDesc;

  String get productOptionsSubtitle;

  String get productOptionsDesc;

  String get addOptionButton;

  String get optionTitleLabel;

  String get optionTitleHint;

  String get optionValuesLabel;

  String get optionValuesHint;

  String get addMoreHint;

  String get productVariantsSubtitle;

  String get rankingDesc;

  String get selectVariantError;

  String get addOptionsToCreateVariantsTip;

  String get variantUncheckedTip;

  String get discountableLabel;

  String get discountableDesc;

  String get typeLabel;

  String get collectionLabel;

  String get selectTypeHint;

  String get selectCollectionHint;

  String get selectTagsHint;

  String get tagsLabel;

  String get skuLabel;

  String get priceEurLabel;

  String get sizeColorLabel;

  String get variantInventoryTitle;

  String get variantInventorySubtitle;

  String get addressLine;

  String get city;

  String get postalCode;

  String get countryCode;

  String get selectCountry;

  String get noVariantsSelectedHint;

  String get skuHint;

  String get pricePlaceholder;

  String get yourOrderListIsEmpty;

  String get orderListEmptyDescription;

  String get totalRewards;

  String get shippingAndReturns;

  String get shippingPolicy;

  String get returnPolicy;

  String postedText(String timeAgo);

  String reviewsText(int count);

  String get reportListingText;

  String get ecoImpactScore;

  String co2SavedValue(String pct);

  String get newProductionCo2;

  String get operationsCo2;

  String get savedCo2Label;

  String get netCo2;

  String get stageShares;

  String get transportTotal;

  String get dyeingFinishing;

  String get fibreProduction;

  String get baselineManufacturing;

  String get ecoImpactScoreNotAvailable;
}
