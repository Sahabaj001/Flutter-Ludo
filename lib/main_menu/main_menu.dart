import 'package:basic/main_menu/player_selection.dart';
import 'package:basic/style/background_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '/game_widgets/game_screen.dart'; // Adjust the import path as needed
import '/settings/settings_screen.dart'; // We'll create this next
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
    return Scaffold(
      body: BackgroundWidget(
        child: ResponsiveScreen(
          squarishMainArea: Center(
            child: Transform.rotate(
              angle: -0.1,
              child: Image.asset(
                "assets/icon/logo01.png", // Path to your custom icon
                width: 450, // Adjust size as needed
                height: 450, // Adjust size as needed
              ),
            ),
          ),
          rectangularMenuArea: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const PlayerSelectionScreen(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1.0, 0.0), // Slide from right to left
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        );
                      },
                    ),
                  );
                },

                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent, // Transparent background
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text(
                  'Play',
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white, // Text color
                    fontFamily: 'Permanent Marker',
                    //fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.red, // Border color
                        offset: Offset(1, 2), // Border thickness and position
                        blurRadius: 2, // Border blur
                      ),
                    ],
                  ),
                ),
              ),
             // _gap,
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const SettingsScreen(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1.0, 0.0), // Slide from right to left
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        );
                      },
                    ),
                  );
                },

                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent, // Transparent background
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white, // Text color
                    fontFamily: 'Permanent Marker',
                    //fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.red, // Border color
                        offset: Offset(1, 2), // Border thickness and position
                        blurRadius: 2, // Border blur
                      ),
                    ],
                  ),
                ),
              ),
              //_gap,
              TextButton(
                onPressed: () => _exitApp(context),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent, // Transparent background
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text(
                  'Exit',
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white, // Text color
                    fontFamily: 'Permanent Marker',
                   // fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.red, // Border color
                        offset: Offset(1, 2), // Border thickness and position
                        blurRadius: 2, // Border blur
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: ValueListenableBuilder<bool>(
                  valueListenable: settingsController.audioOn,
                  builder: (context, audioOn, child) {
                    return IconButton(
                      onPressed: settingsController.toggleAudioOn,
                      icon: Icon(audioOn ? Icons.volume_up : Icons.volume_off),
                      color: Colors.white, // Adjust icon color if needed
                    );
                  },
                ),
              ),
              _gap,
              const Text(
                'by Sahabaj',
                style: TextStyle(color: Colors.white,
                  fontFamily: 'Permanent Marker',), // Adjust text color if needed
              ),
              _gap,
            ],
          ),
        ),
      ),
    );
  }

  static const _gap = SizedBox(height: 10);
}