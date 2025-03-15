import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import '/main_menu/main_menu.dart';
import '/settings/settings_controller.dart';
import '/game_internals/ludo_provider.dart';
import '/style/palette.dart';
import 'audio/audio.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settingsController = SettingsController();

  try {
    await settingsController.loadSettings();
    Audio.attachSettings(settingsController);
  } catch (e) {
    print('Error loading settings: $e');
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsController>(
          create: (_) => settingsController,
        ),

        ChangeNotifierProvider<LudoProvider>(
          create: (_) => LudoProvider(settingsController)..startGame(),
        ),

        Provider<Palette>(
          create: (_) => Palette(),
        ),
      ],
      child: const Root(),
    ),
  );
}

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _precacheImages();
    });
  }

  Future<void> _precacheImages() async {
    final context = this.context;
    await Future.wait([
      precacheImage(const AssetImage("assets/images/board.jpg"), context),
      precacheImage(const AssetImage("assets/images/dice/1.jpg"), context),
      precacheImage(const AssetImage("assets/images/dice/2.jpg"), context),
      precacheImage(const AssetImage("assets/images/dice/3.jpg"), context),
      precacheImage(const AssetImage("assets/images/dice/4.jpg"), context),
      precacheImage(const AssetImage("assets/images/dice/5.jpg"), context),
      precacheImage(const AssetImage("assets/images/dice/6.jpg"), context),
      precacheImage(const AssetImage("assets/images/dice/draw.gif"), context),
      precacheImage(const AssetImage("assets/images/crown/1st.jpg"), context),
      precacheImage(const AssetImage("assets/images/crown/2nd.jpg"), context),
      precacheImage(const AssetImage("assets/images/crown/3rd.jpg"), context),
      precacheImage(const AssetImage("assets/images/background04.jpg"), context),
      precacheImage(const AssetImage("assets/icon/logo01.png"), context),

    ]).catchError((error) {
      print('Error precaching images: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainMenu(),
    );
  }
}
