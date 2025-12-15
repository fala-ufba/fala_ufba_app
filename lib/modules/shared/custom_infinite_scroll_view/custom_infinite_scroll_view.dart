import 'dart:async';

import 'package:fala_ufba/modules/shared/custom_infinite_scroll_view/sliver_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CustomInfiniteScrollView extends HookWidget {
  final List<Widget> slivers;
  final double bottomPadding;
  final FutureOr<void> Function()? onEndScroll;

  const CustomInfiniteScrollView({
    super.key,
    required this.slivers,
    this.bottomPadding = 16.0,
    this.onEndScroll,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.pixels > 0 &&
            notification.metrics.atEdge) {
          onEndScroll?.call();
        }
        return false;
      },
      child: CustomScrollView(
        slivers: [...slivers, SliverSpacing.vertical(bottomPadding)],
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
      ),
    );
  }
}
