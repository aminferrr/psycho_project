import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/volunteer_profile_model.dart';
import '../../repositories/volunteer_repository.dart';
import '../../widgets/loading_indicator.dart';

class VolunteerApplicationsScreen extends StatefulWidget {
  const VolunteerApplicationsScreen({Key? key}) : super(key: key);

  @override
  _VolunteerApplicationsScreenState createState() => _VolunteerApplicationsScreenState();
}

class _VolunteerApplicationsScreenState extends State<VolunteerApplicationsScreen> {
  @override
  Widget build(BuildContext context) {
    final volunteerRepo = Provider.of<VolunteerRepository>(context);

    return StreamBuilder<List<VolunteerProfile>>(
      stream: volunteerRepo.getPendingApplications(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingIndicator();
        }

        if (snapshot.hasError) {
          return Center(child: Text('Ошибка: ${snapshot.error}'));
        }

        final applications = snapshot.data ?? [];

        if (applications.isEmpty) {
          return const Center(
            child: Text('Нет новых заявок'),
          );
        }

        return ListView.builder(
          itemCount: applications.length,
          itemBuilder: (context, index) {
            final app = applications[index];
            return _buildApplicationCard(app);
          },
        );
      },
    );
  }

  Widget _buildApplicationCard(VolunteerProfile app) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange,
          child: Text(
            app.fullName[0].toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(app.fullName),
        subtitle: Text('${app.age} лет • ${app.specialization}'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Образование', app.education),
                _buildInfoRow('Опыт', app.experience),
                _buildInfoRow('Мотивация', app.motivation),
                if (app.organization != null)
                  _buildInfoRow('Организация', app.organization!),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _approveApplication(app),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text('Одобрить'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _rejectApplication(app),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Отклонить'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 2),
          Text(value),
        ],
      ),
    );
  }

  void _approveApplication(VolunteerProfile app) async {
    final repo = Provider.of<VolunteerRepository>(context, listen: false);
    await repo.approveApplication(app.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Заявка ${app.fullName} одобрена')),
    );
  }

  void _rejectApplication(VolunteerProfile app) async {
    final repo = Provider.of<VolunteerRepository>(context, listen: false);
    await repo.rejectApplication(app.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Заявка ${app.fullName} отклонена')),
    );
  }
}