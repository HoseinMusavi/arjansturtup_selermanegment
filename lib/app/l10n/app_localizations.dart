import 'package:flutter/material.dart';

/// Lightweight, dependency-free localization layer.
///
/// Persian (`fa`) is the primary locale and drives the RTL layout direction;
/// English (`en`) is provided as a fallback. Keys live in a single map per
/// locale so a missing translation fails loudly during development instead of
/// silently rendering an identifier to the merchant.
///
/// Usage from widgets:
/// ```dart
/// Text(context.tr.appTitle)
/// ```
class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    final instance = Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
    return instance ?? AppLocalizations(const Locale('fa'));
  }

  /// Whether the active locale renders right-to-left.
  bool get isRtl => _rtlLocales.contains(locale.languageCode);

  /// The [TextDirection] matching the active locale.
  TextDirection get textDirection =>
      isRtl ? TextDirection.rtl : TextDirection.ltr;

  static const Set<String> _rtlLocales = {'fa', 'ar', 'he'};

  static const List<Locale> supportedLocales = [Locale('fa'), Locale('en')];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // --- Lookup ------------------------------------------------------------

  String? _lookup(String key) {
    final table = _values[locale.languageCode] ?? _values['fa']!;
    return table[key];
  }

  /// Returns the translated string for [key], throwing in debug builds when a
  /// key is unknown so gaps are caught immediately.
  String get(String key) {
    final value = _lookup(key);
    if (value == null) {
      assert(
        false,
        'Missing translation for key "$key" in locale "${locale.languageCode}".',
      );
      return key;
    }
    return value;
  }

  /// Translates [key] with positional [args] substituted for `{0}`, `{1}`, …
  String plural(String key, List<Object> args) {
    var value = get(key);
    for (var i = 0; i < args.length; i++) {
      value = value.replaceAll('{$i}', args[i].toString());
    }
    return value;
  }

  // --- Translated getters (typed surface for the UI) ----------------------

  String get appTitle => get('appTitle');
  String get login => get('login');
  String get loading => get('loading');
  String get retry => get('retry');
  String get confirm => get('confirm');
  String get cancel => get('cancel');
  String get save => get('save');
  String get delete => get('delete');
  String get edit => get('edit');
  String get search => get('search');
  String get emptyTitle => get('emptyTitle');
  String get emptyMessage => get('emptyMessage');
  String get errorTitle => get('errorTitle');
  String get errorMessage => get('errorMessage');
  String get offlineTitle => get('offlineTitle');
  String get offlineMessage => get('offlineMessage');
  String get sessionExpired => get('sessionExpired');
  String get unknownError => get('unknownError');

  // Navigation destinations
  String get navDashboard => get('navDashboard');
  String get navOrders => get('navOrders');
  String get navCatalog => get('navCatalog');
  String get navFinance => get('navFinance');

  String get navMore => get('navMore');
  String get navReviews => get('navReviews');
  String get navTeam => get('navTeam');
  String get navSettings => get('navSettings');

  // Dashboard
  String get dashboardGoodMorning => get('dashboardGoodMorning');
  String get storeStatus => get('storeStatus');
  String get storeOpen => get('storeOpen');
  String get storeClosed => get('storeClosed');
  String get currentBalance => get('currentBalance');
  String get todaysSales => get('todaysSales');
  String get recentOrders => get('recentOrders');
  String get pendingOrders => get('pendingOrders');
  String get cancelRequests => get('cancelRequests');
  String get salesChart => get('salesChart');
  String get topItems => get('topItems');
  String get viewAll => get('viewAll');
  String get newOrders => get('newOrders');
  String get newBookings => get('newBookings');
  String get noNewOrders => get('noNewOrders');

  // Orders
  String get orderReference => get('orderReference');
  String get orderCustomer => get('orderCustomer');
  String get orderItems => get('orderItems');
  String get orderTotal => get('orderTotal');
  String get orderStatus => get('orderStatus');
  String get orderPaymentMethod => get('orderPaymentMethod');
  String get orderDate => get('orderDate');
  String get orderDetails => get('orderDetails');
  String get orderHistory => get('orderHistory');
  String get updateStatus => get('updateStatus');
  String get statusPending => get('statusPending');
  String get statusAccepted => get('statusAccepted');
  String get statusPreparing => get('statusPreparing');
  String get statusReady => get('statusReady');
  String get statusDelayed => get('statusDelayed');
  String get statusCancelled => get('statusCancelled');
  String get statusDeclined => get('statusDeclined');
  String get statusPaid => get('statusPaid');
  String get statusFailed => get('statusFailed');
  String get statusSuccessful => get('statusSuccessful');
  String get searchOrders => get('searchOrders');
  String get filterOrders => get('filterOrders');
  String get statusSaved => get('statusSaved');
  String get cancelOrderConfirm => get('cancelOrderConfirm');

  // Catalog
  String get navProducts => get('navProducts');
  String get navCategories => get('navCategories');
  String get navSizes => get('navSizes');
  String get navAddons => get('navAddons');
  String get addProduct => get('addProduct');
  String get productName => get('productName');
  String get productDescription => get('productDescription');
  String get productPrice => get('productPrice');
  String get productCategory => get('productCategory');
  String get productImages => get('productImages');
  String get publishStatus => get('publishStatus');
  String get statusPublish => get('statusPublish');
  String get statusPendingReview => get('statusPendingReview');
  String get statusDraft => get('statusDraft');
  String get available => get('available');
  String get notAvailable => get('notAvailable');
  String get uploadImage => get('uploadImage');
  String get unsavedChangesTitle => get('unsavedChangesTitle');
  String get unsavedChangesMessage => get('unsavedChangesMessage');
  String get discard => get('discard');

  // Finance
  String get invoices => get('invoices');
  String get vouchers => get('vouchers');
  String get invoiceNumber => get('invoiceNumber');
  String get invoicePeriod => get('invoicePeriod');
  String get voucherName => get('voucherName');
  String get voucherType => get('voucherType');
  String get voucherAmount => get('voucherAmount');
  String get voucherExpiration => get('voucherExpiration');
  String get voucherTypeFixed => get('voucherTypeFixed');
  String get voucherTypePercentage => get('voucherTypePercentage');
  String get usedOnce => get('usedOnce');

  // Reviews
  String get reviewCustomer => get('reviewCustomer');
  String get reviewText => get('reviewText');
  String get reviewRating => get('reviewRating');
  String get reviewDate => get('reviewDate');

  // Team
  String get addUser => get('addUser');
  String get userFirstName => get('userFirstName');
  String get userLastName => get('userLastName');
  String get userEmail => get('userEmail');
  String get username => get('username');
  String get password => get('password');
  String get userPermissions => get('userPermissions');
  String get userStatusActive => get('userStatusActive');
  String get userStatusPending => get('userStatusPending');
  String get userStatusSuspended => get('userStatusSuspended');
  String get userStatusBlocked => get('userStatusBlocked');

  // Settings
  String get alertSettings => get('alertSettings');
  String get alertNotificationEnabled => get('alertNotificationEnabled');
  String get alertSoundEnabled => get('alertSoundEnabled');
  String get notifyEmail => get('notifyEmail');
  String get invoiceEmail => get('invoiceEmail');
  String get cancelOrderEmail => get('cancelOrderEmail');
  String get cancelOrderPhone => get('cancelOrderPhone');

  // Auth
  String get mobileNumber => get('mobileNumber');
  String get enterPassword => get('enterPassword');
  String get loginFailed => get('loginFailed');
  String get forgotPassword => get('forgotPassword');
  String get logout => get('logout');
  String get logoutConfirm => get('logoutConfirm');
  String get requiredField => get('requiredField');
  String get invalidMobile => get('invalidMobile');

  // Pagination
  String get loadMore => get('loadMore');
  String get loadMoreFailed => get('loadMoreFailed');
  String get refreshing => get('refreshing');
  String get pullToRefresh => get('pullToRefresh');
  String get recordsCount => get('recordsCount');

  // Upload
  String get uploadFailed => get('uploadFailed');
  String get uploadTooLarge => get('uploadTooLarge');
  String get removeImage => get('removeImage');
  String get replaceImage => get('replaceImage');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.any(
      (supported) => supported.languageCode == locale.languageCode,
    );
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

/// Convenience access to translated strings from any build context.
extension LocalizationsX on BuildContext {
  AppLocalizations get tr => AppLocalizations.of(this);
}

/// Translation tables. Persian is authoritative; English mirrors it.
const Map<String, Map<String, String>> _values = {
  'fa': {
    'appTitle': 'ارجان مرچنت',
    'login': 'ورود',
    'loading': 'در حال بارگذاری…',
    'retry': 'تلاش مجدد',
    'confirm': 'تأیید',
    'cancel': 'انصراف',
    'save': 'ذخیره',
    'delete': 'حذف',
    'edit': 'ویرایش',
    'search': 'جستجو',
    'emptyTitle': 'موردی وجود ندارد',
    'emptyMessage': 'هنوز رکوردی در این بخش ثبت نشده است.',
    'errorTitle': 'خطا',
    'errorMessage': 'عملیات ناموفق بود. دوباره تلاش کنید.',
    'offlineTitle': 'اتصال اینترنت برقرار نیست',
    'offlineMessage': 'لطفاً اتصال خود را بررسی و دوباره تلاش کنید.',
    'sessionExpired': 'نشست شما به پایان رسیده است',
    'unknownError': 'خطای ناشناخته',
    'navDashboard': 'داشبورد',
    'navOrders': 'سفارش‌ها',
    'navCatalog': 'کاتالوگ',
    'navFinance': 'مالی',
    'navMore': 'بیشتر',
    'navReviews': 'نظرات',
    'navTeam': 'تیم',
    'navSettings': 'تنظیمات',
    'dashboardGoodMorning': 'سلام، کسب‌وکار شما چطور است؟',
    'storeStatus': 'وضعیت فروشگاه',
    'storeOpen': 'باز',
    'storeClosed': 'بسته',
    'currentBalance': 'موجودی فعلی',
    'todaysSales': 'فروش امروز',
    'recentOrders': 'سفارش‌های اخیر',
    'pendingOrders': 'در انتظار',
    'cancelRequests': 'درخواست لغو',
    'salesChart': 'روند فروش',
    'topItems': 'پرفروش‌ترین کالاها',
    'viewAll': 'مشاهده همه',
    'newOrders': 'سفارش‌های جدید',
    'newBookings': 'رزروهای جدید',
    'noNewOrders': 'سفارش جدیدی وجود ندارد',
    'orderReference': 'کد سفارش',
    'orderCustomer': 'مشتری',
    'orderItems': 'اقلام',
    'orderTotal': 'مبلغ کل',
    'orderStatus': 'وضعیت',
    'orderPaymentMethod': 'روش پرداخت',
    'orderDate': 'تاریخ',
    'orderDetails': 'جزئیات سفارش',
    'orderHistory': 'تاریخچه سفارش',
    'updateStatus': 'به‌روزرسانی وضعیت',
    'statusPending': 'در انتظار',
    'statusAccepted': 'پذیرفته شد',
    'statusPreparing': 'در حال آماده‌سازی',
    'statusReady': 'آماده تحویل',
    'statusDelayed': 'ارسال شد',
    'statusCancelled': 'لغو توسط مشتری',
    'statusDeclined': 'رد شد',
    'statusPaid': 'پرداخت شده',
    'statusFailed': 'ناموفق',
    'statusSuccessful': 'تکمیل شده',
    'searchOrders': 'جستجوی سفارش…',
    'filterOrders': 'فیلتر سفارش‌ها',
    'statusSaved': 'وضعیت ذخیره شد',
    'cancelOrderConfirm':
        'آیا از لغو این سفارش مطمئن هستید؟ این عمل قابل بازگشت نیست.',
    'navProducts': 'محصولات',
    'navCategories': 'دسته‌بندی‌ها',
    'navSizes': 'سایزها',
    'navAddons': 'افزودنی‌ها',
    'addProduct': 'افزودن محصول',
    'productName': 'نام محصول',
    'productDescription': 'توضیحات',
    'productPrice': 'قیمت',
    'productCategory': 'دسته‌بندی',
    'productImages': 'تصاویر',
    'publishStatus': 'وضعیت انتشار',
    'statusPublish': 'منتشر شده',
    'statusPendingReview': 'در انتظار بررسی',
    'statusDraft': 'پیش‌نویس',
    'available': 'موجود',
    'notAvailable': 'ناموجود',
    'uploadImage': 'بارگذاری تصویر',
    'unsavedChangesTitle': 'تغییرات ذخیره نشده',
    'unsavedChangesMessage':
        'تغییراتی که انجام داده‌اید از بین می‌روند. ادامه می‌دهید؟',
    'discard': 'دورریز',
    'invoices': 'فاکتورها',
    'vouchers': 'کدهای تخفیف',
    'invoiceNumber': 'شماره فاکتور',
    'invoicePeriod': 'دوره',
    'voucherName': 'نام کد',
    'voucherType': 'نوع تخفیف',
    'voucherAmount': 'مقدار',
    'voucherExpiration': 'تاریخ انقضا',
    'voucherTypeFixed': 'مبلغ ثابت',
    'voucherTypePercentage': 'درصدی',
    'usedOnce': 'فقط یک‌بار استفاده',
    'reviewCustomer': 'مشتری',
    'reviewText': 'نظر',
    'reviewRating': 'امتیاز',
    'reviewDate': 'تاریخ',
    'addUser': 'افزودن کاربر',
    'userFirstName': 'نام',
    'userLastName': 'نام خانوادگی',
    'userEmail': 'ایمیل',
    'username': 'نام کاربری',
    'password': 'رمز عبور',
    'userPermissions': 'دسترسی‌ها',
    'userStatusActive': 'فعال',
    'userStatusPending': 'در انتظار تأیید',
    'userStatusSuspended': 'معلق',
    'userStatusBlocked': 'مسدود',
    'alertSettings': 'تنظیمات اعلان',
    'alertNotificationEnabled': 'فعال‌سازی اعلان‌ها',
    'alertSoundEnabled': 'پخش صدا برای سفارش جدید',
    'notifyEmail': 'ایمیل اعلان سفارش جدید',
    'invoiceEmail': 'ایمیل دریافت فاکتور',
    'cancelOrderEmail': 'ایمیل لغو سفارش',
    'cancelOrderPhone': 'شماره پیامک لغو سفارش',
    'mobileNumber': 'شماره موبایل',
    'enterPassword': 'رمز عبور',
    'loginFailed': 'ورود ناموفق بود',
    'forgotPassword': 'رمز عبور خود را فراموش کرده‌اید؟',
    'logout': 'خروج',
    'logoutConfirm': 'آیا از حساب کاربری خود خارج می‌شوید؟',
    'requiredField': 'این فیلد الزامی است',
    'invalidMobile': 'شماره موبایل معتبر نیست',
    'loadMore': 'بارگذاری موارد بیشتر',
    'loadMoreFailed': 'بارگذاری موارد بیشتر ناموفق بود',
    'refreshing': 'در حال به‌روزرسانی…',
    'pullToRefresh': 'برای به‌روزرسانی پایین بکشید',
    'recordsCount': '{0} مورد',
    'uploadFailed': 'بارگذاری ناموفق بود',
    'uploadTooLarge': 'حجم فایل بیش از حد مجاز است (حداکثر ۱۰ مگابایت)',
    'removeImage': 'حذف تصویر',
    'replaceImage': 'جایگزینی تصویر',
  },
  'en': {
    'appTitle': 'Arjan Merchant',
    'login': 'Sign in',
    'loading': 'Loading…',
    'retry': 'Retry',
    'confirm': 'Confirm',
    'cancel': 'Cancel',
    'save': 'Save',
    'delete': 'Delete',
    'edit': 'Edit',
    'search': 'Search',
    'emptyTitle': 'Nothing here yet',
    'emptyMessage': 'No records have been added to this section yet.',
    'errorTitle': 'Something went wrong',
    'errorMessage': 'The operation failed. Please try again.',
    'offlineTitle': 'No internet connection',
    'offlineMessage': 'Check your connection and try again.',
    'sessionExpired': 'Your session has expired',
    'unknownError': 'Unknown error',
    'navDashboard': 'Dashboard',
    'navOrders': 'Orders',
    'navCatalog': 'Catalog',
    'navFinance': 'Finance',
    'navMore': 'More',
    'navReviews': 'Reviews',
    'navTeam': 'Team',
    'navSettings': 'Settings',
    'dashboardGoodMorning': 'Hello, how is business today?',
    'storeStatus': 'Store status',
    'storeOpen': 'Open',
    'storeClosed': 'Closed',
    'currentBalance': 'Current balance',
    'todaysSales': 'Today’s sales',
    'recentOrders': 'Recent orders',
    'pendingOrders': 'Pending',
    'cancelRequests': 'Cancel requests',
    'salesChart': 'Sales trend',
    'topItems': 'Top items',
    'viewAll': 'View all',
    'newOrders': 'New orders',
    'newBookings': 'New bookings',
    'noNewOrders': 'No new orders',
    'orderReference': 'Reference',
    'orderCustomer': 'Customer',
    'orderItems': 'Items',
    'orderTotal': 'Total',
    'orderStatus': 'Status',
    'orderPaymentMethod': 'Payment',
    'orderDate': 'Date',
    'orderDetails': 'Order details',
    'orderHistory': 'Order history',
    'updateStatus': 'Update status',
    'statusPending': 'Pending',
    'statusAccepted': 'Accepted',
    'statusPreparing': 'Preparing',
    'statusReady': 'Ready',
    'statusDelayed': 'Dispatched',
    'statusCancelled': 'Cancelled by customer',
    'statusDeclined': 'Declined',
    'statusPaid': 'Paid',
    'statusFailed': 'Failed',
    'statusSuccessful': 'Completed',
    'searchOrders': 'Search orders…',
    'filterOrders': 'Filter orders',
    'statusSaved': 'Status saved',
    'cancelOrderConfirm': 'Cancel this order? This action cannot be undone.',
    'navProducts': 'Products',
    'navCategories': 'Categories',
    'navSizes': 'Sizes',
    'navAddons': 'Add-ons',
    'addProduct': 'Add product',
    'productName': 'Product name',
    'productDescription': 'Description',
    'productPrice': 'Price',
    'productCategory': 'Category',
    'productImages': 'Images',
    'publishStatus': 'Publish status',
    'statusPublish': 'Published',
    'statusPendingReview': 'Pending review',
    'statusDraft': 'Draft',
    'available': 'Available',
    'notAvailable': 'Not available',
    'uploadImage': 'Upload image',
    'unsavedChangesTitle': 'Unsaved changes',
    'unsavedChangesMessage': 'Your changes will be lost. Continue?',
    'discard': 'Discard',
    'invoices': 'Invoices',
    'vouchers': 'Vouchers',
    'invoiceNumber': 'Invoice no.',
    'invoicePeriod': 'Period',
    'voucherName': 'Voucher name',
    'voucherType': 'Type',
    'voucherAmount': 'Amount',
    'voucherExpiration': 'Expiration',
    'voucherTypeFixed': 'Fixed amount',
    'voucherTypePercentage': 'Percentage',
    'usedOnce': 'Use once only',
    'reviewCustomer': 'Customer',
    'reviewText': 'Review',
    'reviewRating': 'Rating',
    'reviewDate': 'Date',
    'addUser': 'Add user',
    'userFirstName': 'First name',
    'userLastName': 'Last name',
    'userEmail': 'Email',
    'username': 'Username',
    'password': 'Password',
    'userPermissions': 'Permissions',
    'userStatusActive': 'Active',
    'userStatusPending': 'Pending approval',
    'userStatusSuspended': 'Suspended',
    'userStatusBlocked': 'Blocked',
    'alertSettings': 'Alert settings',
    'alertNotificationEnabled': 'Enable notifications',
    'alertSoundEnabled': 'Play sound for new orders',
    'notifyEmail': 'New order notification email',
    'invoiceEmail': 'Invoice email',
    'cancelOrderEmail': 'Cancel order email',
    'cancelOrderPhone': 'Cancel order SMS number',
    'mobileNumber': 'Mobile number',
    'enterPassword': 'Password',
    'loginFailed': 'Sign in failed',
    'forgotPassword': 'Forgot your password?',
    'logout': 'Sign out',
    'logoutConfirm': 'Sign out of your account?',
    'requiredField': 'This field is required',
    'invalidMobile': 'Enter a valid mobile number',
    'loadMore': 'Load more',
    'loadMoreFailed': 'Failed to load more',
    'refreshing': 'Refreshing…',
    'pullToRefresh': 'Pull down to refresh',
    'recordsCount': '{0} items',
    'uploadFailed': 'Upload failed',
    'uploadTooLarge': 'File is too large (max 10 MB)',
    'removeImage': 'Remove image',
    'replaceImage': 'Replace image',
  },
};
