import 'package:basic/style/background_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/style/my_button.dart';
import '/style/palette.dart';
import '/style/responsive_screen.dart';
import 'settings_controller.dart';
class SettingsScreen extends StatelessWidget {
   const SettingsScreen({super.key});

  static const _gap = SizedBox(height: 60);

  @override
  Widget build(BuildContext context) {
    final settingsController = context.watch<SettingsController>();
    final palette = context.watch<Palette>();

    return Scaffold(
      body: BackgroundWidget(
        child: ResponsiveScreen(
          squarishMainArea: ListView(
            children: [
              _gap,
              const Text(
              'Settings',
              textAlign: TextAlign.center,
             style: TextStyle(color: Colors.black,
             fontFamily: 'Permanent Marker',
             fontSize: 55,
             height: 1,
               ),
                ),
              _gap,
              // const _NameChangeLine(
              //   'Name',
              // ),
              _SettingsLine(
                'Sound FX',
                Icon(settingsController.soundsOn.value ? Icons.graphic_eq : Icons.volume_off),
                onSelected: settingsController.toggleSoundsOn,
              ),
              _SettingsLine(
                'Music',
                Icon(settingsController.musicOn.value ? Icons.music_note : Icons.music_off),
                onSelected: settingsController.toggleMusicOn,
              ),

              _gap,
            ],
          ),
          rectangularMenuArea: MyButton(
            onPressed: () {
              Navigator.pop(context);
            },
           child: Image.asset(
          'assets/images/back.png',
           width: 50,
            height: 50,
          ),
        ),
        ),
      ),
    );
  }
}
class _SettingsLine extends StatelessWidget {
  final String title;

  final Widget icon;

  final VoidCallback? onSelected;

  const _SettingsLine(this.title, this.icon, {this.onSelected});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      highlightShape: BoxShape.rectangle,
      onTap: onSelected,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.black,
                  fontFamily: 'Permanent Marker',
                  fontSize: 30,
                ),
              ),
            ),
            icon,
          ],
        ),
      ),
    );
  }
}
