
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/team.dart';

class TeamCard extends StatelessWidget {
  final Team team;
  final VoidCallback? onEdit; // Nullable
  final VoidCallback? onDelete; // Nullable

  TeamCard({
    required this.team,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        title: Text(team.name),
        subtitle: Text(team.role),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onEdit != null)
              IconButton(icon: Icon(Icons.edit), onPressed: onEdit),
            if (onDelete != null)
              IconButton(icon: Icon(Icons.delete), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}