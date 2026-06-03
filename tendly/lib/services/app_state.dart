import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class AppState extends ChangeNotifier {
  // ── Auth / Profile
  String parentName = '';
  List<Child> children = [];
  int activeChildIndex = 0;

  // ── Daily
  List<Habit> habits = [];
  List<SavedItem> savedItems = [];
  List<Story> savedStories = [];

  // ── UI State
  String selectedTheme = 'Magic forest';
  List<String> selectedGoals = [];
  int expandedCircle = -1;
  String selectedPlan = 'annual';
  bool isOnboarded = false;

  Child? get activeChild => children.isNotEmpty ? children[activeChildIndex] : null;

  // ─── Persistence ─────────────────────────────────────────────────────────
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('tendly_state_v2');
    if (raw == null) return;
    try {
      final m = json.decode(raw) as Map<String, dynamic>;
      parentName = m['parentName'] as String? ?? '';
      isOnboarded = m['isOnboarded'] as bool? ?? false;
      children = (m['children'] as List<dynamic>? ?? [])
          .map((e) => Child.fromMap(e as Map<String, dynamic>)).toList();
      habits = (m['habits'] as List<dynamic>? ?? [])
          .map((e) => Habit.fromMap(e as Map<String, dynamic>)).toList();
      savedItems = (m['savedItems'] as List<dynamic>? ?? [])
          .map((e) => SavedItem.fromMap(e as Map<String, dynamic>)).toList();
      savedStories = (m['savedStories'] as List<dynamic>? ?? [])
          .map((e) => Story.fromMap(e as Map<String, dynamic>)).toList();
      activeChildIndex = m['activeChildIndex'] as int? ?? 0;
      selectedTheme = m['selectedTheme'] as String? ?? 'Magic forest';
    } catch (_) {}
    notifyListeners();
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tendly_state_v2', json.encode({
      'parentName': parentName,
      'isOnboarded': isOnboarded,
      'children': children.map((c) => c.toMap()).toList(),
      'habits': habits.map((h) => h.toMap()).toList(),
      'savedItems': savedItems.map((s) => s.toMap()).toList(),
      'savedStories': savedStories.map((s) => s.toMap()).toList(),
      'activeChildIndex': activeChildIndex,
      'selectedTheme': selectedTheme,
    }));
  }

  // ─── Actions ──────────────────────────────────────────────────────────────
  void finishOnboarding() {
    isOnboarded = true;
    if (habits.isEmpty) habits = TContent.defaultHabits();
    save();
    notifyListeners();
  }

  void addChild(Child child) {
    children.add(child);
    save(); notifyListeners();
  }

  void setActiveChild(int index) {
    activeChildIndex = index;
    save(); notifyListeners();
  }

  void toggleHabit(int index) {
    habits[index].done = !habits[index].done;
    if (habits[index].done) habits[index].streak++;
    save(); notifyListeners();
  }

  void saveItem(SavedItem item) {
    if (savedItems.any((s) => s.name == item.name)) return;
    savedItems.insert(0, item);
    save(); notifyListeners();
  }

  void removeItem(String id) {
    savedItems.removeWhere((s) => s.id == id);
    save(); notifyListeners();
  }

  void saveStory(Story story) {
    if (savedStories.any((s) => s.title == story.title)) return;
    savedStories.insert(0, story);
    saveItem(SavedItem(id: story.id, type: 'Story', name: story.title, savedAt: story.createdAt));
    save(); notifyListeners();
  }

  void setTheme(String theme) {
    selectedTheme = theme;
    notifyListeners();
  }

  void setExpandedCircle(int i) {
    expandedCircle = expandedCircle == i ? -1 : i;
    notifyListeners();
  }
}
