import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'anim_nav/animated_nav_tiles.dart';
import 'model/bar_items.dart';
import 'model/bottom_bar_option.dart';
import 'model/options.dart';
import 'utils/enums.dart';
import 'shapes/bar_cliper.dart';
import 'shapes/convex_shape.dart';
import 'utils/constant.dart';

///[StylishBottomBar] class to implement beautiful bottom bar widget
///
///```dart
///
/// StylishBottomBar(
///   items: [
///     BottomBarItem(
///       icon: Icon(
///               Icons.home,
///         ),
///       selectedColor: Colors.deepPurple,
///       backgroundColor: Colors.amber,
///       title: Text('Home')),
///     BottomBarItem(
///       icon: Icon(
///               Icons.add_circle_outline,
///         ),
///       selectedColor: Colors.green,
///       backgroundColor: Colors.amber,
///       title: Text('Add')),
///     BottomBarItem(
///       icon: Icon(
///               Icons.person,
///         ),
///       backgroundColor: Colors.amber,
///       selectedColor: Colors.pinkAccent,
///       title: Text('Profile')),
///    ],
///    option: AnimatedBarOptions(
///        barAnimation: BarAnimation.fade,
///        opacity: 0.8,
///    ),
///    onTap: (index) {
///        setState(() {
///            selected = index;
///        });
///    },
///
///  );
///
///```
class StylishBottomBar extends StatefulWidget {
  StylishBottomBar({
    super.key,
    required this.items,
    this.backgroundColor,
    this.elevation = 8.0,
    this.currentIndex = 0,
    this.onTap,
    this.borderRadius,
    this.fabLocation,
    this.hasNotch = false,
    required this.option,
    this.gradient,
    this.notchStyle = NotchStyle.themeDefault,
    this.fabLabel,
    this.fabLabelColor,
    this.fabSize,
    this.fabChild,
  }) : assert(
         items.length >= 2,
         '\n\nStylish Bottom Navigation must have 2 or more items',
       ),
       assert(
         items.every((BottomBarItem item) => item.title != null) == true,
         '\n\nEvery item must have a non-null title',
       ),
       assert(
         (currentIndex >= items.length) == false,
         '\n\nCurrent index is out of bond. Provided: $currentIndex  Bond: 0 to ${items.length - 1}',
       ),
       assert(
         (currentIndex < 0) == false,
         '\n\nCurrent index is out of bond. Provided: $currentIndex  Bond: 0 to ${items.length - 1}',
       );

  ///Add navigation bar items
  ///[BottomBarItem]
  ///
  ///You can use `BottomBarItem` class to add navigation bar items
  final List<BottomBarItem> items;

  ///Change animated navigation bar background color
  final Color? backgroundColor;

  ///Add elevation to bottom navigation bar
  ///
  ///Default value is 8.0
  final double elevation;

  ///Used to change the selected item index
  ///
  /// Default value is 0
  final int currentIndex;

  ///Add notch effect to floating action button
  ///
  ///to make floating action button notch transparent set extendBody to true in scaffold
  ///
  ///```dart
  ///  return Scaffold(
  ///     extendBody: true
  ///
  ///   ...
  ///   );
  ///```
  final bool hasNotch;

  ///Function to return current selected item index
  ///
  ///```dart
  /// onTap: (index){
  ///
  /// },
  ///
  ///```
  final ValueChanged<int>? onTap;

  ///Change navigation bar border radius
  final BorderRadius? borderRadius;

  ///Adjust navigation items according to the fab location
  ///
  ///You can change Fab Location [StylishBarFabLocation.center]
  ///
  ///and [StylishBarFabLocation.end]
  final StylishBarFabLocation? fabLocation;

  /// Customize bottom bar items style and other properties
  ///
  /// You can use [AnimatedBarOptions] to change the properties.
  final BottomBarOption option;

  /// The gradient property defines a gradient color pattern for the widget.
  /// The gradient can be used to add a colorful background or add gradient colors to the widget.
  /// The gradient is defined using the [Gradient] class, which provides various options to specify the gradient colors and direction.
  /// Example usage:
  /// ```dart
  /// final gradient = LinearGradient(
  ///   colors: [Colors.red, Colors.yellow],
  ///   begin: Alignment.topLeft,
  ///   end: Alignment.bottomRight,
  /// );
  /// ```
  final Gradient? gradient;

  /// Specify the notch style
  ///
  /// [NotchStyle.circle]
  ///
  /// [NotchStyle.square] * Similar to material3
  ///
  /// [NotchStyle.themeDefault] * Depends on the `Theme.of(context).useMaterial3`
  final NotchStyle notchStyle;

  /// Label text to display below the FAB button when fabLocation is center
  ///
  /// This label will be aligned with other bottom bar item labels
  final String? fabLabel;

  /// Color for the FAB label text
  ///
  /// Defaults to grey if not specified
  final Color? fabLabelColor;

  /// Size of the FAB button when fabLocation is center
  ///
  /// Defaults to 56.0
  final double? fabSize;

  /// Custom widget to display as FAB content
  ///
  /// If not provided, the middle item's icon will be used
  final Widget? fabChild;

  @override
  State<StylishBottomBar> createState() => _StylishBottomBarState();
}

class _StylishBottomBarState extends State<StylishBottomBar>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers = <AnimationController>[];
  late List<CurvedAnimation> _animations;
  Color? _backgroundColor;

  ValueListenable<ScaffoldGeometry>? _geometryListenable;
  Animatable<double>? _flexTween;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _geometryListenable = Scaffold.geometryOf(context);
    _flexTween = widget.hasNotch
        ? Tween<double>(begin: 1.0, end: 1.3)
        : Tween<double>(begin: 1.15, end: 1.75);
  }

  void _state() {
    for (AnimationController controller in _controllers) {
      controller.dispose();
    }

    _controllers = List<AnimationController>.generate(widget.items.length, (
      int index,
    ) {
      return AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      );
    });
    _animations = List<CurvedAnimation>.generate(widget.items.length, (
      int index,
    ) {
      return CurvedAnimation(
        parent: _controllers[index],
        curve: Curves.fastOutSlowIn,
        reverseCurve: Curves.fastOutSlowIn.flipped,
      );
    });
    _controllers[widget.currentIndex].value = 1.0;
    _backgroundColor = widget.items[widget.currentIndex].backgroundColor;
  }

  @override
  void initState() {
    super.initState();
    _state();
  }

  @override
  void dispose() {
    ///Dispose controllers
    for (AnimationController controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  double _evaluateFlex(Animation<double> animation) =>
      _flexTween!.evaluate(animation);

  @override
  void didUpdateWidget(StylishBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.items.length != oldWidget.items.length) {
      _state();
      return;
    }

    if (widget.currentIndex != oldWidget.currentIndex) {
      _controllers[oldWidget.currentIndex].reverse();
      _controllers[widget.currentIndex].forward();
    } else {
      if (_backgroundColor !=
          widget.items[widget.currentIndex].backgroundColor) {
        _backgroundColor = widget.items[widget.currentIndex].backgroundColor;
      }
    }
  }

  bool getStyle() {
    return widget.notchStyle == NotchStyle.themeDefault
        ? Theme.of(context).useMaterial3
        : widget.notchStyle == NotchStyle.square;
  }

  @override
  Widget build(BuildContext context) {
    double additionalBottomPadding = 0;
    late List<Widget> listWidget;

    final mediaQuery = MediaQuery.of(context);

    // Only support AnimatedBarOptions with IconStyle.Default
    final AnimatedBarOptions options = widget.option as AnimatedBarOptions;
    additionalBottomPadding =
        math.max(mediaQuery.padding.bottom - bottomMargin, 0.0) + 2;
    listWidget = _animatedBarChilds();

    bool isUsingMaterial3 = getStyle();

    // Calculate FAB position for center FAB
    final double fabSize = widget.fabSize ?? 56.0;
    final bool hasCenterFAB =
        widget.fabLocation == StylishBarFabLocation.center &&
        widget.hasNotch &&
        _middleIndex != null;

    Widget bottomBar = LayoutBuilder(
      builder: (context, constraints) {
        // Calculate FAB position (centered horizontally)
        // The FAB is positioned above the bar, so we calculate its position
        // relative to the bar's coordinate system
        Rect? customFabRect;
        if (hasCenterFAB) {
          final double barWidth = constraints.maxWidth;
          final double fabLeft = (barWidth - fabSize) / 2;
          // FAB is positioned above the bar, with its center aligned to the bar's top edge
          // The clipper expects the FAB rect relative to the bar's coordinate system
          // Since FAB extends above the bar, we use negative top value
          final double fabTop = -(fabSize / 2);
          customFabRect = Rect.fromLTWH(fabLeft, fabTop, fabSize, fabSize);
        }

        // Determine the notch shape based on style
        final NotchedShape shape = widget.notchStyle == NotchStyle.convex
            ? const ConvexNotchedRectangle(radius: 0)
            : isUsingMaterial3
            ? const AutomaticNotchedShape(
                RoundedRectangleBorder(),
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
              )
            : const CircularNotchedRectangle();

        return widget.hasNotch
            ? PhysicalShape(
                elevation: widget.elevation,
                color: widget.backgroundColor ?? Colors.white,
                clipper: BarClipper(
                  shape: shape,
                  geometry: _geometryListenable!,
                  notchMargin: isUsingMaterial3 ? 2.sp : 4.sp,
                  customFabRect: customFabRect,
                ),
                child: ClipPath(
                  clipper: BarClipper(
                    shape: shape,
                    geometry: _geometryListenable!,
                    notchMargin: isUsingMaterial3 ? 2.sp : 4.sp,
                    customFabRect: customFabRect,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: widget.borderRadius,
                      gradient: widget.gradient,
                      color: widget.backgroundColor ?? Colors.white,
                    ),
                    child: _innerWidget(
                      context,
                      additionalBottomPadding,
                      widget.fabLocation,
                      listWidget,
                      options.barAnimation,
                    ),
                  ),
                ),
              )
            : Material(
                elevation: widget.elevation,
                borderRadius: widget.borderRadius,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: widget.borderRadius,
                    gradient: widget.gradient,
                    color: widget.backgroundColor ?? Colors.white,
                  ),
                  child: _innerWidget(
                    context,
                    additionalBottomPadding + 2,
                    widget.fabLocation,
                    listWidget,
                    options.barAnimation,
                  ),
                ),
              );
      },
    );

    // Build FAB widget if fabLocation is center
    final Widget? centerFAB = widget.fabLocation == StylishBarFabLocation.center
        ? _buildCenterFAB()
        : null;

    // If FAB exists, wrap in Stack (similar to Style13BottomNavBar)
    if (centerFAB != null) {
      return Semantics(
        explicitChildNodes: true,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            // Bottom bar with extra top padding for FAB
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: (widget.fabSize ?? 56.0) / 2 - 8),
                bottomBar,
              ],
            ),
            // FAB positioned above the bar with text below it
            Positioned(top: 0, left: 0, right: 0, child: centerFAB),
            if (widget.fabLabel != null)
              Positioned(
                bottom: 14,
                left: 0,
                right: 0,
                child: DefaultTextStyle.merge(
                  style: TextStyle(
                    fontSize: 12.0.sp,
                    fontWeight: FontWeight.w600,
                    color: widget.fabLabelColor ?? Colors.grey,
                  ),
                  child: Text(widget.fabLabel!, textAlign: TextAlign.center),
                ),
              ),
          ],
        ),
      );
    }

    // Add FAB label if provided (for backward compatibility)
    if (widget.fabLabel != null &&
        widget.fabLocation == StylishBarFabLocation.center) {
      return Semantics(
        explicitChildNodes: true,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            bottomBar,
            Positioned(
              bottom: 14,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: DefaultTextStyle.merge(
                  style: TextStyle(
                    fontSize: 12.0.sp,
                    fontWeight: FontWeight.w600,
                    color: widget.fabLabelColor ?? Colors.grey,
                  ),
                  child: Text(widget.fabLabel!, textAlign: TextAlign.center),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Semantics(explicitChildNodes: true, child: bottomBar);
  }

  /// Calculate the middle index when fabLocation is center
  int? get _middleIndex {
    if (widget.fabLocation == StylishBarFabLocation.center &&
        widget.items.isNotEmpty) {
      return (widget.items.length / 2).floor();
    }
    return null;
  }

  List<Widget> _animatedBarChilds() {
    final List<Widget> list = [];
    final MaterialLocalizations localizations = MaterialLocalizations.of(
      context,
    );

    final AnimatedBarOptions options = widget.option as AnimatedBarOptions;
    final int? midIndex = _middleIndex;

    // Build list - for middle item when fabLocation is center:
    // - If fabLabel is provided, skip it (FAB icon only, text from fabLabel)
    // - If fabLabel is null, show title in bottom bar (FAB icon + title aligned with other items)
    for (int i = 0; i < widget.items.length; i++) {
      // Skip the middle item if fabLocation is center and fabLabel is provided
      if (midIndex != null && i == midIndex && widget.fabLabel != null) {
        continue; // Skip this item - it becomes the FAB with fabLabel text
      }

      // For middle item when fabLabel is null, show only title (icon becomes FAB)
      if (midIndex != null && i == midIndex && widget.fabLabel == null) {
        final BottomBarItem middleItem = widget.items[i];
        final bool isSelected = widget.currentIndex == i;

        // Show only the title widget aligned with other items (matching AnimatedNavigationTiles structure)
        list.add(
          Expanded(
            child: Semantics(
              container: true,
              header: true,
              selected: isSelected,
              child: Padding(
                padding: options.padding ?? EdgeInsets.zero,
                child: InkWell(
                  onTap: () {
                    if (widget.onTap != null) widget.onTap!(i);
                  },
                  splashColor: options.inkEffect
                      ? options.inkColor
                      : Colors.transparent,
                  highlightColor: Colors.transparent,
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(52),
                    left: Radius.circular(52),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Empty space for icon (FAB will be above)
                      SizedBox(height: options.iconSize.sp),
                      if (middleItem.title != null)
                        DefaultTextStyle.merge(
                          style: TextStyle(
                            fontSize: 12.0.sp,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? middleItem.selectedColor
                                : middleItem.unSelectedColor,
                          ),
                          child: middleItem.title!,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        continue;
      }

      list.add(
        AnimatedNavigationTiles(
          widget.items[i],
          options.iconSize,
          padding: options.padding,
          inkEffect: options.inkEffect,
          inkColor: options.inkColor,
          selected: widget.currentIndex == i,
          opacity: options.opacity!,
          animation: _animations[i],
          barAnimation: options.barAnimation,
          onTap: () {
            if (widget.onTap != null) widget.onTap!(i);
          },
          flex: _evaluateFlex(_animations[i]),
          indexLabel: localizations.tabLabel(
            tabIndex: i + 1,
            tabCount: widget.items.length,
          ),
        ),
      );
    }

    insertSpace(list);

    return list;
  }

  List<Widget> insertSpace(List<Widget> list) {
    if (widget.fabLocation == StylishBarFabLocation.center) {
      final int? midIndex = _middleIndex;
      if (midIndex == null) return list;

      // Only insert placeholder if fabLabel is provided (middle item is skipped)
      // If fabLabel is null, the middle item's title is already in the list, so no placeholder needed
      if (widget.fabLabel != null) {
        // For equal spacing, we need to account for the FAB position
        // Insert an invisible placeholder with FAB size at the middle position
        // This ensures equal spacing: [Item0] [Space] [Item1] [FAB-placeholder] [Item3] [Space] [Item4]
        final double fabSize = widget.fabSize ?? 56.0;
        list.insert(midIndex, SizedBox(width: fabSize));
      }
    }
    return list;
  }

  /// Build the FAB widget when fabLocation is center
  ///
  /// **Logic behind FAB working as bottom bar:**
  /// 1. When `fabLocation == StylishBarFabLocation.center`, the middle item
  ///    (at index `floor(items.length / 2)`) becomes a floating button
  /// 2. The middle item is excluded from the normal bottom bar layout
  ///    (replaced with empty space)
  /// 3. The FAB is positioned above the bar using a Stack
  /// 4. When tapped, the FAB triggers `onTap(midIndex)` just like other items
  /// 5. The FAB's appearance changes based on selection state (selected/unselected)
  ///
  /// This is similar to Style13BottomNavBar's approach where the middle item
  /// is displayed as a floating button above the navigation bar.
  Widget? _buildCenterFAB() {
    final int? midIndex = _middleIndex;
    if (midIndex == null || midIndex >= widget.items.length) {
      return null;
    }

    final BottomBarItem middleItem = widget.items[midIndex];
    final bool isSelected = widget.currentIndex == midIndex;
    final double fabSize = widget.fabSize ?? 56.0;

    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!(midIndex);
        }
      },
      child: Container(
        width: fabSize,
        height: fabSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? (middleItem.backgroundColor ?? middleItem.selectedColor)
              : (middleItem.unSelectedColor.withValues(alpha: 0.1)),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color:
                        (middleItem.backgroundColor ?? middleItem.selectedColor)
                            .withValues(alpha: 0.4),
                    spreadRadius: 0,
                    blurRadius: 6,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Center(
          child:
              widget.fabChild ??
              IconTheme(
                data: IconThemeData(
                  size: 24.0,
                  color: isSelected
                      ? middleItem.selectedColor
                      : middleItem.unSelectedColor,
                ),
                child: isSelected
                    ? (middleItem.selectedIcon ?? middleItem.icon)
                    : middleItem.icon,
              ),
        ),
      ),
    );
  }

  Widget _innerWidget(
    context,
    double additionalBottomPadding,
    fabLocation,
    List<Widget> childs, [
    BarAnimation? barAnimation,
  ]) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 52 + additionalBottomPadding),
        child: Material(
          type: MaterialType.transparency,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: additionalBottomPadding,
              right: fabLocation == StylishBarFabLocation.end ? 72 : 0,
            ),
            child: MediaQuery.removePadding(
              context: context,
              removeBottom: true,
              child: DefaultTextStyle.merge(
                overflow: TextOverflow.ellipsis,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: childs,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
