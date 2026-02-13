import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:baroallgi/core/ui/layout/DefaultPageLayout.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ReportPage extends HookConsumerWidget {
  static String get routeName => 'report';

  const ReportPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final _controller = useMemoized(() => QuillController.basic());
    /// final _controller = QuillController.basic();
    /// => build가 실행될 대마다 새로운 컨트롤러가 생기므로
    /// 글을 쓰다가 화면이 리빌딩 될 경우 작성하던 내용이 초기화 될 위험이 있음
    /// userMemoized : 객체 생성 결과를 캐싱. 복잡하거나 비용이 큰 객체에 용이

    return DefaultLayout(
      title: Text('작성'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          QuillSimpleToolbar(
            controller: _controller,
            config: QuillSimpleToolbarConfig(
              showUndo: false,
              showRedo: false ,
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
          Expanded(
            child: QuillEditor.basic(
              controller: _controller,
              config: QuillEditorConfig(
                  embedBuilders: kIsWeb ? FlutterQuillEmbeds.editorWebBuilders() : FlutterQuillEmbeds.editorBuilders(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
