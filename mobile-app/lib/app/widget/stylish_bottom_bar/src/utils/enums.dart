/// Defines the location of the FloatingActionButton in the Stylish Bottom Bar.
enum StylishBarFabLocation {
  /// Places the FAB at the center of the bottom bar.
  center,

  /// Places the FAB at the end (typically the right side) of the bottom bar.
  end,
}

/// Specifies the animation style for bar items.
enum BarAnimation {
  /// Fades the bar item in and out.
  fade,

  /// Blinks the bar item.
  blink,

  /// Applies a 3D transformation to the bar item.
  transform3D,

  /// Adds a liquid-like effect to the icon. When clicked, the icon hides,
  /// and a rectangular shape with circular radius appears with the title.
  ///
  /// Note: This animation is not yet fully customized.
  liquid,

  /// Adds a water drop effect to the icon.
  drop,
}

/// Defines the style of icons in the bottom bar.
enum IconStyle {
  /// Both the icon and title widgets are visible, and the color of the selected item changes.
  ///
  /// Note: This is the default style.
  // ignore: constant_identifier_names
  Default,
}

enum NotchStyle { circle, square, themeDefault, convex }
