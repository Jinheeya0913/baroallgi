import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';

class TextEditSheet extends HookWidget {
  final String initialText;
  final Function(String) onSave;

  const TextEditSheet({super.key, required this.initialText, required this.onSave});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: initialText);
    final focusNode = useFocusNode();

    // 시작하자마자 키보드 올리기
    useEffect(() {
      focusNode.requestFocus();
      return null;
    }, []);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, // 키보드 높이만큼 패딩
        left: 20, right: 20, top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            focusNode: focusNode,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: "문구를 입력하세요",
              border: InputBorder.none,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.pop(context);
              },
              child: const Text("확인", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}