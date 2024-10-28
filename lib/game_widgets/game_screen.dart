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
        title: const Text('Flutter Ludo'),
        leading: IconButton(
          icon: Image.asset('assets/images/back.png') ,
          onPressed: () {
            // Optionally, confirm before exiting the game
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color(0xffffffd1),
      body: Stack(
        alignment: Alignment.center,
        children: [
          const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              BoardWidget(),
              Center(child: SizedBox(width: 100, height: 100, child: DiceWidget())),
            ],
          ),
          Consumer<LudoProvider>(
            builder: (context, value, child) => value.winners.length == 3
                ? Container(
                    color: Colors.black.withOpacity(0.8),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset("assets/images/game_over.jpg"),
                          const Text("Thank you for playing :)", style: TextStyle(color: Colors.purpleAccent, fontSize: 20), textAlign: TextAlign.center),
                          Text("The Winners is: ${value.winners.map((e) => e.name.toUpperCase()).join(", ")}", style: const TextStyle(color: Colors.purpleAccent, fontSize: 30), textAlign: TextAlign.center),
                          const Divider(color: Colors.white),
                          const Text("This game was made with Flutter", style: TextStyle(color: Colors.purpleAccent, fontSize: 15), textAlign: TextAlign.center),
                          const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          context.read<LudoProvider>().startGame();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const GameScreen()),
                          );
                        },
                          child: const Text("Play again", style: TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.center),
                      ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
