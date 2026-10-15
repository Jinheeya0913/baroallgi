import 'package:baroallgi/core/const/const_color.dart';
import 'package:baroallgi/core/const/const_size.dart';
import 'package:baroallgi/core/ui/layout/DefaultPageLayout.dart';
import 'package:baroallgi/core/ui/widgets/base_text_field.dart';
import 'package:baroallgi/features/chat/models/chat_message_model.dart';
import 'package:baroallgi/features/chat/provider/chat_rooms_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatPage extends ConsumerStatefulWidget {
  static String get routeName => 'chat_room';

  final String roomId;

  const ChatPage({super.key, required this.roomId});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  var _canSend = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final next = _controller.text.trim().isNotEmpty;
      if (next == _canSend) return;
      setState(() => _canSend = next);
    });
    Future.microtask(() {
      ref.read(chatRoomsProvider.notifier).openRoom(widget.roomId);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send([String? text]) {
    final room = ref.read(chatRoomsProvider).where((item) {
      return item.id == widget.roomId;
    }).firstOrNull;
    if (room == null || room.isReplying) return;

    ref.read(chatRoomsProvider.notifier).send(widget.roomId, text ?? _controller.text);
    if (text != null) return;
    _controller.clear();
  }

  void _sendTest() {
    final room = ref.read(chatRoomsProvider).where((item) {
      return item.id == widget.roomId;
    }).firstOrNull;
    if (room == null || room.isReplying) return;
    ref.read(chatRoomsProvider.notifier).sendTest(widget.roomId);
  }

  Future<void> _copyAllMessages() async {
    final room = ref.read(chatRoomsProvider).where((item) {
      return item.id == widget.roomId;
    }).firstOrNull;
    if (room == null || room.messages.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('복사할 메시지가 없어요'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    final body = room.messages
        .map((message) {
          final speaker = message.role == ChatRole.user ? '나' : '바로알기';
          return '$speaker: ${message.text}';
        })
        .join('\n\n');

    await Clipboard.setData(ClipboardData(text: body));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('대화 전체를 복사했어요'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final room = ref.watch(chatRoomsProvider).where((item) {
      return item.id == widget.roomId;
    }).firstOrNull;

    ref.listen(chatRoomsProvider, (previous, next) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_scrollController.hasClients) return;
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      });
    });

    if (room == null) {
      return const DefaultLayout(
        title: Text('새 대화'),
        useBackBtn: true,
        child: Center(child: Text('대화를 찾을 수 없어요')),
      );
    }

    final messages = [
      _introMessage,
      ...room.messages,
      if (room.isReplying) _pendingMessage,
    ];

    return DefaultLayout(
      title: Text(room.title ?? '새 대화'),
      useBackBtn: true,
      padding: EdgeInsets.zero,
      actions: [
        IconButton(
          onPressed: _copyAllMessages,
          tooltip: '공유하기',
          color: AppColors.primaryNavy,
          icon: const Icon(Icons.ios_share_rounded),
        ),
      ],
      child: Column(
        children: [
          const _PreviewBanner(),
          _PromptChips(onSelect: _send, onTest: _sendTest),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.normal,
                vertical: AppSizes.normal,
              ),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return _ChatBubble(message: messages[index]);
              },
            ),
          ),
          _ChatComposer(
            controller: _controller,
            canSend: _canSend && !room.isReplying,
            onSend: _send,
          ),
        ],
      ),
    );
  }
}

final _introMessage = ChatMessageModel(
  id: 'intro',
  role: ChatRole.assistant,
  text: '어떤 내용이 궁금한가요? 소식, 광고, 문자 내용을 적어 주시면 함께 살펴볼게요.',
  createdAt: DateTime.fromMillisecondsSinceEpoch(0),
);

final _pendingMessage = ChatMessageModel(
  id: 'pending',
  role: ChatRole.assistant,
  text: '확인하고 있어요',
  createdAt: DateTime.fromMillisecondsSinceEpoch(0),
);

class _PreviewBanner extends StatelessWidget {
  const _PreviewBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.accentBlue,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.normal,
        vertical: AppSizes.s14,
      ),
      child: const Text(
        '보낸 내용을 바탕으로 맞는지 함께 살펴볼게요.',
        style: TextStyle(
          color: AppColors.primaryNavy,
          fontSize: AppSizes.fontNormal,
          height: 1.4,
        ),
      ),
    );
  }
}

class _PromptChips extends StatelessWidget {
  final ValueChanged<String> onSelect;
  final VoidCallback onTest;

  const _PromptChips({required this.onSelect, required this.onTest});

  static const _prompts = [
    '부고 문자 링크가 왔어요',
    '이 건강 정보가 맞나요?',
    '정부지원 대출 문자',
    'SNS 세일 광고가 의심돼요',
  ]; 

  @override
  Widget build(BuildContext context) {
    final itemCount = _prompts.length + 1;
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.normal),
        itemCount: itemCount,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isTest = index == _prompts.length;
          final prompt = isTest ? '테스트' : _prompts[index];
          return Align(
            alignment: Alignment.center,
            child: ActionChip(
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              label: Text(prompt),
              labelStyle: TextStyle(
                color: isTest ? AppColors.pointAmber : AppColors.primaryNavy,
                fontSize: AppSizes.fontNormal,
              ),
              backgroundColor: AppColors.surface,
              side: BorderSide(
                color: isTest ? AppColors.pointAmber : AppColors.divider,
              ),
              onPressed: isTest ? onTest : () => onSelect(prompt),
            ),
          );
        },
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessageModel message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == ChatRole.user;
    final showCopy = !isUser && message.id != 'pending';
    final maxWidth = MediaQuery.sizeOf(context).width * 0.72;

    final bubble = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isUser ? AppColors.primaryBlue : AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
          border: isUser ? null : Border.all(color: AppColors.divider),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.normal,
            vertical: AppSizes.s14,
          ),
          child: Text(
            message.text,
            style: TextStyle(
              color: isUser ? AppColors.surface : AppColors.textPrimary,
              fontSize: AppSizes.fontBig,
              height: 1.4,
            ),
          ),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.normal),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.accentBlue,
              child: Icon(
                Icons.auto_awesome,
                size: 16,
                color: AppColors.primaryNavy,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                bubble,
                if (showCopy)
                  IconButton(
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(text: message.text),
                      );
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('메시지를 복사했어요'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 28,
                      minHeight: 28,
                    ),
                    iconSize: 16,
                    color: AppColors.textSecondary,
                    icon: const Icon(Icons.copy_rounded),
                    tooltip: '복사',
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatComposer extends StatelessWidget {
  final TextEditingController controller;
  final bool canSend;
  final VoidCallback onSend;

  const _ChatComposer({
    required this.controller,
    required this.canSend,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.normal,
          AppSizes.s14,
          AppSizes.s14,
          AppSizes.s14,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: BaseTextField(
                controller: controller,
                hintText: '확인하고 싶은 내용을 입력해 주세요',
                contentPadding: AppSizes.normal,
                circleBorder: 20,
                inputAction: TextInputAction.send,
                onFieldSubmitted: (_) => onSend(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: canSend ? onSend : null,
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primaryNavy,
                foregroundColor: AppColors.surface,
                disabledBackgroundColor: AppColors.divider,
                disabledForegroundColor: AppColors.textSecondary,
                fixedSize: const Size(48, 48),
              ),
              icon: const Icon(Icons.send_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
