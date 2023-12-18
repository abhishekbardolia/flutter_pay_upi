import 'dart:typed_data';

/// This is the model class of apps returned by [getAllUpiApps()].
/// This class contains some predefined package names of UPI apps.
class UpiApp {
  /// app is the package name of the app. Pass this in [app] argument of [startTransaction]
  String? app;

  /// This is the app name for display purpose
  String? name;

  /// This is the icon of the UPI app. Pass it in [Image.memory()] to display the icon.
  Uint8List? icon;

  UpiApp.fromMap(Map<String, dynamic> m) {
    app = m['packageName'];
    name = m['name'];
    icon = m['icon'];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpiApp && runtimeType == other.runtimeType && app == other.app;

  @override
  int get hashCode => app.hashCode;
}
