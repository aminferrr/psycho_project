import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/practice_model.dart';
import '../../repositories/practice_repository.dart';
import '../../repositories/admin_repository.dart';
import '../../widgets/loading_indicator.dart';

class PracticesManagementScreen extends StatefulWidget {
  const PracticesManagementScreen({Key? key}) : super(key: key);

  @override
  _PracticesManagementScreenState createState() => _PracticesManagementScreenState();
}

class _PracticesManagementScreenState extends State<PracticesManagementScreen> {
  @override
  Widget build(BuildContext context) {
    final practiceRepo = Provider.of<PracticeRepository>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Поиск практик...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    // Фильтрация
                  },
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => _showAddPracticeDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('Добавить'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<Practice>>(
            stream: practiceRepo.getPractices(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const LoadingIndicator();
              }

              final practices = snapshot.data!;

              return ListView.builder(
                itemCount: practices.length,
                itemBuilder: (context, index) {
                  final practice = practices[index];
                  return _buildPracticeCard(practice);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPracticeCard(Practice practice) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getCategoryColor(practice.category),
          child: Text(
            practice.title[0].toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(practice.title),
        subtitle: Text('${practice.duration} мин • ${practice.difficulty}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _showEditPracticeDialog(context, practice),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmDelete(context, practice),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPracticeDialog(BuildContext context) {
    _showPracticeDialog(context, null);
  }

  void _showEditPracticeDialog(BuildContext context, Practice practice) {
    _showPracticeDialog(context, practice);
  }

  void _showPracticeDialog(BuildContext context, Practice? practice) {
    final _formKey = GlobalKey<FormState>();
    final _titleController = TextEditingController(text: practice?.title);
    final _descriptionController = TextEditingController(text: practice?.description);
    final _durationController = TextEditingController(text: practice?.duration.toString());
    String _selectedDifficulty = practice?.difficulty ?? 'Начинающий';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(practice == null ? 'Добавить практику' : 'Редактировать практику'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Название'),
                  validator: (v) => v!.isEmpty ? 'Обязательное поле' : null,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Описание'),
                  maxLines: 3,
                  validator: (v) => v!.isEmpty ? 'Обязательное поле' : null,
                ),
                TextFormField(
                  controller: _durationController,
                  decoration: const InputDecoration(labelText: 'Длительность (мин)'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'Обязательное поле' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _selectedDifficulty,
                  decoration: const InputDecoration(labelText: 'Сложность'),
                  items: ['Начинающий', 'Средний', 'Продвинутый']
                      .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                      .toList(),
                  onChanged: (v) => _selectedDifficulty = v!,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Сохранить практику
                Navigator.pop(ctx);
              }
            },
            child: Text(practice == null ? 'Добавить' : 'Сохранить'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Practice practice) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Удалить практику'),
        content: Text('Вы уверены, что хотите удалить "${practice.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Удалить практику
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Практика "${practice.title}" удалена')),
      );
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Дыхание': return Colors.blue;
      case 'Медитация': return Colors.purple;
      case 'КПТ': return Colors.green;
      case 'Тесты': return Colors.orange;
      default: return Colors.grey;
    }
  }
}