import 'package:flutter/material.dart';

class QuickAction {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  QuickAction({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}

class QuickActionsCard extends StatelessWidget {
  final List<QuickAction> actions;

  const QuickActionsCard({
    super.key,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Actions rapides',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...actions.map((action) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ListTile(
                leading: Icon(action.icon),
                title: Text(action.title),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: action.onTap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                tileColor: Colors.grey.shade50,
              ),
            )),
          ],
        ),
      ),
    );
  }
}
