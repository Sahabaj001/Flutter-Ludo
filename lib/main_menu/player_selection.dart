import 'package:basic/style/background_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../game_internals/ludo_provider.dart';
import '../game_widgets/game_screen.dart';
import '../settings/settings_controller.dart';



class PlayerSelectionScreen extends StatelessWidget {
  const PlayerSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Number of Players',
        style:TextStyle(fontFamily: 'Permanent Marker',)),
        backgroundColor: const Color(0xffa2dcc7),
      ),
      backgroundColor: const Color(0xFFFFFFD1), // Corrected (ARGB)

      body: BackgroundWidget(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 2 Players Option
              _buildPlayerOption(context, 2, '2 Players'),
        
              const SizedBox(height: 20),
        
              // 3 Players Option
              _buildPlayerOption(context, 3, '3 Players'),
        
              const SizedBox(height: 20),
        
              // 4 Players Option
              _buildPlayerOption(context, 4, '4 Players'),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build player option buttons
  Widget _buildPlayerOption(BuildContext context, int numberOfPlayers, String label) {
    return ElevatedButton(
      onPressed: () {
        // Navigate to the game screen and initialize the game with the selected number of players
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: ChangeNotifierProvider(
                create: (context) => LudoProvider(Provider.of<SettingsController>(context, listen: false))
                  ..startGame(numberOfPlayers),
                child: const GameScreen(),
              ),
            ),
          ),
        );


      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xffa2dcc7),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontFamily: 'Permanent Marker',
        ),
      ),
    );
  }
}