// pages/settings.dart
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/models/now_playing_model.dart';
import 'package:untitled1/models/settings_model.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SingleValueDropDownController _cnt = SingleValueDropDownController(
    data: DropDownValueModel(name: "system_default", value: "System default"),
  );

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settingsModel = Provider.of<SettingsModel>(context, listen: false);
      String name;
      String value;

      switch (settingsModel.themeMode) {
        case ThemeMode.dark:
          name = 'always_dark';
          value = 'Always dark';
          break;
        case ThemeMode.light:
          name = 'always_light';
          value = 'Always light';
          break;
        default:
          name = 'system_default';
          value = 'System default';
      }

      _cnt.setDropDown(DropDownValueModel(name: name, value: value));
      setState(() {
        _darkMode = settingsModel.isDarkMode;
        _showNotifications = settingsModel.showNotifications;
        _audioQuality = settingsModel.audioQuality;
        _downloadAlbumArtwork = settingsModel.downloadAlbumArtwork;
        _musicFolder = settingsModel.musicFolder;
      });
    });
  }

  @override
  void dispose() {
    _cnt.dispose();
    super.dispose();
  }

  bool _darkMode = false;
  bool _showNotifications = true;
  String _audioQuality = "High";
  bool _downloadAlbumArtwork = true;
  String _musicFolder = "";

  @override
  Widget build(BuildContext context) {
    final settingsModel = Provider.of<SettingsModel>(context, listen: true);
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Theme",
                  style: TextStyle(
                    color:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.white70
                            : Colors.black87,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    _showThemeSelectionDialog(context, settingsModel);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[800]
                              : Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey[700]!
                                : Colors.grey[300]!,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _getThemeModeText(settingsModel.themeMode),
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black87,
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color:
                              Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white70
                                  : Colors.black54,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SwitchListTile(
            title: const Text("Gapless Playback"),
            subtitle: const Text("Play songs without gaps"),
            value: true,
            onChanged: (value) {
              //dopsat
            },
          ),
          const Divider(),

          // Library Section
          _buildSectionHeader("Library"),
          ListTile(
            title: const Text("Music Folder"),
            subtitle: Text(_musicFolder),
            trailing: const Icon(Icons.folder_open),
            onTap: () {
              //dopsat
            },
          ),
          SwitchListTile(
            title: const Text("Download Album Artwork"),
            subtitle: const Text("Fetch missing album art from the internet"),
            value: _downloadAlbumArtwork,
            onChanged: (value) {
              setState(() {
                _downloadAlbumArtwork = value;
                settingsModel.setDownloadAlbumArtwork(value);
              });
            },
          ),
          ListTile(
            title: const Text("Scan Library"),
            subtitle: const Text("Scan for new music files"),
            trailing: const Icon(Icons.refresh),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                //dopsat
                const SnackBar(content: Text("Scanning for music...")),
              );
              // Implement library scanning
            },
          ),
          const Divider(),

          _buildSectionHeader("Notifications"),
          SwitchListTile(
            title: const Text("Show Notifications"),
            subtitle: const Text(
              "Display currently playing song in notification area",
            ),
            value: _showNotifications,
            onChanged: (value) {
              setState(() {
                _showNotifications = value;
              });
              settingsModel.setShowNotifications(value);
            },
          ),
          const Divider(),

          // Cache Section
          _buildSectionHeader("Cache"),
          ListTile(
            title: const Text("Clear Cache"),
            subtitle: const Text("Free up space by clearing cached data"),
            trailing: const Icon(Icons.cleaning_services),
            onTap: () {
              _showClearCacheDialog();
            },
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildQualityOption(String quality) {
    return ListTile(
      title: Text(quality),
      leading: Radio<String>(
        value: quality.split(" ")[0],
        groupValue: _audioQuality,
        onChanged: (value) {
          setState(() {
            _audioQuality = value!;
            Navigator.pop(context);
          });
        },
      ),
      onTap: () {
        setState(() {
          _audioQuality = quality.split(" ")[0];
          Navigator.pop(context);
        });
      },
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Clear Cache"),
          content: const Text("This will clear all cached data. Are you sure?"),
          actions: [
            TextButton(
              onPressed: () {
                // dopsat
                Navigator.pop(context);
              },
              child: const Text("CANCEL"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("Cache cleared")));
              },
              child: const Text("CLEAR"),
            ),
          ],
        );
      },
    );
  }

  void _showThemeSelectionDialog(
    BuildContext context,
    SettingsModel settingsModel,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Theme"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Always dark"),
                onTap: () {
                  settingsModel.setDarkMode();
                  setState(() {
                    _darkMode = true;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Always light"),
                onTap: () {
                  settingsModel.setLightMode();
                  setState(() {
                    _darkMode = false;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("System default"),
                onTap: () {
                  final isDark =
                      MediaQuery.of(context).platformBrightness ==
                      Brightness.dark;
                  setState(() {
                    _darkMode = isDark;
                  });
                  settingsModel.setSystemMode();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String _getThemeModeText(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.dark:
        return "Always dark";
      case ThemeMode.light:
        return "Always light";
      default:
        return "System default";
    }
  }
}
