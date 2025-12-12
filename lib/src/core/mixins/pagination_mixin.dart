import 'dart:async';
import 'package:flutter/material.dart';

mixin PaginationMixin<T extends StatefulWidget> on State<T> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  Timer? _searchDebounce;

  /// Callback when user scrolls near bottom (200px from end)
  void onLoadMore();

  /// Callback when search query changes (debounced by 400ms)
  void onSearchChanged(String query);

  /// Callback when search is cleared
  void onSearchCleared();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_handleScroll);
    searchController.addListener(_handleSearchChanged);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    searchController
      ..removeListener(_handleSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!scrollController.hasClients) return;

    final pixels = scrollController.position.pixels;
    final maxScroll = scrollController.position.maxScrollExtent;

    if (pixels >= maxScroll - 200) {
      onLoadMore();
    }
  }

  void _handleSearchChanged() {
    _searchDebounce?.cancel();
    final query = searchController.text.trim();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) {
        onSearchChanged(query);
      }
    });
  }

  void clearSearch() {
    _searchDebounce?.cancel();
    _searchDebounce = null;
    searchController.removeListener(_handleSearchChanged);
    searchController.clear();
    searchController.addListener(_handleSearchChanged);
    onSearchCleared();
  }
}


