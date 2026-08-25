import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../models.dart';
import '../theme.dart';
import 'chat_view.dart';

class MessagesView extends StatelessWidget {
  const MessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.vtBg : const Color(0xFFf5f5f0);
    final card = isDark ? AppColors.vtCard : Colors.white;
    final text = isDark ? AppColors.vtText : const Color(0xFF333333);
    final muted = AppColors.vtMuted;

    return Row(
      children: [
        // 会话列表
        Container(
          width: 260,
          color: card,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('消息', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: text)),
              ),
              Expanded(
                child: ListView(
                  children: [
                    // 全局大厅
                    _sessionItem(
                      context,
                      icon: Icons.public,
                      name: app.hallName,
                      subtitle: _lastMsg(app.globalMessages),
                      selected: app.currentRoom?.type == 'global',
                      onTap: () {
                        app.currentRoom = Room('global', '', app.hallName);
                      },
                    ),
                    // 私聊
                    ...app.friends.map((f) => _sessionItem(
                          context,
                          icon: Icons.person,
                          name: f.username,
                          subtitle: _lastMsg(app.dmMessages[app.dmRoomKey(app.currentUserId, f.id)] ?? []),
                          online: app.isOnline(f.id),
                          selected: app.currentRoom?.type == 'dm' && app.currentRoom?.id == f.id,
                          onTap: () {
                            app.currentRoom = Room('dm', f.id, f.username);
                          },
                        )),
                    // 群聊
                    ...app.groups.map((g) => _sessionItem(
                          context,
                          icon: Icons.group,
                          name: g.name,
                          subtitle: _lastMsg(app.groupMessages[g.id] ?? []),
                          selected: app.currentRoom?.type == 'group' && app.currentRoom?.id == g.id,
                          onTap: () {
                            app.currentRoom = Room('group', g.id, g.name);
                          },
                        )),
                    if (app.friends.isEmpty && app.groups.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text('暂无会话', style: TextStyle(color: muted)),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // 聊天窗口
        Expanded(
          child: app.currentRoom == null
              ? Center(child: Text('选择一个会话开始聊天', style: TextStyle(color: muted)))
              : ChatView(room: app.currentRoom!),
        ),
      ],
    );
  }

  String _lastMsg(List<ChatMessage> msgs) {
    if (msgs.isEmpty) return '';
    final last = msgs.last;
    final prefix = last.isFromMe ? '我: ' : '';
    return '$prefix${last.content.isEmpty ? '[图片]' : last.content}';
  }

  Widget _sessionItem(
    BuildContext context, {
    required IconData icon,
    required String name,
    required String subtitle,
    bool online = false,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = isDark ? AppColors.vtText : const Color(0xFF333333);
    final muted = AppColors.vtMuted;
    return InkWell(
      onTap: onTap,
      child: Container(
        color: selected ? AppColors.vtAccent.withOpacity(0.15) : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: selected ? AppColors.vtAccent : AppColors.vtBorder,
                  child: Icon(icon, size: 18, color: text),
                ),
                if (online)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 8, height: 8,
                      decoration: BoxDecoration(color: AppColors.vtGreen, shape: BoxShape.circle, border: Border.all(color: text, width: 1)),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14, color: text, fontWeight: FontWeight.w500)),
                  if (subtitle.isNotEmpty)
                    Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: muted)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
