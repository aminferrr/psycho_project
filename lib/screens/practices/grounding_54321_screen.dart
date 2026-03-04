import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'grounding_data.dart'; // Импортируем данные

class Grounding54321Screen extends StatefulWidget {
  const Grounding54321Screen({super.key});

  @override
  State<Grounding54321Screen> createState() => _Grounding54321ScreenState();
}

class _Grounding54321ScreenState extends State<Grounding54321Screen> {
  final AudioPlayer player = AudioPlayer();

  int currentLevelIndex = 0;
  List<String> foundItemIds = [];
  String? selectedItemId;
  String activeText = "";
  bool debugMode = true;
  bool _isTransitioning = false;
  bool isCompleted = false;

  // Позиции и размеры зон клика (остаются те же)
  final List<Offset> buttonPositions = [
    Offset(310, 340),
    Offset(250, 330),
    Offset(220, 210),
    Offset(75, 0),
    Offset(50, 140),
    Offset(50, 200),
    Offset(80, 370),
    Offset(160, 280),
    Offset(200, 550),
    Offset(310, 320),
  ];

  final List<Size> buttonSizes = [
    Size(80, 80),
    Size(60, 60),
    Size(80, 80),
    Size(70, 70),
    Size(90, 90),
    Size(90, 90),
    Size(80, 80),
    Size(70, 70),
    Size(100, 100),
    Size(70, 70),
  ];

  GroundingLevel get currentLevel => groundingLevels[currentLevelIndex];

  void onItemTap(int itemIndex) async {
    if (_isTransitioning || isCompleted) return;

    final item = groundingItems[itemIndex];

    // Проверяем, доступен ли предмет на текущем уровне
    if (!currentLevel.availableItems.contains(itemIndex)) {
      setState(() {
        activeText = "Этот предмет не подходит для чувства '${currentLevel.sense}'";
      });
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted && activeText.startsWith("Этот предмет не подходит")) {
          setState(() => activeText = "");
        }
      });
      return;
    }

    // Проверяем, не найден ли уже этот предмет
    if (foundItemIds.contains(item.id)) {
      setState(() {
        activeText = "Этот предмет уже найден!";
      });
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted && activeText == "Этот предмет уже найден!") {
          setState(() => activeText = "");
        }
      });
      return;
    }

    // Проверяем, не выполнено ли уже задание уровня
    if (foundItemIds.length >= currentLevel.requiredCount) return;

    // Находим предмет
    setState(() {
      selectedItemId = item.id;
      activeText = item.getTextForLevel(currentLevelIndex);
      foundItemIds.add(item.id);
    });

    // 🔇 Звук полностью убран - ничего не воспроизводим

    // Проверяем, выполнен ли уровень
    if (foundItemIds.length >= currentLevel.requiredCount) {
      await completeLevel();
    }
  }
  Future<void> completeLevel() async {
    _isTransitioning = true;

    setState(() {
      activeText = "${currentLevel.description} выполнено! 🎉";
      selectedItemId = null;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    if (currentLevelIndex < groundingLevels.length - 1) {
      // Переход на следующий уровень
      setState(() {
        currentLevelIndex++;
        foundItemIds.clear();
        selectedItemId = null;
        _isTransitioning = false;
        activeText = groundingLevels[currentLevelIndex].description;
      });

      // Скрываем сообщение через 4 секунды
      Future.delayed(const Duration(seconds: 4), () {
        if (mounted && activeText == groundingLevels[currentLevelIndex].description) {
          setState(() => activeText = "");
        }
      });
    } else {
      // Вся практика завершена
      setState(() {
        isCompleted = true;
        _isTransitioning = false;
        activeText = "Практика 5-4-3-2-1 завершена!\nОтличная работа! 🌟";
      });
    }
  }

  void restartPractice() {
    setState(() {
      currentLevelIndex = 0;
      foundItemIds.clear();
      selectedItemId = null;
      activeText = groundingLevels[0].description;
      isCompleted = false;
      _isTransitioning = false;
    });

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted && activeText == groundingLevels[0].description) {
        setState(() => activeText = "");
      }
    });
  }

  Color getDebugColor(int itemIndex) {
    final item = groundingItems[itemIndex];

    // Недоступные предметы на этом уровне
    if (!currentLevel.availableItems.contains(itemIndex)) {
      return Colors.grey.withOpacity(0.3);
    }

    // Практика завершена или переход между уровнями
    if (isCompleted || _isTransitioning) {
      return Colors.purple.withOpacity(0.3);
    }

    // Уже найденные предметы
    if (foundItemIds.contains(item.id)) {
      return Colors.green.withOpacity(0.7);
    }

    // Доступные для выбора предметы
    return Colors.blue.withOpacity(0.5);
  }

  bool isItemActive(int itemIndex) {
    if (_isTransitioning || isCompleted) return false;

    final item = groundingItems[itemIndex];

    if (!currentLevel.availableItems.contains(itemIndex)) return false;
    if (foundItemIds.contains(item.id)) return false;
    if (foundItemIds.length >= currentLevel.requiredCount) return false;

    return true;
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Техника 5-4-3-2-1"),
        actions: [
          IconButton(
            icon: Icon(debugMode ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() => debugMode = !debugMode),
          ),
          if (isCompleted)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: restartPractice,
              tooltip: "Начать заново",
            ),
        ],
      ),
      body: Stack(
        children: [
          // Фон
          Positioned.fill(
            child: Image.asset("assets/images/Background.JPG", fit: BoxFit.cover),
          ),

          // Прогресс уровня
          Positioned(
            top: 70,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    isCompleted ? "Практика завершена" : currentLevel.title,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: isCompleted
                        ? 1.0
                        : foundItemIds.length / currentLevel.requiredCount,
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isCompleted || foundItemIds.length >= currentLevel.requiredCount
                          ? Colors.purple
                          : Colors.purple,
                    ),
                  ),
                  Text(
                    isCompleted
                        ? "Готово!"
                        : "${foundItemIds.length}/${currentLevel.requiredCount}",
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),

          // Зоны клика
          for (int i = 0; i < groundingItems.length; i++)
            Positioned(
              left: buttonPositions[i].dx,
              top: buttonPositions[i].dy,
              width: buttonSizes[i].width,
              height: buttonSizes[i].height,
              child: GestureDetector(
                onTap: () => isItemActive(i) ? onItemTap(i) : null,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: debugMode ? getDebugColor(i) : Colors.transparent,
                    border: debugMode && isItemActive(i)
                        ? Border.all(color: Color(0xFF3E2C4A), width: 2)
                        : null,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: debugMode
                      ? Text(
                    groundingItems[i].id,
                    style: TextStyle(
                      color: currentLevel.availableItems.contains(i)
                          ? Colors.white
                          : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  )
                      : null,
                ),
              ),
            ),

          // Увеличенный выбранный предмет
          if (selectedItemId != null)
            Center(
              child: AnimatedScale(
                scale: 1.5,
                duration: const Duration(milliseconds: 300),
                child: Image.asset(
                  groundingItems.firstWhere((item) => item.id == selectedItemId).image,
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ),
            ),

          // Задание уровня сверху
          // Задание уровня сверху (исправленная версия)
          if (!isCompleted &&
              activeText.isEmpty &&
              !_isTransitioning &&
              foundItemIds.length < currentLevel.requiredCount)
            Positioned(
              top: 120,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFF3E2C4A), width: 2),
                ),
                child: Column(
                  children: [
                    Text(
                      currentLevel.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentLevel.description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Добавлена строка с чувством
                    Text(
                      'Используй чувство: ${currentLevel.sense}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF3E2C4A),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Временные сообщения снизу
          if (activeText.isNotEmpty)
            Positioned(
              left: 16,
              right: 16,
              bottom: 32,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: 1.0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Color(0xFF3E2C4A), width: 2),
                  ),
                  child: Text(
                    activeText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}