import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Телефон доверия — экран с номерами помощи для Казахстана
class HelplineScreen extends StatelessWidget {
  const HelplineScreen({Key? key}) : super(key: key);

  static const _lines = [
    _HelplineItem(
      name: 'Единый контакт-центр (семья, женщины, дети)',
      number: '111',
      description: 'Круглосуточно, бесплатно. Психологическая помощь, защита от насилия, буллинга. Работает по принципу «здесь и сейчас». [citation:1][citation:5][citation:6]',
    ),
    _HelplineItem(
      name: 'Единая психологическая служба',
      number: '150',
      description: 'Круглосуточная психологическая поддержка для всех групп населения, включая детей и подростков. [citation:1][citation:10]',
    ),
    _HelplineItem(
      name: 'WhatsApp психологическая поддержка',
      number: '+7 708 10 608 10',
      description: 'Единая психологическая служба. Можно написать в WhatsApp. [citation:10]',
    ),
    _HelplineItem(
      name: 'Call-центр психологической поддержки',
      number: '3580',
      description: 'Для любых групп населения (короткий номер с мобильного). [citation:1]',
    ),
    _HelplineItem(
      name: 'Антикоррупционная служба',
      number: '1424',
      description: 'Сообщить о коррупции или неправомерных действиях должностных лиц. [citation:2]',
    ),
    _HelplineItem(
      name: 'Экстренные службы',
      number: '112',
      description: 'Если ситуация срочная и опасная для жизни. [citation:3]',
    ),
    _HelplineItem(
      name: 'Медицинский центр психологического здоровья (Алматы)',
      number: '54-46-03',
      description: 'Психологическая помощь в Алматы. [citation:1]',
    ),
    _HelplineItem(
      name: 'Городской центр психического здоровья (Астана)',
      number: '8 (7172) 27-38-28',
      description: 'Круглосуточная помощь в Астане. [citation:10]',
    ),
    _HelplineItem(
      name: 'Telegram бот психологической поддержки',
      number: '@Mental_SupportBot',
      description: 'Анонимная поддержка в Telegram. [citation:1]',
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
                    'Если вам нужна срочная поддержка — позвоните. Все звонки бесплатны и анонимны. В Казахстане действуют круглосуточные службы психологической помощи.',
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