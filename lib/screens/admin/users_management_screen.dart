import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../repositories/admin_repository.dart';
import '../../widgets/loading_indicator.dart';

class UsersManagementScreen extends StatefulWidget {
  const UsersManagementScreen({Key? key}) : super(key: key);

  @override
  _UsersManagementScreenState createState() => _UsersManagementScreenState();
}

class _UsersManagementScreenState extends State<UsersManagementScreen> {
  UserRole? _selectedRole;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final adminRepo = Provider.of<AdminRepository>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Поиск пользователей...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
                ),
              ),
              const SizedBox(width: 8),
              DropdownButton<UserRole?>(
                value: _selectedRole,
                hint: const Text('Все роли'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('Все')),
                  ...UserRole.values.map((role) => DropdownMenuItem(
                    value: role,
                    child: Text(role.name),
                  )),
                ],
                onChanged: (value) => setState(() => _selectedRole = value),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<UserModel>>(
            stream: adminRepo.getAllUsers(role: _selectedRole),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const LoadingIndicator();
              }

              var users = snapshot.data!;

              if (_searchQuery.isNotEmpty) {
                users = users.where((u) =>
                u.email.toLowerCase().contains(_searchQuery) ||
                    (u.displayName?.toLowerCase().contains(_searchQuery) ?? false)
                ).toList();
              }

              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return _buildUserCard(user);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUserCard(UserModel user) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: user.photoURL != null
              ? NetworkImage(user.photoURL!)
              : null,
          child: user.photoURL == null
              ? Text(user.email[0].toUpperCase())
              : null,
        ),
        title: Text(user.displayName ?? user.email),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.email),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getRoleColor(user.role),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    user.role.name,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                if (user.isApproved) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.check_circle, color: Colors.green, size: 16),
                ],
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'block', child: Text('Заблокировать')),
            const PopupMenuItem(value: 'make_admin', child: Text('Сделать админом')),
            const PopupMenuItem(value: 'view_stats', child: Text('Статистика')),
          ],
          onSelected: (value) {
            if (value == 'block') {
              _showBlockDialog(user);
            }
          },
        ),
        onTap: () {
          // Открыть детали пользователя
        },
      ),
    );
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Colors.red;
      case UserRole.psychologist:
        return Colors.green;
      case UserRole.volunteer:
        return Colors.orange;
      case UserRole.user:
        return Colors.blue;
    }
  }

  void _showBlockDialog(UserModel user) {
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Заблокировать ${user.displayName ?? user.email}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Укажите причину блокировки:'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                hintText: 'Причина...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              // Блокировка
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Заблокировать'),
          ),
        ],
      ),
    );
  }
}