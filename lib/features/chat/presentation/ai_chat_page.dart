import 'package:baroallgi/core/const/const_color.dart';
import 'package:baroallgi/core/const/const_size.dart';
import 'package:baroallgi/core/ui/layout/DefaultPageLayout.dart';
import 'package:baroallgi/features/chat/models/chat_room_model.dart';
import 'package:baroallgi/features/chat/provider/chat_rooms_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AiChatPage extends ConsumerWidget {
  static String get routeName => 'ai_chat';

  const AiChatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rooms = ref.watch(chatRoomsProvider);

    return DefaultLayout(
      title: const Text('대화'),
      useBackBtn: true,
      padding: EdgeInsets.zero,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openNewRoom(context, ref),
        backgroundColor: AppColors.primaryNavy,
        foregroundColor: AppColors.surface,
        icon: const Icon(Icons.add_comment_outlined),
        label: const Text('새 대화'),
      ),
      child: rooms.isEmpty
          ? const _EmptyRooms()
          : ListView.separated(
              padding: const EdgeInsets.only(bottom: 88),
              itemCount: rooms.length,
              separatorBuilder: (_, _) => const Divider(
                height: 1,
                color: AppColors.divider,
              ),
              itemBuilder: (context, index) {
                final room = rooms[index];
                return _SwipeDeleteTile(
                  key: ValueKey(room.id),
                  onDelete: () => _deleteRoom(context, ref, room.id),
                  child: _RoomTile(
                    room: room,
                    onTap: () => context.push('/ai_chat/room/${room.id}'),
                  ),
                );
              },
            ),
    );
  }

  void _openNewRoom(BuildContext context, WidgetRef ref) {
    final id = ref.read(chatRoomsProvider.notifier).create();
    context.push('/ai_chat/room/$id');
  }

  Future<void> _deleteRoom(
    BuildContext context,
    WidgetRef ref,
    String roomId,
  ) async {
    try {
      await ref.read(chatRoomsProvider.notifier).delete(roomId);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('대화를 삭제하지 못했어요.')),
      );
    }
  }
}

class _EmptyRooms extends StatelessWidget {
  const _EmptyRooms();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.s40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.forum_outlined,
              size: 48,
              color: AppColors.primaryNavy,
            ),
            SizedBox(height: AppSizes.normal),
            Text(
              '아직 대화가 없어요',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: AppSizes.fontBig,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '새 대화를 누르면 채팅방이 만들어집니다.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: AppSizes.fontNormal,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SwipeDeleteTile extends StatefulWidget {
  final Future<void> Function() onDelete;
  final Widget child;

  const _SwipeDeleteTile({
    super.key,
    required this.onDelete,
    required this.child,
  });

  @override
  State<_SwipeDeleteTile> createState() => _SwipeDeleteTileState();
}

class _SwipeDeleteTileState extends State<_SwipeDeleteTile>
    with SingleTickerProviderStateMixin {
  static const _actionWidth = 88.0;

  late final AnimationController _controller;
  bool _deleting = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    _controller.stop();
    final next = _controller.value - details.delta.dx / _actionWidth;
    _controller.value = next.clamp(0.0, 1.0);
  }

  void _onDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    final open = velocity < -400 || (velocity < 400 && _controller.value > 0.4);
    _controller.animateTo(open ? 1 : 0);
  }

  Future<void> _delete() async {
    if (_deleting) return;
    setState(() => _deleting = true);
    await widget.onDelete();
    if (!mounted) return;
    setState(() => _deleting = false);
    _controller.animateTo(0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: _actionWidth,
                  child: Material(
                    color: AppColors.alertRed,
                    child: InkWell(
                      onTap: _deleting ? null : _delete,
                      child: _deleting
                          ? const Center(
                              child: SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.surface,
                                ),
                              ),
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.delete_outline,
                                  color: AppColors.surface,
                                ),
                                SizedBox(height: 2),
                                Text(
                                  '삭제',
                                  style: TextStyle(
                                    color: AppColors.surface,
                                    fontSize: AppSizes.fontNormal,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onHorizontalDragUpdate: _onDragUpdate,
              onHorizontalDragEnd: _onDragEnd,
              child: Transform.translate(
                offset: Offset(-_actionWidth * _controller.value, 0),
                child: child,
              ),
            ),
          ],
        );
      },
      child: ColoredBox(
        color: AppColors.surface,
        child: widget.child,
      ),
    );
  }
}

class _RoomTile extends StatelessWidget {
  final ChatRoomModel room;
  final VoidCallback onTap;

  const _RoomTile({required this.room, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final preview = room.lastMessageText?.trim().isNotEmpty == true
        ? room.lastMessageText!
        : room.messages.isEmpty
            ? '아직 메시지가 없어요'
            : room.messages.last.text;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.normal,
        vertical: 4,
      ),
      title: Text(
        room.title ?? '새 대화',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: AppSizes.fontBig,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        preview,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: AppSizes.fontNormal,
        ),
      ),
      trailing: Text(
        _formatUpdatedAt(room.updatedAt),
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: AppSizes.fontNormal,
        ),
      ),
      onTap: onTap,
    );
  }

  String _formatUpdatedAt(DateTime time) {
    final now = DateTime.now();
    final sameDay =
        now.year == time.year && now.month == time.month && now.day == time.day;
    if (!sameDay) return '${time.month}월 ${time.day}일';

    final hour = time.hour;
    final period = hour < 12 ? '오전' : '오후';
    final clockHour = hour % 12 == 0 ? 12 : hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    return '$period $clockHour:$minute';
  }
}
