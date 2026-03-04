import 'dart:async';
import 'package:flutter/material.dart';

class BreathingPracticeScreen extends StatefulWidget {
  const BreathingPracticeScreen({super.key});

  @override
  State<BreathingPracticeScreen> createState() => _BreathingPracticeScreenState();
}

class _BreathingPracticeScreenState extends State<BreathingPracticeScreen> {
  bool isInhale = true;
  int secondsLeft = 4;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startBreathingCycle();
  }

  void _startBreathingCycle() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (secondsLeft > 1) {
          secondsLeft--;
        } else {
          isInhale = !isInhale;
          secondsLeft = 4;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD1C4E9),
      appBar: AppBar(
        title: const Text("Дыхательная практика"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(seconds: 4),
              width: isInhale ? 200 : 120,
              height: isInhale ? 200 : 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  isInhale ? "Вдох " : "Выдох ",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              "Осталось: $secondsLeft сек",
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text("Назад"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple.shade700,
                foregroundColor: Colors.white,
                minimumSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
