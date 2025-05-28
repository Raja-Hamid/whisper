import 'package:flutter/material.dart';

class MessageOptionsSheet extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const MessageOptionsSheet({
    super.key,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onEdit != null)
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                onEdit?.call();
              },
            ),
          if (onDelete != null)
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red,),
              title: const Text('Delete'),
              onTap: () {
                Navigator.pop(context);
                onDelete?.call();
              },
            ),
        ],
      ),
    );
  }
}
