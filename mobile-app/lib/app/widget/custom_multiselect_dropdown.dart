import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:refashion/app/locale/app_localizations.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';

import 'custom_dropdown.dart';

class CustomMultiSelectDropdown<T> extends StatefulWidget {
  final String label;
  final List<T> selectedValues;
  final List<DropdownItem<T>> items;
  final ValueChanged<List<T>> onChanged;
  final String? hint;
  final bool enabled;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry? padding;

  const CustomMultiSelectDropdown({
    super.key,
    required this.label,
    required this.selectedValues,
    required this.items,
    required this.onChanged,
    this.hint,
    this.enabled = true,
    this.labelStyle,
    this.padding,
  });

  @override
  State<CustomMultiSelectDropdown<T>> createState() =>
      _CustomMultiSelectDropdownState<T>();
}

class _CustomMultiSelectDropdownState<T>
    extends State<CustomMultiSelectDropdown<T>> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final ValueNotifier<bool> _isOpenNotifier = ValueNotifier<bool>(false);

  @override
  void didUpdateWidget(covariant CustomMultiSelectDropdown<T> oldWidget) {
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
    super.dispose();
  }

  void _removeOverlay() {
    if (_overlayEntry == null) return;
    _isOpenNotifier.value = false;
    _overlayEntry?.remove();
    _overlayEntry = null;
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

    final double itemHeight = 44.0.h;
    final double listPadding = 12.0.h;
    final double contentHeight = (widget.items.isEmpty
        ? 50.0.h
        : (widget.items.length * itemHeight) + listPadding);

    final double maxDropdownHeight = 250.0.h;
    final neededHeight = contentHeight > maxDropdownHeight
        ? maxDropdownHeight
        : contentHeight;

    final spaceBelow = screenHeight - offset.dy - size.height - paddingBottom;
    final spaceAbove = offset.dy - mediaQuery.padding.top;

    bool openUpwards = spaceBelow < neededHeight && spaceAbove > spaceBelow;

    final double dropdownHeight = openUpwards
        ? (spaceAbove < neededHeight ? spaceAbove - 10 : neededHeight)
        : (spaceBelow < neededHeight ? spaceBelow - 10 : neededHeight);

    final yOffset = openUpwards ? -(dropdownHeight + 4.0) : size.height + 4.0;

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _removeOverlay,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned.fill(child: Container(color: Colors.transparent)),
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, yOffset),
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
                    border: Border.all(color: ColorHelper.borderColor),
                  ),
                  child: widget.items.isEmpty
                      ? Center(
                          child: Text(
                            locale.value.noItemsFoundText,
                            style: TextStyleHelper.dmRegular400().copyWith(
                              color: ColorHelper.hintColor,
                              fontSize: 12.sp,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 4.0.h),
                          itemCount: widget.items.length,
                          itemBuilder: (context, index) {
                            final item = widget.items[index];
                            final isSelected = widget.selectedValues.contains(
                              item.value,
                            );

                            return InkWell(
                              onTap: () {
                                final List<T> newValues = List.from(
                                  widget.selectedValues,
                                );
                                if (isSelected) {
                                  newValues.remove(item.value);
                                } else {
                                  newValues.add(item.value);
                                }
                                widget.onChanged(newValues);
                                _overlayEntry?.markNeedsBuild();
                              },
                              child: Container(
                                height: itemHeight,
                                margin: EdgeInsets.symmetric(
                                  horizontal: 8.0.w,
                                ).copyWith(bottom: 4.0.h),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.0.w,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? ColorHelper.primary.withValues(
                                          alpha: 0.1,
                                        )
                                      : ColorHelper.transparent,
                                  borderRadius: BorderRadius.circular(8.0.r),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.label,
                                        style: TextStyleHelper.dmMedium500()
                                            .copyWith(
                                              color: isSelected
                                                  ? ColorHelper.primary
                                                  : ColorHelper.headingColor,
                                              fontSize: 14.sp,
                                            ),
                                      ),
                                    ),
                                    if (isSelected)
                                      Icon(
                                        Icons.check,
                                        color: ColorHelper.primary,
                                        size: 18.sp,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
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

  @override
  Widget build(BuildContext context) {
    String displayText = widget.selectedValues.isEmpty
        ? widget.hint ?? 'Select options'
        : widget.items
              .where((item) => widget.selectedValues.contains(item.value))
              .map((e) => e.label)
              .join(', ');

    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          InkWell(
            onTap: _toggleDropdown,
            borderRadius: BorderRadius.circular(8.0.r),
            child: InputDecorator(
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: widget.enabled
                    ? ColorHelper.transparent
                    : ColorHelper.lightGrey,
                contentPadding:
                    widget.padding ??
                    EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 12.0.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: ColorHelper.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: ColorHelper.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: ColorHelper.primary),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        displayText,
                        style: TextStyleHelper.urRegular400().copyWith(
                          color: widget.selectedValues.isEmpty
                              ? ColorHelper.hintColor
                              : ColorHelper.headingColor,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: _isOpenNotifier,
                    builder: (context, isOpen, child) {
                      return Icon(
                        isOpen
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: ColorHelper.iconColor,
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
