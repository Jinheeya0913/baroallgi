import 'package:baroallgi/core/const/const_color.dart';
import 'package:baroallgi/core/const/const_size.dart';
import 'package:baroallgi/core/ui/widgets/base_floating_btn.dart';
import 'package:baroallgi/core/ui/widgets/base_text_field.dart';
import 'package:baroallgi/core/ui/widgets/base_elevated_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:baroallgi/core/ui/layout/DefaultPageLayout.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ArticleDetailPage extends HookConsumerWidget {
  static String get routeName => 'article_detail';

  const ArticleDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _controller = useMemoized(() => QuillController.basic());

    /// final _controller = QuillController.basic();
    /// => build가 실행될 대마다 새로운 컨트롤러가 생기므로
    /// 글을 쓰다가 화면이 리빌딩 될 경우 작성하던 내용이 초기화 될 위험이 있음
    /// userMemoized : 객체 생성 결과를 캐싱. 복잡하거나 비용이 큰 객체에 용이

    // 툴바 보이기/숨기기
    final isToolbarVisible = useState(true);

    return DefaultLayout(
      title: Text('본문 작성'),
      actions: [
        Container(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: Icon(
              isToolbarVisible.value
                  ? Icons.keyboard_arrow_up
                  : Icons.format_paint,
            ),
            onPressed: () => isToolbarVisible.value = !isToolbarVisible.value,
            tooltip: '툴바 토글',
          ),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Row(
          //   children: [
          //     Container(
          //       alignment: Alignment.centerRight,
          //       child: IconButton(
          //         icon: Icon(
          //           isToolbarVisible.value
          //               ? Icons.keyboard_arrow_up
          //               : Icons.format_paint,
          //         ),
          //         onPressed: () =>
          //         isToolbarVisible.value = !isToolbarVisible.value,
          //         tooltip: '툴바 토글',
          //       ),
          //     ),
          //   ],
          // ),
          if (isToolbarVisible.value) ...[Divider()],
          AnimatedCrossFade(
            firstChild: QuillSimpleToolbar(
              controller: _controller,
              config: QuillSimpleToolbarConfig(
                showUndo: false,
                showRedo: false,
                showFontFamily: false,
                showCodeBlock: false,
                showListBullets: false,
                showSuperscript: false,
                showSubscript: false,
                showClearFormat: false,
                showInlineCode: false,
                embedButtons: FlutterQuillEmbeds.toolbarButtons(
                  imageButtonOptions: QuillToolbarImageButtonOptions(),
                  videoButtonOptions: null,
                ),
              ),
            ),
            secondChild: SizedBox.shrink(),
            crossFadeState: isToolbarVisible.value
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 200),
          ),
          Divider(),
          Expanded(
            child: QuillEditor.basic(
              controller: _controller,
              config: QuillEditorConfig(
                placeholder: '본문을 적어주세요',
                embedBuilders: kIsWeb
                    ? FlutterQuillEmbeds.editorWebBuilders()
                    : FlutterQuillEmbeds.editorBuilders(),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: BaseElevatedButton(
                  text: '임시저장',
                  onPressed: () {},
                  gradientColors: [
                    AppColors.subColorBlue,
                    AppColors.subColorBlue,
                  ],
                ),
              ),
              SizedBox(width: CNST_SIZE_NORMAL),
              Expanded(
                child: BaseElevatedButton(text: '작성 완료', onPressed: () {}),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget _buildToggleButton() {
  //   return
  // }
}
