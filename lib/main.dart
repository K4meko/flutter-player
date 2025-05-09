// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/components/currentlyPlaying.dart';
import 'package:untitled1/models/now_playing_model.dart';
import 'package:untitled1/models/settings_model.dart';
import 'package:untitled1/theme.dart';
import 'package:permission_handler/permission_handler.dart';
import 'pages/home.dart';
import 'pages/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (await Permission.storage.request().isGranted) {
    print("Storage permission granted");
  } else {
    print("Storage permission denied");
  }

  if (await Permission.audio.request().isGranted) {
    print("Audio permission granted");
  } else {
    print("Audio permission denied");
  }

  final settingsModel = SettingsModel();
  await settingsModel.initialize();
  final nowPlayingModel = NowPlayingModel();

  await nowPlayingModel.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: nowPlayingModel),
        ChangeNotifierProvider.value(value: settingsModel),
      ],
      child: MyAppWithDependencies(settingsModel: settingsModel),
    ),
  );
}

class MyAppWithDependencies extends StatelessWidget {
  final SettingsModel settingsModel;

  const MyAppWithDependencies({required this.settingsModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsModel>(
      builder: (context, model, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          darkTheme: darkTheme,
          theme: lightTheme,
          themeMode: model.themeMode,
          home: const MyApp(),
        );
      },
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [const HomePage(), const SettingsPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(index: _selectedIndex, children: _pages),
          ),
          const Currentlyplaying(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.headphones), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ""),
        ],
      ),
    );
  }
}
