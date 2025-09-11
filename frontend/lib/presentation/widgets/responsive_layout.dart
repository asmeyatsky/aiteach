import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  // Screen size breakpoints
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= 1200) {
      return desktop;
    } else if (width >= 600) {
      return tablet ?? desktop;
    } else {
      return mobile;
    }
  }
}

class AdaptiveText extends StatelessWidget {
  final String text;
  final TextStyle? mobileStyle;
  final TextStyle? tabletStyle;
  final TextStyle? desktopStyle;

  const AdaptiveText(
    this.text, {
    super.key,
    this.mobileStyle,
    this.tabletStyle,
    this.desktopStyle,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= 1200 && desktopStyle != null) {
      return Text(text, style: desktopStyle);
    } else if (width >= 600 && tabletStyle != null) {
      return Text(text, style: tabletStyle);
    } else {
      return Text(text, style: mobileStyle);
    }
  }
}

class AdaptivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsets mobilePadding;
  final EdgeInsets? tabletPadding;
  final EdgeInsets? desktopPadding;

  const AdaptivePadding({
    super.key,
    required this.child,
    this.mobilePadding = const EdgeInsets.all(16.0),
    this.tabletPadding,
    this.desktopPadding,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= 1200 && desktopPadding != null) {
      return Padding(padding: desktopPadding!, child: child);
    } else if (width >= 600 && tabletPadding != null) {
      return Padding(padding: tabletPadding!, child: child);
    } else {
      return Padding(padding: mobilePadding, child: child);
    }
  }
}

class AdaptiveGridView extends StatelessWidget {
  final int mobileCrossAxisCount;
  final int tabletCrossAxisCount;
  final int desktopCrossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final List<Widget> children;

  const AdaptiveGridView({
    super.key,
    this.mobileCrossAxisCount = 1,
    this.tabletCrossAxisCount = 2,
    this.desktopCrossAxisCount = 3,
    this.mainAxisSpacing = 16.0,
    this.crossAxisSpacing = 16.0,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    int crossAxisCount;

    if (width >= 1200) {
      crossAxisCount = desktopCrossAxisCount;
    } else if (width >= 600) {
      crossAxisCount = tabletCrossAxisCount;
    } else {
      crossAxisCount = mobileCrossAxisCount;
    }

    return GridView.count(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      children: children,
    );
  }
}