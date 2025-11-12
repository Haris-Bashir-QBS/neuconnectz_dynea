import 'package:neuconnectz_dynea/src/core/enums/component_type.dart';

class DashboardComponent {
  final ComponentType type;
  final String title;
  final List<DashboardSubItem> subItems;
  bool isAdded;

  DashboardComponent({
    required this.type,
    required this.title,
    required this.subItems,
    this.isAdded = false,
  });
}

class DashboardSubItem {
  final String name;
  bool isSelected;
  bool isAdded;

  DashboardSubItem({
    required this.name,
    this.isSelected = false,
    this.isAdded = false,
  });
}
