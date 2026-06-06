import 'package:flutter/material.dart';
import '../model/bar_items.dart';
import '../utils/constant.dart';
import '../utils/enums.dart';

class AnimatedNavigationTiles extends StatelessWidget {
  const AnimatedNavigationTiles(
    this.items,
    this.iconSize, {
    super.key,
    this.padding,
    this.onTap,
    this.inkEffect,
    this.inkColor,
    required this.selected,
    required this.opacity,
    this.animation,
    this.flex,
    this.indexLabel,
    required this.barAnimation,
  });

  final BottomBarItem items;

  ///Icon size
  final double iconSize;

  ///onTap gesture event
  final VoidCallback? onTap;

  final bool? inkEffect;
  final Color? inkColor;
  final bool selected;
  final EdgeInsets? padding;

  ///Background color opacity
  final double opacity;
  final double? flex;
  final String? indexLabel;
  final Animation<double>? animation;
  final BarAnimation barAnimation;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Semantics(
        container: true,
        header: true,
        selected: selected,
        child: Padding(
          padding:
              padding ??
              (items.showBadge
                  ? const EdgeInsets.only(top: 6.0)
                  : EdgeInsets.zero),
          child: InkWell(
            onTap: onTap,
            splashColor: inkEffect! ? inkColor : Colors.transparent,
            highlightColor: Colors.transparent,
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(52),
              left: Radius.circular(52),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: _getBarItems(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _getBarItems() {
    // Only support IconStyle.Default
    return _defaultItems();
  }

  Color get itemColor =>
      items.backgroundColor ??
      (selected ? items.selectedColor : items.unSelectedColor);
  Color get itemColorOnSelected => items.backgroundColor ?? items.selectedColor;

  List<Widget> _defaultItems() {
    var label = LabelWidget(
      animation: animation!,
      item: items,
      color: itemColor,
    );
    return [
      Container(
        alignment: Alignment.center,
        child: Badge(
          label: items.badge,
          isLabelVisible: items.showBadge,
          backgroundColor: items.badgeColor,
          padding: items.badgePadding,
          child: IconTheme(
            data: IconThemeData(color: itemColor, size: iconSize),
            child: selected ? items.selectedIcon ?? items.icon : items.icon,
          ),
        ),
      ),
      const SizedBox(height: 4),
      label,
    ];
  }
}

class LabelWidget extends StatelessWidget {
  const LabelWidget({
    super.key,
    required this.animation,
    required this.item,
    required this.color,
  });

  final Animation<double> animation;
  final BottomBarItem item;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: DefaultTextStyle.merge(
        style: TextStyle(
          fontSize: activeFontSize,
          fontWeight: FontWeight.w600,
          color: color,
        ),
        child: item.title!,
      ),
    );
  }
}
