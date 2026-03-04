import 'package:flutter/material.dart';
import 'breathing_practice_screen.dart';
import 'grounding_54321_screen.dart';

/// Экран списка анти‑тревожных техник
class PracticesListScreen extends StatelessWidget {
  const PracticesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pastelCards = _techniques;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Антитревожные техники'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pastelCards.length,
        itemBuilder: (context, index) {
          final t = pastelCards[index];
          return _PracticeCard(
            title: t.title,
            subtitle: t.subtitle,
            icon: t.icon,
            color: t.color,
            onTap: () {
              // Для 5‑й и 7‑й техник открываем существующие интерактивные экраны
              if (t.id == 5) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Grounding54321Screen(),
                  ),
                );
              } else if (t.id == 7) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BreathingPracticeScreen(),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TechniqueDetailScreen(technique: t),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}

/// Карточка техники в пастельных цветах
class _PracticeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _PracticeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: color.withOpacity(0.25),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

/// Экран с подробным описанием техники + маленький «тест/размышление»
class TechniqueDetailScreen extends StatefulWidget {
  final _Technique technique;
  const TechniqueDetailScreen({super.key, required this.technique});

  @override
  State<TechniqueDetailScreen> createState() => _TechniqueDetailScreenState();
}

class _TechniqueDetailScreenState extends State<TechniqueDetailScreen> {
  final TextEditingController _journalController = TextEditingController();
  int? _score;
  final Map<int, int> _answers = {}; // questionIndex -> optionIndex

  @override
  void dispose() {
    _journalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.technique;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: t.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(t.icon, color: t.color),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      t.subtitle,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.longText,
                      style: const TextStyle(fontSize: 15, height: 1.4),
                    ),
                    const SizedBox(height: 16),
                    if (t.id == 9 || t.id == 13) _buildTestBlock(context, t.id),
                    if (t.journalPrompt != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Мини‑практика / дневник',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        t.journalPrompt!,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _journalController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: 'Запишите свои мысли или ответы здесь...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Отлично! Вы сделали шаг навстречу себе.'),
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Завершить технику'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestBlock(BuildContext context, int id) {
    final questions = id == 9
        ? <String>[
            'Насколько часто вы ловите себя на катастрофических мысллях?',
            'Насколько легко вам остановиться, когда мысль «раскручивается»?',
          ]
        : <String>[
            'Насколько отчётливо вы ощущаете границы своего тела?',
            'Насколько спокойно вы чувствуете себя среди других людей?',
          ];

    final options = const [
      'Почти никогда / очень редко',
      'Иногда',
      'Часто',
      'Почти всегда',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Небольшой само‑тест',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        ...List.generate(questions.length, (qIndex) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                questions[qIndex],
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              ...List.generate(options.length, (oIndex) {
                return RadioListTile<int>(
                  dense: true,
                  title: Text(options[oIndex]),
                  value: oIndex,
                  groupValue: _answers[qIndex],
                  onChanged: (v) {
                    setState(() {
                      _answers[qIndex] = v ?? 0;
                    });
                  },
                );
              }),
              const SizedBox(height: 8),
            ],
          );
        }),
        if (_score != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Ваш балл: $_score из ${questions.length * 3}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              if (_answers.length != questions.length) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ответьте на все вопросы теста')),
                );
                return;
              }
              final total = _answers.values.fold<int>(0, (sum, v) => sum + v);
              setState(() {
                _score = total;
              });
            },
            child: const Text('Подсчитать результат'),
          ),
        ),
      ],
    );
  }
}

class _Technique {
  final int id;
  final String title;
  final String subtitle;
  final String longText;
  final String? journalPrompt;
  final IconData icon;
  final Color color;

  const _Technique({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.longText,
    required this.icon,
    required this.color,
    this.journalPrompt,
  });
}

// 15 анти‑тревожных техник в пастельных цветах
const _techniques = <_Technique>[
  _Technique(
    id: 1,
    title: '1. Здесь-и-сейчас с деталями',
    subtitle: 'Осознанное описание окружения, чтобы вытеснить тревожные мысли.',
    icon: Icons.visibility,
    color: Color(0xFFCE93D8),
    longText:
        'Сядьте поудобнее и начните подробно описывать то, что видите вокруг себя. Например: '
        '«Сейчас я вижу карандаш на столе. Он синий, с небольшими царапинами у основания. '
        'Рядом лежит лист, его угол загнут. Я слышу тиканье часов, каждый щелчок отдельно…». '
        'Ваша задача — максимально занять внимание нейтральными деталями, чтобы мозг перестал '
        'прокручивать тревожные прогнозы о будущем.',
    journalPrompt:
        'Опишите 5–7 деталей из текущего пространства так, как будто вы описываете фотографию человеку, который её не видит.',
  ),
  _Technique(
    id: 2,
    title: '2. Диалог с телом',
    subtitle: 'Слушаем, о чём пытается сказать телесное напряжение.',
    icon: Icons.self_improvement,
    color: Color(0xFFB39DDB),
    longText:
        'Найдите в теле точку, где тревога ощущается ярче всего: ком в горле, камень в желудке, '
        'дрожь в руках. Положите туда руку и мысленно спросите: '
        '«Если бы это ощущение могло говорить, что бы оно сказало? Какое действие оно хочет совершить?» '
        'Позвольте ему «отвечать» в виде слов, образов или желаний. Часто за симптомом стоит '
        'незавершённое действие — например, потребность сказать «нет», уйти, попросить о помощи.',
    journalPrompt:
        'Запишите: где в теле вы чаще всего чувствуете тревогу и что, по вашему ощущению, она хочет вам сказать.',
  ),
  _Technique(
    id: 3,
    title: '3. Преувеличение жеста',
    subtitle: 'Осознанно усиливаем напряжение, чтобы затем его отпустить.',
    icon: Icons.gesture,
    color: Color(0xFF80CBC4),
    longText:
        'Отследите микронапряжение: стиснутые зубы, сжатые кулаки, поджатые губы. '
        'Вместо того чтобы сразу расслаблять, на 20–30 секунд слегка усилите движение: '
        'сильнее сожмите кулаки, ещё плотнее сожмите челюсти. Затем резко отпустите. '
        'Наблюдайте, какие чувства поднимаются — это может быть злость, обида, бессилие. '
        'Так вы находите то действие или эмоцию, которое тревога держала «зажатым».',
    journalPrompt:
        'Какие жесты/напряжения вы замечаете у себя чаще всего? Что вы почувствовали, когда сознательно усилили и отпустили их?',
  ),
  _Technique(
    id: 4,
    title: '4. Пустой стул для полярностей',
    subtitle: 'Диалог Тревоги и Ресурса через два стула.',
    icon: Icons.chair_alt,
    color: Color(0xFFA5D6A7),
    longText:
        'Поставьте рядом два стула. На один «посадите» свою Тревожную часть, на другой — Ресурсную. '
        'Сядьте на стул Тревоги и вслух расскажите: чего вы боитесь, от чего она вас защищает, '
        'какой «худший сценарий» она рисует. Затем пересаживайтесь на стул Ресурса и отвечайте от его имени: '
        '«Да, это страшно, и в то же время я помню, что…» Ваша задача — позволить обоим голосам быть услышанными '
        'и найти между ними более реалистичный, поддерживающий взгляд.',
    journalPrompt:
        'Запишите, что сказала бы ваша Тревожная часть, и что на это ответила бы ваша Ресурсная часть.',
  ),
  _Technique(
    id: 5,
    title: '5. Тактильное заземление 5‑4‑3‑2‑1',
    subtitle: 'Интерактивная техника заземления (отдельный экран практики).',
    icon: Icons.filter_5,
    color: Color(0xFFFFE082),
    longText:
        'Эта техника уже реализована как отдельная интерактивная практика. '
        'Вы отмечаете 5 вещей, которые видите, 4 — которые можете потрогать, '
        '3 звука, 2 запаха и 1 вкус. Это помогает вернуть внимание в текущий момент.',
  ),
  _Technique(
    id: 6,
    title: '6. Проговаривание внутреннего процесса',
    subtitle: 'Озвучиваем вслух то, что происходит внутри.',
    icon: Icons.mic_none,
    color: Color(0xFF90CAF9),
    longText:
        'Когда тревога нарастает, начните проговаривать вслух то, что происходит: '
        '«Сейчас я чувствую, как учащается сердцебиение. Появляется мысль, что я не справлюсь. '
        'В животе скручивает. Теперь вспоминаю, что забыл позвонить…». '
        'Так вы выводите хаос наружу, создаёте дистанцию между собой и состоянием и возвращаете себе роль наблюдателя.',
    journalPrompt:
        'Попробуйте описать 5–7 предложениями свой внутренний процесс в момент тревоги так, как если бы вы смотрели со стороны.',
  ),
  _Technique(
    id: 7,
    title: '7. Дыхание напряжение–расслабление',
    subtitle: 'Управляем циклом вдох‑напряжение / выдох‑отпускание (отдельная практика).',
    icon: Icons.air,
    color: Color(0xFFB3E5FC),
    longText:
        'В этой практике вдох воспринимается как активное действие, а выдох — как полное отпускание. '
        'На вдохе вы слегка напрягаете мышцы, на выдохе позволяете телу обмякнуть. '
        'Так формируется новый опыт управляемого напряжения и расслабления, противоположный хаотичной тревоге.',
  ),
  _Technique(
    id: 8,
    title: '8. Рисование образа тревоги',
    subtitle: 'Создаём рисунок тревоги и её антипода.',
    icon: Icons.brush,
    color: Color(0xFFFFCCBC),
    longText:
        'Возьмите два листа. На первом нарисуйте абстрактный образ тревоги: цвета, линии, форму. '
        'На втором — образ её противоположности: спокойствия, опоры, уверенности. '
        'Рассмотрите оба рисунка рядом. Спросите себя: что нужно образу спокойствия, чтобы стать сильнее? '
        'Можно создать третий рисунок — интеграцию двух состояний.',
    journalPrompt:
        'Опишите словами, как выглядит ваша тревога и как выглядит её противоположность. Что помогло бы образу спокойствия усилиться?',
  ),
  _Technique(
    id: 9,
    title: '9. Раскручивание катастрофической мысли',
    subtitle: 'Доводим тревожный сценарий до абсурда и проверяем реальность.',
    icon: Icons.auto_awesome,
    color: Color(0xFFDCEDC8),
    longText:
        'Выберите пугающую мысль — например: «Я опозорюсь на выступлении». '
        'Дальше задавайте себе вопрос: «И что тогда?» и записывайте ступени: '
        '«Тогда все будут смеяться → меня уволят → я не найду работу → останусь без денег → окажусь на улице…». '
        'На 4–5 шаге часто становится заметно, насколько сценарий оторван от реальности, и тревога ослабевает.',
    journalPrompt:
        'Возьмите одну тревожную мысль и 5–7 раз задайте себе вопрос «И что тогда?». Запишите всю цепочку и отметьте, где она стала абсурдной.',
  ),
  _Technique(
    id: 10,
    title: '10. Ходьба осознанности с изменением темпа',
    subtitle: 'Меняем скорость движения, чтобы выйти из застывания.',
    icon: Icons.directions_walk,
    color: Color(0xFFF8BBD0),
    longText:
        'Пройдитесь по комнате в медленном темпе, ощущая каждый шаг: контакт стопы с полом, '
        'перекат, работу мышц. Затем плавно ускорьтесь до комфортного быстрого шага. '
        'Через минуту снова замедлитесь. Меняя темп, вы выводите тело из состояния застывания '
        'и даёте ему опыт того, что вы управляете движением и скоростью.',
    journalPrompt:
        'После упражения ответьте: какой темп ходьбы был для вас самым комфортным и что менялось в ощущениях при замедлении и ускорении?',
  ),
  _Technique(
    id: 11,
    title: '11. Неотправленное письмо о незавершённом',
    subtitle: 'Прописываем недосказанное, чтобы снизить фоновую тревогу.',
    icon: Icons.mail_outline,
    color: Color(0xFFC5CAE9),
    longText:
        'Выберите человека, с которым у вас осталось много невысказанного. Напишите ему письмо, '
        'в котором честно и подробно опишите свои чувства, ожидания, обиды или благодарность. '
        'Затем (опционально) напишите ответ от его имени — так, как вы боитесь его услышать, или так, как хотели бы. '
        'Это упражнение не обязательно отправлять — его задача в том, чтобы завершить внутренний диалог.',
    journalPrompt:
        'Начните фразу: «Мне хочется сказать тебе, что…» и продолжайте писать не меньше 10 минут, не останавливаясь.',
  ),
  _Technique(
    id: 12,
    title: '12. Контейнирование тревоги',
    subtitle: 'Мысленно создаём безопасный «контейнер» для переживаний.',
    icon: Icons.inventory_2_outlined,
    color: Color(0xFFD7CCC8),
    longText:
        'Представьте идеальный контейнер для тревоги: это может быть сундук, сейф, шкатулка. '
        'Продумайте его размер, материал, цвет, замок. Мысленно «соберите» тревогу из всего тела '
        'и поместите внутрь, говоря себе: «Я кладу тебя сюда и вернусь, когда буду готов(а) с тобой поработать». '
        'Так вы устанавливаете границу между собой и состоянием, не отрицая его.',
    journalPrompt:
        'Опишите свой контейнер: как он выглядит, где стоит и что вы чувствуете, когда помещаете туда тревогу.',
  ),
  _Technique(
    id: 13,
    title: '13. Сканирование границ',
    subtitle: 'Исследуем, где заканчиваюсь «я» и начинается пространство.',
    icon: Icons.shield_moon_outlined,
    color: Color(0xFFB2EBF2),
    longText:
        'Сядьте удобно, закройте глаза и задайте себе вопросы: '
        '«Где заканчивается моё тело и начинается пространство комнаты? '
        'Насколько далеко простирается моё личное пространство?» '
        'Представьте вокруг себя защитный кокон — плотность, цвет и форма могут быть любыми. '
        'Чётко ощущаемые границы часто снижают тревогу, связанную с ощущением небезопасности.',
    journalPrompt:
        'Нарисуйте или опишите словами свой защитный кокон. Что меняется в ощущениях, когда вы представляете его вокруг себя?',
  ),
  _Technique(
    id: 14,
    title: '14. Три стула: Тревога, Гнев, Забота',
    subtitle: 'Исследуем связь между тревогой, гневом и заботой о себе.',
    icon: Icons.chair,
    color: Color(0xFFFFF9C4),
    longText:
        'Поставьте три стула: для Тревоги («Я боюсь…»), для Гнева («Я злюсь, что…») '
        'и для Заботы о себе («Мне нужно…»). Пересаживаясь, проговаривайте вслух, что чувствует каждая часть. '
        'Часто под тревогой скрывается непрожитый гнев, а Забота о себе оказывается заглушенной. '
        'Задача техники — дать каждому голосу пространство и найти более поддерживающее решение.',
    journalPrompt:
        'Заполните три фразы: «Я боюсь, что…», «Я злюсь, что…», «Мне нужно…». Обратите внимание, какие инсайты появились.',
  ),
  _Technique(
    id: 15,
    title: '15. Благодарность тревоге',
    subtitle: 'Меняем борьбу с тревогой на диалог и признание её функции.',
    icon: Icons.favorite_border,
    color: Color(0xFFE1BEE7),
    longText:
        'Попробуйте обратиться к тревоге как к части, которая вас защищает: '
        '«Спасибо, что пытаешься меня уберечь. Я вижу, что ты работаешь на износ. '
        'Покажи мне, от какой реальной опасности ты предупреждаешь, а остальное я возьму на себя». '
        'Такой парадоксальный подход меняет отношение к тревоге: она перестаёт быть врагом и становится сигналом о потребностях.',
    journalPrompt:
        'Напишите короткое письмо благодарности своей тревоге: за что вы можете её поблагодарить и о чём попросить вести себя по‑другому.',
  ),
];

