import 'package:basic/style/background_image.dart';
import 'package:flutter/material.dart';
import '/game_internals/ludo_provider.dart';
import '/game_widgets/board_widget.dart';
import '/game_widgets/dice_widget.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<GameScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffa2dcc7),
        title: const Text('Flutter Ludo',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Permanent Marker',
            )),
        leading: IconButton(
          icon: Image.asset('assets/images/back.png'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BackgroundWidget(
        child: Consumer<LudoProvider>(
          builder: (context, ludoProvider, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Centered Board
                const Center(child: BoardWidget()),

                // Top Left Box (Green Player)
                Positioned(
                  top: 120,
                  left: 20,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.5),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Visibility(
                      visible: ludoProvider.currentPlayerIndex == 0, // Green player
                      child: const Center(child: DiceWidget()),
                    ),
                  ),
                ),

                // Top Right Box (Yellow Player)
                Positioned(
                  top: 120,
                  right: 20,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.yellow.withOpacity(0.5),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Visibility(
                      visible: ludoProvider.currentPlayerIndex == 1, // Yellow player
                      child: const Center(child: DiceWidget()),
                    ),
                  ),
                ),

                // Bottom right Box (red Player)
                Positioned(
                  bottom: 120,
                  left: 20,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.5),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Visibility(
                      visible: ludoProvider.currentPlayerIndex == 3, // Red player
                      child: const Center(child: DiceWidget()),
                    ),
                  ),
                ),

                // Bottom left Box (blue Player)
                Positioned(
                  bottom: 120,
                  right: 20,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.5),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Visibility(
                      visible: ludoProvider.currentPlayerIndex == 2, // Blue player
                      child: const Center(child: DiceWidget()),
                    ),

                  ),
                ),

                // Game Over Overlay
                if (ludoProvider.winners.length == 3)
                  Container(
                    color: Colors.black.withOpacity(0.8),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset("assets/images/game_over.jpg"),
                          const Text("Thank you for playing :)",
                              style: TextStyle(color: Colors.purpleAccent, fontSize: 20),
                              textAlign: TextAlign.center),
                          Text(
                              "The Winners is: ${ludoProvider.winners.map((e) => e.name.toUpperCase()).join(", ")}",
                              style: const TextStyle(color: Colors.purpleAccent, fontSize: 30),
                              textAlign: TextAlign.center),
                          const Divider(color: Colors.white),
                          const Text("This game was made with Flutter",
                              style: TextStyle(color: Colors.purpleAccent, fontSize: 15),
                              textAlign: TextAlign.center),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              ludoProvider.startGame();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const GameScreen()),
                              );
                            },
                            child: const Text("Play again",
                                style: TextStyle(color: Colors.white, fontSize: 20),
                                textAlign: TextAlign.center),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}