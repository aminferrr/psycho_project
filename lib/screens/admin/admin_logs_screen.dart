import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/admin_log_model.dart';
import '../../repositories/admin_repository.dart';
import '../../widgets/loading_indicator.dart';

class AdminLogsScreen extends StatelessWidget {
  const AdminLogsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final adminRepo = Provider.of<AdminRepository>(context);

    return StreamBuilder<List<AdminLog>>(
      stream: adminRepo.getAdminLogs(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LoadingIndicator();
        }

        final logs = snapshot.data!;

        return ListView.builder(
          itemCount: logs.length,
          itemBuilder: (context, index) {
            final log = logs[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: _getActionColor(log.actionType),
                child: Icon(_getActionIcon(log.actionType), color: Colors.white),
              ),
              title: Text(log.description),
              subtitle: Text(
                '${log.adminEmail} • ${_formatDate(log.timestamp)}',
                style: const TextStyle(fontSize: 12),
              ),
              trailing: log.metadata != null
                  ? const Icon(Icons.info_outline)
                  : null,
              onTap: () {
                if (log.metadata != null) {
                  _showMetadataDialog(context, log.metadata!);
                }
              },
            );
          },
        );
      },
    );
  }

  IconData _getActionIcon(AdminActionType type) {
    switch (type) {
      case AdminActionType.approveVolunteer:
        return Icons.check;
      case AdminActionType.rejectVolunteer:
        return Icons.close;
      case AdminActionType.blockUser:
        return Icons.block;
      case AdminActionType.unblockUser:
        return Icons.lock_open;
      case AdminActionType.deletePost:
        return Icons.delete;
      default:
        return Icons.settings;
    }
  }

  Color _getActionColor(AdminActionType type) {
    switch (type) {
      case AdminActionType.approveVolunteer:
        return Colors.green;
      case AdminActionType.rejectVolunteer:
        return Colors.red;
      case AdminActionType.blockUser:
        return Colors.orange;
      case AdminActionType.unblockUser:
        return Colors.blue;
      case AdminActionType.deletePost:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} д. назад';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ч. назад';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} мин. назад';
    } else {
      return 'только что';
    }
  }

  void _showMetadataDialog(BuildContext context, Map<String, dynamic> metadata) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Детали'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: metadata.entries.map((e) =>
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text('${e.key}: ${e.value}'),
                )
            ).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }
}