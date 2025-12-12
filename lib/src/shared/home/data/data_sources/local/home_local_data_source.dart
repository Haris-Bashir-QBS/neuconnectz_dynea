import 'dart:convert';

import 'package:neuconnectz_dynea/src/shared/home/data/models/dashboard_analytics_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class HomeLocalDataSource {
  Future<void> cacheDashboardAnalytics(DashboardAnalyticsModel model);
  Future<DashboardAnalyticsModel?> getCachedDashboardAnalytics();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  static const String cacheKey = 'dashboard_analytics_cache';

  @override
  Future<void> cacheDashboardAnalytics(DashboardAnalyticsModel model) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(cacheKey, jsonEncode(model.toJson()));
  }

  @override
  Future<DashboardAnalyticsModel?> getCachedDashboardAnalytics() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(cacheKey);
    if (jsonString != null) {
      return DashboardAnalyticsModel.fromJson(jsonDecode(jsonString));
    }
    return null;
  }
}


