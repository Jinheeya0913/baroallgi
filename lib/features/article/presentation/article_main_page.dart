import 'package:baroallgi/core/ui/layout/DefaultPageLayout.dart';
import 'package:baroallgi/core/ui/widgets/base_floating_btn.dart';
import 'package:baroallgi/core/ui/widgets/base_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:baroallgi/core/const/app_metadata.dart'; // 앞서 논의한 상수 파일

class ArticleMainPage extends HookConsumerWidget {
  static String get routeName => 'article_main';

  const ArticleMainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 상태 관리 (실제 앱에선 Provider나 Controller로 통합 권장)
    final selectedStatus = useState('FAKE');
    final selectedCategory = useState('finance');
    final titleController = useTextEditingController();
    final summaryController = useTextEditingController();
    final selectedIndex = useState(0); // 0: 카드뉴스, 1: 게시글
    final isSelected = [selectedIndex.value == 0, selectedIndex.value == 1];
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return DefaultLayout(
      resiseWithKeyboard: true,
      title: Text('작성 페이지'),
      floatingActionButton: isKeyboardVisible ? null: BaseFloatingButton(label: '다음 단계로'),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 진행 표시
            const LinearProgressIndicator(
              value: 0.5,
              backgroundColor: Colors.grey,
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('1. 제목'),
            const SizedBox(height: 12),
            BaseTextField(
              controller: titleController,
              hintText: '예: [부고 문자] 링크 클릭하면 폰이 해킹된다?',
              inputAction: TextInputAction.done,

            ),

            const SizedBox(height: 32),

            _buildSectionTitle('2. 작성 유형'),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                return ToggleButtons(
                  // constraints를 사용하여 가로 길이를 꽉 채움
                  constraints: BoxConstraints.expand(
                    width: (constraints.maxWidth - 4) / 2, // 테두리 두께 고려
                    height: 50,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  selectedColor: Colors.white,
                  fillColor: Colors.black,
                  color: Colors.black54,
                  isSelected: isSelected,
                  onPressed: (index) => selectedIndex.value = index,
                  children: const [
                    Text('카드뉴스', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('게시글', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                );
              },
            ),
            const SizedBox(height: 32),
            _buildSectionTitle('3. 분야'),
            const SizedBox(height: 12),
            _buildCategoryDropdown(selectedCategory),
            const SizedBox(height: 32),

            // 5. 전문가 한 줄 요약
            _buildSectionTitle('4. 요약'),
            const SizedBox(height: 12),
            BaseTextField(
              controller: summaryController,
              scrollToBottom: true,
              maxLines: 3,
              hintText: '이 정보에 대해 전문가로서 내리는 핵심 결론을 적어주세요.',
            ),

            SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 50),

            /*// 다음 단계 버튼
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Step 2로 이동 로직
                },
                child: const Text(
                  '다음 단계로 (본문 작성)',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  // --- 위젯 빌더 함수들 ---

  Widget _buildStatusGrid(ValueNotifier<String> selectedStatus) {
    // AppMetadata.factStatuses 리스트를 사용한다고 가정
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 2.5,
      children: AppMetadata.factStatuses.map((s) {
        bool isSelected = selectedStatus.value == s['id'];
        return GestureDetector(
          onTap: () => selectedStatus.value = s['id'],
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? s['color'] as Color : Colors.white,
              border: Border.all(
                color: isSelected ? s['color'] as Color : Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                s['label'],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCategoryDropdown(ValueNotifier<String> selectedCategory) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCategory.value,
          isExpanded: true,
          onChanged: (val) => selectedCategory.value = val!,
          items: AppMetadata.reportCategories.map((cat) {
            return DropdownMenuItem(
              value: cat['id'] as String,
              child: Text(cat['name']),
            );
          }).toList(),
        ),
      ),
    );
  }

  // --- 공통 섹션 타이틀 ---
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
