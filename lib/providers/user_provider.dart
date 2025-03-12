import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? _uid;
  String? _email;
  DateTime? _createdAt;
  int? _currentDay;
  List<String>? _completedSessions;
  DateTime? _lastLogin;
  bool? _hasCompletedConfiguration; // Add this field

  String? get uid => _uid;
  String? get email => _email;
  DateTime? get createdAt => _createdAt;
  int? get currentDay => _currentDay;
  List<String>? get completedSessions => _completedSessions;
  DateTime? get lastLogin => _lastLogin;
  bool? get hasCompletedConfiguration => _hasCompletedConfiguration;

  void setUserDetails({
    required String uid,
    required String email,
    DateTime? createdAt,
    int? currentDay,
    List<String>? completedSessions,
    DateTime? lastLogin,
    bool? hasCompletedConfiguration,
  }) {
    _uid = uid;
    _email = email;
    _createdAt = createdAt;
    _currentDay = currentDay;
    _completedSessions = completedSessions;
    _lastLogin = lastLogin;
    _hasCompletedConfiguration = hasCompletedConfiguration ?? false;
    notifyListeners();
  }

  void updateCurrentDay(int newDay) {
    _currentDay = newDay;
    notifyListeners();
  }

  void updateHasCompletedConfiguration(bool value) {
    _hasCompletedConfiguration = value;
    notifyListeners();
  }

  void clearUserDetails() {
    _uid = null;
    _email = null;
    _createdAt = null;
    _currentDay = null;
    _completedSessions = null;
    _lastLogin = null;
    _hasCompletedConfiguration = null;
    notifyListeners();
  }
}
