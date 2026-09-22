import 'package:flutter/material.dart';
import '../../backend/models/sample_data.dart';
import '../theme/app_theme.dart';
import 'chat_screen.dart';
class MessagesTab extends StatelessWidget {
  const MessagesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages',
            style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w700)),
        automaticallyImplyLeading: false,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: kSampleThreads.length,
        separatorBuilder: (_, __) =>
            const Divider(height: 1, color: AppColors.divider, indent: 76),
        itemBuilder: (context, i) {
          final t = kSampleThreads[i];
          return ListTile(
            leading: const CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.selectedCardFill,
              child: Icon(Icons.person, color: AppColors.primaryNavy),
            ),
            title: Text(t.name,
                style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textDark)),
            subtitle: Text(
              t.lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: t.unread ? AppColors.textDark : AppColors.textMuted,
                fontWeight: t.unread ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(t.time, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                if (t.unread) ...[
                  const SizedBox(height: 6),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryNavy,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => ChatScreen(contactName: t.name)),
            ),
          );
        },
      ),
    );
  }
}
