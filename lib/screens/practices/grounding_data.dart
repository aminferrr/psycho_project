// grounding_data.dart
class GroundingItem {
  final String id;
  final String image;
  final String touchText;    // для уровня 5: потрогать
  final String seeText;      // для уровня 4: увидеть
  final String hearText;     // для уровня 3: услышать
  final String smellText;    // для уровня 2: понюхать
  final String tasteText;    // для уровня 1: съесть
  final String sound;

  GroundingItem({
    required this.id,
    required this.image,
    required this.touchText,
    required this.seeText,
    required this.hearText,
    required this.smellText,
    required this.tasteText,
    required this.sound,
  });

  String getTextForLevel(int level) {
    switch (level) {
      case 0: return touchText;
      case 1: return seeText;
      case 2: return hearText;
      case 3: return smellText;
      case 4: return tasteText;
      default: return touchText;
    }
  }
}

final List<GroundingItem> groundingItems = [
  GroundingItem(
    id: "0",
    image: "assets/images/book.png",
    touchText: "Ты ощущаешь гладкие страницы книги 📖",
    seeText: "Ты видишь книгу с красивой обложкой 📖",
    hearText: "Ты слышишь шелест переворачиваемых страниц 📖",
    smellText: "Ты чувствуешь запах старой бумаги и чернил 📖",
    tasteText: "Ты представляешь вкус знаний (не ешь книги!) 📖",
    sound: "sounds/book.mp3",
  ),
  GroundingItem(
    id: "1",
    image: "assets/images/coffe.png",
    touchText: "Ты держишь теплую чашку кофе в руках ☕",
    seeText: "Ты видишь чашку ароматного кофе ☕",
    hearText: "Ты слышишь бульканье завариваемого кофе ☕",
    smellText: "Ты чувствуешь насыщенный аромат свежего кофе ☕",
    tasteText: "Ты пробуешь горьковатый вкус кофе с нотками карамели ☕",
    sound: "sounds/coffe.mp3",
  ),
  GroundingItem(
    id: "2",
    image: "assets/images/iceland.png",
    touchText: "Ты ощущаешь прохладу от изображения льда 🏔️",
    seeText: "Ты видишь величественные ледники Исландии 🏔️",
    hearText: "Ты слышишь шум водопада с фотографии 🏔️",
    smellText: "Ты чувствуешь запах свежего горного воздуха 🏔️",
    tasteText: "Ты представляешь вкус чистой ледниковой воды 🏔️",
    sound: "sounds/iceland.mp3",
  ),
  GroundingItem(
    id: "3",
    image: "assets/images/lamp.png",
    touchText: "Ты касаешься теплого абажура лампы 💡",
    seeText: "Ты видишь мягкий свет от лампы 💡",
    hearText: "Ты слышишь тихое гудение лампы 💡",
    smellText: "Ты чувствуешь запах нагретой пыли на лампе 💡",
    tasteText: "Ты представляешь, как свет 'вкусно' освещает комнату 💡",
    sound: "sounds/lamp.mp3",
  ),
  GroundingItem(
    id: "4",
    image: "assets/images/picture.png",
    touchText: "Ты проводишь пальцем по рельефу картины 🎨",
    seeText: "Ты рассматриваешь яркие цвета на картине 🎨",
    hearText: "Ты представляешь звуки, изображенные на картине 🎨",
    smellText: "Ты чувствуешь запах краски и холста 🎨",
    tasteText: "Ты представляешь вкус вдохновения от искусства 🎨",
    sound: "sounds/picture.mp3",
  ),
  GroundingItem(
    id: "5",
    image: "assets/images/picture2.png",
    touchText: "Ты ощущаешь текстуру рамы картины 🖼️",
    seeText: "Ты видишь детали второй картины 🖼️",
    hearText: "Ты слышишь тишину, которую передает картина 🖼️",
    smellText: "Ты чувствуешь запах дерева от рамы 🖼️",
    tasteText: "Ты представляешь вкус эстетического удовольствия 🖼️",
    sound: "sounds/picture2.mp3",
  ),
  GroundingItem(
    id: "6",
    image: "assets/images/pillow.png",
    touchText: "Ты сжимаешь мягкую подушку в руках 🛏️",
    seeText: "Ты видишь пушистую подушку на диване 🛏️",
    hearText: "Ты слышишь звук, когда бьешь по подушке 🛏️",
    smellText: "Ты чувствуешь запах чистого постельного белья 🛏️",
    tasteText: "Ты представляешь, как было бы уютно её 'попробовать' 🛏️",
    sound: "sounds/pillow.mp3",
  ),
  GroundingItem(
    id: "7",
    image: "assets/images/plant.png",
    touchText: "Ты трогаешь прохладные листья растения 🌿",
    seeText: "Ты видишь зеленые листья растения 🌿",
    hearText: "Ты слышишь шелест листьев растения 🌿",
    smellText: "Ты чувствуешь свежий запах зелени 🌿",
    tasteText: "Ты представляешь вкус свежей зелени (если это съедобное растение) 🌿",
    sound: "sounds/plant.mp3",
  ),
  GroundingItem(
    id: "8",
    image: "assets/images/dog.png",
    touchText: "Ты гладишь мягкую шерсть собаки 🐶",
    seeText: "Ты видишь веселую собаку на картине 🐶",
    hearText: "Ты слышишь лай и виляние хвостом собаки 🐶",
    smellText: "Ты чувствуешь запах собачьей шерсти 🐶",
    tasteText: "Ты представляешь вкус собачьего печенья (для собаки!) 🐶",
    sound: "sounds/dog.mp3",
  ),
  GroundingItem(
    id: "9",
    image: "assets/images/tablelamp.png",
    touchText: "Ты включаешь/выключаешь настольную лампу 🛋️",
    seeText: "Ты видишь свет от настольной лампы 🛋️",
    hearText: "Ты слышишь щелчок выключателя лампы 🛋️",
    smellText: "Ты чувствуешь запах дерева от основания лампы 🛋️",
    tasteText: "Ты представляешь, как свет 'освещает' твои мысли 🛋️",
    sound: "sounds/tablelamp.mp3",
  ),
];

// Определяем, какие предметы подходят для каждого чувства
class GroundingLevel {
  final int level;
  final String title;
  final String description;
  final int requiredCount;
  final List<int> availableItems; // индексы предметов, доступных на этом уровне
  final String sense;

  GroundingLevel({
    required this.level,
    required this.title,
    required this.description,
    required this.requiredCount,
    required this.availableItems,
    required this.sense,
  });
}

// Правильное распределение предметов по уровням
final List<GroundingLevel> groundingLevels = [
  GroundingLevel(
    level: 1,
    title: "Уровень 1: 5 предметов",
    description: "Найди 5 предметов, которые можно ПОТРОГАТЬ",
    requiredCount: 5,
    availableItems: [0, 1, 3, 4, 5, 6, 7, 8], // Книгу, кофе, лампу, картины, подушку, растение, собаку можно потрогать
    sense: "потрогать",
  ),
  GroundingLevel(
    level: 2,
    title: "Уровень 2: 4 предмета",
    description: "Найди 4 предмета, которые можно УВИДЕТЬ",
    requiredCount: 4,
    availableItems: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], // Все предметы можно увидеть
    sense: "увидеть",
  ),
  GroundingLevel(
    level: 3,
    title: "Уровень 3: 3 предмета",
    description: "Найди 3 предмета, которые можно УСЛЫШАТЬ",
    requiredCount: 3,
    availableItems: [0, 1, 2, 3, 5, 6, 7, 8], // Книга (шелест), кофе (бульканье), Исландия (шум водопада), лампа (гудит), картина (представить), подушка (звук), растение (шелест), собака (лает)
    sense: "услышать",
  ),
  GroundingLevel(
    level: 4,
    title: "Уровень 4: 2 предмета",
    description: "Найди 2 предмета, которые можно ПОНЮХАТЬ",
    requiredCount: 2,
    availableItems: [0, 1, 2, 3, 4, 6, 7, 8], // Книга (запах бумаги), кофе (аромат), Исландия (горный воздух), лампа (нагретая пыль), картина (краска), подушка (белье), растение (зелень), собака (шерсть)
    sense: "понюхать",
  ),
  GroundingLevel(
    level: 5,
    title: "Уровень 5: 1 предмет",
    description: "Найди 1 предмет, который можно СЪЕСТЬ (или представить вкус)",
    requiredCount: 1,
    availableItems: [1, 2], // Только кофе и Исландия (воду) можно представить вкус
    sense: "съесть",
  ),
];