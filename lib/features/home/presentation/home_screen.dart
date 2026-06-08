import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _truths = [
    'What is your biggest secret?',
    'Who was the last person you lied to?',
    'What is the most embarrassing thing you have ever done?',
    'Have you ever cheated on a test?',
    'What is your biggest fear about the future?',
  ];

  final List<String> _dares = [
    'Sing a song selected by the other players.',
    'Do 20 push-ups in 30 seconds.',
    'Dance for 1 minute without music.',
    'Speak in an accent for the next two rounds.',
    'Let another player send a text message from your phone.',
  ];

  final List<Map<String, String>> _history = [
    {'player': 'Alex', 'type': 'Truth', 'outcome': 'Completed'},
    {'player': 'Sofia', 'type': 'Dare', 'outcome': 'Failed'},
    {'player': 'Mateo', 'type': 'Truth', 'outcome': 'Completed'},
  ];

  void _showChoiceDialog(String type, List<String> options, Color primaryColor) {
    final randomPrompt = options[Random().nextInt(options.length)];

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E1B29),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: primaryColor, width: 2),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  type.toUpperCase(),
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Your Challenge:',
                  style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 15),
                Text(
                  randomPrompt,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _history.insert(0, {
                            'player': 'You',
                            'type': type,
                            'outcome': 'Completed',
                          });
                        });
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Completed',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _history.insert(0, {
                            'player': 'You',
                            'type': type,
                            'outcome': 'Failed',
                          });
                        });
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.white30),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Forfeit',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1B29),
        elevation: 0,
        title: const Text(
          'Truth or Dare',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.pinkAccent),
            tooltip: 'Log Out',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully.')),
              );
              context.go('/login');
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E1B29),
              Color(0xFF0F0E17),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome header
              const Card(
                color: Color(0xFF2E2B3E),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        'Ready to Play?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Gather your friends, choose a category, and take turns selecting Truth or Dare!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              // Game Choice Grid
              Expanded(
                child: Row(
                  children: [
                    // TRUTH Selection Card
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _showChoiceDialog('Truth', _truths, Colors.cyanAccent),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF142C33),
                                Color(0xFF0E1E22),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.cyanAccent.withOpacity(0.5), width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.cyanAccent.withOpacity(0.15),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.remove_red_eye_rounded,
                                size: 50,
                                color: Colors.cyanAccent,
                              ),
                              SizedBox(height: 15),
                              Text(
                                'TRUTH',
                                style: TextStyle(
                                  color: Colors.cyanAccent,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // DARE Selection Card
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _showChoiceDialog('Dare', _dares, Colors.pinkAccent),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF331422),
                                Color(0xFF220E16),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.pinkAccent.withOpacity(0.5), width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.pinkAccent.withOpacity(0.15),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.flash_on_rounded,
                                size: 50,
                                color: Colors.pinkAccent,
                              ),
                              SizedBox(height: 15),
                              Text(
                                'DARE',
                                style: TextStyle(
                                  color: Colors.pinkAccent,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              // Recent Activity Feed
              const Text(
                'Recent Activity',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1B29),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListView.separated(
                  padding: const EdgeInsets.all(15),
                  itemCount: _history.length,
                  separatorBuilder: (context, index) => const Divider(color: Color(0xFF2E2B3E)),
                  itemBuilder: (context, index) {
                    final item = _history[index];
                    final isTruth = item['type'] == 'Truth';
                    final isCompleted = item['outcome'] == 'Completed';

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: const Color(0xFF2E2B3E),
                              child: Text(
                                item['player']![0],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['player']!,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Chose ${item['type']}',
                                  style: TextStyle(
                                    color: isTruth ? Colors.cyanAccent : Colors.pinkAccent,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Chip(
                          label: Text(
                            item['outcome']!,
                            style: TextStyle(
                              color: isCompleted ? Colors.greenAccent : Colors.redAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: const Color(0xFF2E2B3E),
                          shape: const StadiumBorder(),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
