// models/settings_model.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsModel extends ChangeNotifier {
  late SharedPreferences _prefs;
  ThemeMode _themeMode = ThemeMode.system;
  String _musicFolder = "/storage/emulated/0/Download";
  bool _downloadAlbumArtwork = true;
  String _audioQuality = "High";
  bool _showNotifications = true;

  ThemeMode get themeMode => _themeMode;
  String get musicFolder => _musicFolder;
  bool get downloadAlbumArtwork => _downloadAlbumArtwork;
  String get audioQuality => _audioQuality;
  bool get showNotifications => _showNotifications;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _loadPreferences();

    notifyListeners();
  }

  void _loadPreferences() {
    final themeModeString = _prefs.getString('theme_mode') ?? 'system';
    switch (themeModeString) {
      case 'dark':
        _themeMode = ThemeMode.dark;
        break;
      case 'light':
        _themeMode = ThemeMode.light;
        break;
      default:
        _themeMode = ThemeMode.system;
    }
    _musicFolder =
        _prefs.getString('music_folder') ?? "/storage/emulated/0/Download";
    _downloadAlbumArtwork = _prefs.getBool('download_album_artwork') ?? true;
    _audioQuality = _prefs.getString('audio_quality') ?? "High";
    _showNotifications = _prefs.getBool('show_notifications') ?? true;
    void toggleDownload() {
      _downloadAlbumArtwork = !_downloadAlbumArtwork;
      _prefs.setBool('download_album_artwork', _downloadAlbumArtwork);
      notifyListeners();
    }
  }

  void clearChache() async {
    await _prefs.clear();
    _themeMode = ThemeMode.system;
    _musicFolder = "/storage/emulated/0/Download";
    _downloadAlbumArtwork = true;
    _audioQuality = "High";
    _showNotifications = true;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    print("Setting theme mode: $mode");
    switch (mode) {
      case ThemeMode.dark:
        _prefs.setString('theme_mode', 'dark');
        break;
      case ThemeMode.light:
        _prefs.setString('theme_mode', 'light');
        break;
      default:
        _prefs.setString('theme_mode', 'system');
    }
    _themeMode = mode;
    notifyListeners();
  }

  void setDarkMode() {
    print("Setting dark mode");
    _prefs.setString('theme_mode', 'dark');
    _themeMode = ThemeMode.dark;
    notifyListeners();
  }

  void setLightMode() {
    print("Setting light mode");
    _prefs.setString('theme_mode', 'light');
    _themeMode = ThemeMode.light;
    notifyListeners();
  }

  void setSystemMode() {
    print("Setting system mode");
    _prefs.setString('theme_mode', 'system');
    _themeMode = ThemeMode.system;
    notifyListeners();
  }

  void setMusicFolder(String path) {
    _prefs.setString('music_folder', path);
    _musicFolder = path;
    notifyListeners();
  }

  void setDownloadAlbumArtwork(bool value) {
    _prefs.setBool('download_album_artwork', value);
    _downloadAlbumArtwork = value;
    notifyListeners();
  }

  void setAudioQuality(String quality) {
    _audioQuality = quality;
    _prefs.setString('audio_quality', quality);
    notifyListeners();
  }

  void setShowNotifications(bool value) {
    _showNotifications = value;
    _prefs.setBool('show_notifications', value);
    notifyListeners();
  }
}
