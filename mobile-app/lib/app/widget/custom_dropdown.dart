import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/constant/cached_image_view.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/widget/spin_kit_loader.dart';

/// A custom dropdown widget that matches the design shown in the image.
///
/// Features:
/// - Label at the top
/// - Selected value display with chevron icon
/// - Dropdown list with highlighted selected option
/// - Clean, minimalist styling with rounded corners
class CustomDropdown<T> extends StatefulWidget {
  /// The label text displayed above the dropdown
  final String label;

  /// The currently selected value
  final T? value;

  /// List of items to display in the dropdown
  final List<DropdownItem<T>> items;

  /// Callback when an item is selected
  final ValueChanged<T?>? onChanged;

  /// Optional hint text when no value is selected
  final String? hint;

  /// Whether the dropdown is enabled
  final bool enabled;

  /// Optional validator for form validation
  final FormFieldValidator<T>? validator;

  /// Optional error text
  final String? errorText;

  /// Custom height for dropdown items
  final double? itemHeight;

  /// Custom padding for the dropdown button
  final EdgeInsetsGeometry? padding;

  final TextStyle? labelStyle;

  final Color? activeLabelBgColor;

  final Color? inActiveLabelBgColor;

  final Color? dropdownIconColor;

  final TextStyle? dropDownTextStyle;

  final TextStyle? dropDownValueTextStyle;

  final bool isSearchable;
  final String? searchHint;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onLoadMore;
  final bool isLoadingMore;
  final bool isLoading;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.items,
    this.value,
    this.onChanged,
    this.hint,
    this.enabled = true,
    this.validator,
    this.errorText,
    this.itemHeight,
    this.padding,
    this.labelStyle,
    this.activeLabelBgColor,
    this.inActiveLabelBgColor,
    this.dropdownIconColor,
    this.dropDownTextStyle,
    this.dropDownValueTextStyle,
    this.isSearchable = false,
    this.searchHint,
    this.onSearchChanged,
    this.onLoadMore,
    this.isLoadingMore = false,
    this.isLoading = false,
  });

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final ValueNotifier<bool> _isOpenNotifier = ValueNotifier<bool>(false);
  final TextEditingController _searchController = TextEditingController();

  ScrollController? _scrollController;

  @override
  void didUpdateWidget(covariant CustomDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isOpenNotifier.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _overlayEntry?.markNeedsBuild();
      });
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    _isOpenNotifier.dispose();
    _scrollController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _removeOverlay() {
    if (_overlayEntry == null) return;

    if (widget.isSearchable && _searchController.text.isNotEmpty) {
      widget.onSearchChanged?.call('');
    }

    _isOpenNotifier.value = false;
    _overlayEntry?.remove();
    _overlayEntry = null;

    _scrollController?.dispose();
    _scrollController = null;
    _searchController.clear();
  }

  void _toggleDropdown() {
    if (!widget.enabled) return;

    hideKeyboard(context);
    if (_isOpenNotifier.value) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final paddingBottom = mediaQuery.padding.bottom;

    // Calculate content height logic
    final double itemHeight = widget.itemHeight ?? 40.0.h;
    final double listPadding = 8.0.h; // vertical padding
    final double searchFieldHeight = widget.isSearchable ? 50.0.h : 0;

    // If items are empty, we need small height to show 'No items'
    final double contentHeight =
        (widget.items.isEmpty
            ? 50.0.h
            : (widget.items.length * itemHeight) + listPadding) +
        searchFieldHeight;

    // Default max height
    final double maxDropdownHeight = 250.0.h;
    final neededHeight = contentHeight > maxDropdownHeight
        ? maxDropdownHeight
        : contentHeight;

    // Available space
    final spaceBelow = screenHeight - offset.dy - size.height - paddingBottom;
    final spaceAbove = offset.dy - mediaQuery.padding.top;

    bool openUpwards = false;

    if (widget.items.isNotEmpty || widget.isSearchable) {
      if (spaceBelow < neededHeight && spaceAbove > spaceBelow) {
        openUpwards = true;
      }
    }

    // Calculate final height constraint
    final double dropdownHeight = openUpwards
        ? (spaceAbove < neededHeight ? spaceAbove - 10 : neededHeight)
        : (spaceBelow < neededHeight ? spaceBelow - 10 : neededHeight);

    final yOffset = openUpwards ? -(dropdownHeight + 4.0) : size.height + 4.0;

    final selectedIndex = widget.items.indexWhere(
      (item) => item.value == widget.value,
    );
    double initialScrollOffset = 0;
    if (selectedIndex > 0) {
      initialScrollOffset = selectedIndex * itemHeight;
    }

    _scrollController = ScrollController(
      initialScrollOffset: initialScrollOffset,
    );

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () => _removeOverlay(),
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned.fill(child: Container(color: Colors.transparent)),
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, yOffset),
              child: GestureDetector(
                onTap: () {},
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(8.0.r),
                  color: ColorHelper.white,
                  child: Container(
                    width: size.width,
                    constraints: BoxConstraints(maxHeight: dropdownHeight),
                    decoration: BoxDecoration(
                      color: ColorHelper.white,
                      borderRadius: BorderRadius.circular(8.0.r),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.isSearchable)
                          Padding(
                            padding: EdgeInsets.all(8.r),
                            child: TextFormField(
                              controller: _searchController,
                              onChanged: widget.onSearchChanged,
                              style: TextStyleHelper.urMedium500().copyWith(
                                fontSize: 14.sp,
                              ),
                              decoration: InputDecoration(
                                hintText:
                                    widget.searchHint ?? locale.value.search,
                                hintStyle: TextStyleHelper.urRegular400()
                                    .copyWith(
                                      color: ColorHelper.hintColor,
                                      fontSize: 14.sp,
                                    ),
                                prefixIcon: CachedImageView(
                                  imagePath: ImageHelper.icSearch,
                                  size: 16.sp,
                                ).paddingAll(16.sp),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 8.h,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: const BorderSide(
                                    color: ColorHelper.borderColor,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: const BorderSide(
                                    color: ColorHelper.borderColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: const BorderSide(
                                    color: ColorHelper.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        Expanded(
                          child: widget.isLoading && widget.items.isEmpty
                              ? const SpinKitCircle(
                                  color: ColorHelper.primary,
                                  size: 20,
                                )
                              : widget.items.isEmpty
                              ? Center(
                                  child: Text(
                                    locale.value.noItemsFoundText,
                                    style: TextStyleHelper.dmRegular400()
                                        .copyWith(
                                          color: ColorHelper.hintColor,
                                          fontSize: 12.sp,
                                        ),
                                  ),
                                )
                              : ListView.builder(
                                  controller: _scrollController,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 4.0.h,
                                  ),
                                  itemExtent: itemHeight,
                                  itemCount: widget.items.length,
                                  itemBuilder: (context, index) {
                                    final item = widget.items[index];
                                    final isSelected =
                                        widget.value == item.value;

                                    return InkWell(
                                      onTap: () {
                                        widget.onChanged?.call(item.value);
                                        _removeOverlay();
                                      },
                                      child: Container(
                                        height: widget.itemHeight ?? 40.0.h,
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 8.0.w,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.0.w,
                                          vertical: 4.0.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? ColorHelper.primary.withValues(
                                                  alpha: 0.1,
                                                )
                                              : ColorHelper.transparent,
                                          borderRadius: BorderRadius.circular(
                                            8.0.r,
                                          ),
                                        ),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            item.label,
                                            style:
                                                widget.dropDownValueTextStyle
                                                    ?.copyWith(
                                                      color: isSelected
                                                          ? ColorHelper
                                                                .headingColor
                                                          : ColorHelper
                                                                .subHeadingColor,
                                                    ) ??
                                                TextStyleHelper.dmMedium500()
                                                    .copyWith(
                                                      color: isSelected
                                                          ? ColorHelper.primary
                                                          : ColorHelper
                                                                .headingColor,
                                                      fontSize: 12.0.sp,
                                                      fontWeight: isSelected
                                                          ? FontWeight.w600
                                                          : FontWeight.w500,
                                                    ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _isOpenNotifier.value = true;
  }

  String _getDisplayText() {
    if (widget.value == null) {
      return widget.hint ?? 'Select an option';
    }

    // Try to find the item in the current list
    final matches = widget.items.where((item) => item.value == widget.value);

    if (matches.isNotEmpty) {
      return matches.first.label;
    }

    return widget.hint ?? 'Select an option';
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          if (widget.label.isNotEmpty) ...[
            Text(
              widget.label,
              style:
                  widget.labelStyle ??
                  TextStyleHelper.urMedium500().copyWith(
                    fontSize: 16.sp,
                    color: ColorHelper.headingColor,
                  ),
            ),
            SizedBox(height: 4.0.h),
          ],
          // Dropdown Button
          InkWell(
            onTap: _toggleDropdown,
            borderRadius: BorderRadius.circular(8.0.r),
            child: InputDecorator(
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: widget.enabled
                    ? widget.activeLabelBgColor ?? ColorHelper.transparent
                    : widget.inActiveLabelBgColor ?? ColorHelper.lightGrey,
                contentPadding:
                    widget.padding ??
                    EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(
                    color: widget.errorText != null
                        ? ColorHelper.error
                        : ColorHelper.borderColor,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(
                    color: widget.errorText != null
                        ? ColorHelper.error
                        : ColorHelper.borderColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(
                    color: widget.errorText != null
                        ? ColorHelper.error
                        : ColorHelper.primary,
                  ),
                ),
                errorText: widget.errorText,
                errorStyle: TextStyleHelper.dmMedium500().copyWith(
                  color: ColorHelper.error,
                  fontSize: 12.0.sp,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _getDisplayText(),
                      style:
                          widget.dropDownTextStyle ??
                          TextStyleHelper.urRegular400().copyWith(
                            color: widget.value == null
                                ? ColorHelper.hintColor
                                : ColorHelper.headingColor,
                            fontSize: 14.sp,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: _isOpenNotifier,
                    builder: (context, isOpen, child) {
                      return Icon(
                        isOpen
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color:
                            widget.dropdownIconColor ?? ColorHelper.iconColor,
                        size: 20.0.sp,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Represents an item in the dropdown
class DropdownItem<T> {
  /// The value of the item
  final T value;

  /// The label to display
  final String label;

  const DropdownItem({required this.value, required this.label});
}
