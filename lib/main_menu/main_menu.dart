import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '/game_widgets/game_screen.dart'; // Adjust the import path as needed
import '/settings/settings_screen.dart'; // We'll create this next
import '/style/my_button.dart';
import '/style/responsive_screen.dart';
import '/settings/settings_controller.dart';
import '/style/palette.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  void _exitApp(BuildContext context) {
    // For mobile platforms
    SystemNavigator.pop();
    // For web or other platforms, you might want to show a dialog instead
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final settingsController = Provider.of<SettingsController>(context);
    return  Scaffold(
      backgroundColor: palette.backgroundMain,
      body: ResponsiveScreen(
        squarishMainArea: Center(
          child: Transform.rotate(
            angle: -0.1,
            child: const Text(
              'Flutter Ludo',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Permanent Marker',
                fontSize: 55,
                height: 1,
              ),
            ),
          ),
        ),
        rectangularMenuArea: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            MyButton(
              child: const Text('Play'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GameScreen()),
                );
              },
            ),
            _gap,
            MyButton(
              child: const Text('Settings'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),
            _gap,
            MyButton(
              onPressed: () => _exitApp(context),
              child: const Text('Exit'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: ValueListenableBuilder<bool>(
                valueListenable: settingsController.audioOn,
                builder: (context, audioOn, child) {
                  return IconButton(
                    onPressed: settingsController.toggleAudioOn,
                    icon: Icon(audioOn ? Icons.volume_up : Icons.volume_off),
                  );
                },
              ),
            ),
            _gap,
            const Text('by Sahabaj'),
            _gap,
          ],
        ),
      ),
    );
  }

  static const _gap = SizedBox(height: 10);
}


