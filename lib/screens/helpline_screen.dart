import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Телефон доверия — экран с номерами помощи
class HelplineScreen extends StatelessWidget {
  const HelplineScreen({Key? key}) : super(key: key);

  static const _lines = [
    _HelplineItem(
      name: 'Общероссийский телефон доверия',
      number: '8-800-2000-122',
      description: 'Бесплатно, анонимно, 24/7. Дети, подростки и родители.',
    ),
    _HelplineItem(
      name: 'Телефон доверия для детей и подростков',
      number: '8-800-2000-122',
      description: 'Единый номер по России.',
    ),
    _HelplineItem(
      name: 'Психологическая помощь (МЧС)',
      number: '8-495-989-50-50',
      description: 'Круглосуточная психологическая помощь.',
    ),
    _HelplineItem(
      name: 'Кризисная линия (Ярославль)',
      number: '8-800-100-35-50',
      description: 'Анонимная помощь в кризисных ситуациях.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Телефон доверия'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.phone_in_talk, size: 48, color: Colors.deepPurple),
                  SizedBox(height: 12),
                  Text(
                    'Если вам нужна срочная поддержка — позвоните. Разговор анонимен.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ..._lines.map((item) => _buildTile(context, item)),
        ],
      ),
    );
  }

  Widget _buildTile(BuildContext context, _HelplineItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple[100],
          child: const Icon(Icons.phone, color: Colors.deepPurple),
        ),
        title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(item.description, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
            const SizedBox(height: 8),
            SelectableText(
              item.number,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
          ],
        ),
        isThreeLine: true,
        trailing: IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: item.number));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Скопировано: ${item.number}')),
            );
          },
        ),
      ),
    );
  }
}

class _HelplineItem {
  final String name;
  final String number;
  final String description;
  const _HelplineItem({required this.name, required this.number, required this.description});
}
