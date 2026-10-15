import 'package:baroallgi/core/const/const_color.dart';
import 'package:baroallgi/core/const/const_size.dart';
import 'package:baroallgi/core/ui/layout/DefaultPageLayout.dart';
import 'package:baroallgi/core/ui/widgets/app_logo_img.dart';
import 'package:baroallgi/core/ui/widgets/base_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookConsumerWidget {
  static String get routeName => 'main';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<String> alertMessages = [
      "🚨 [긴급] 부고 문자 링크 클릭 금지! 개인정보 탈취 주의",
      "🏥 암 완치하는 기적의 물? 검증되지 않은 의학정보 주의",
      "💰 은행은 문자로 '정부지원 대출'을 안내하지 않습니다",
      "📺 SNS 파격 세일 광고, 결제 전 사기 사이트인지 확인하세요",
    ];
    return DefaultLayout(
      title: _title(),
      useAppBar: true,
      useDrawer: true,
      floatingActionButton: _buildFloatButtons(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: AppColors.softRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.alertAccent),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        alertMessages[0], // 실제로는 로직에 따라 변경
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.alertAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const _HotPickSlider(),
            _buildAiChatCard(context),
            SizedBox(height: 10),
            _buildMenuCard(
              '💰 금융사기',
              '보이스피싱, 스미싱 수법 정리',
              Icons.monetization_on,
              AppColors.fiance,
            ),
            _buildMenuCard(
              '의학 정보 바로잡기',
              '민간요법과 가짜 의학 지식 검증',
              Icons.medical_services_rounded,
              AppColors.health,
            ),
            _buildMenuCard(
              '허위·과대 광고 주의보',
              '속기 쉬운 SNS 쇼핑 광고의 진실',
              Icons.ad_units_rounded,
              AppColors.ad,
            ),
            _buildMenuCard(
              '단톡방 찌라시 검증',
              'SNS 루머와 유언비어 진위 판정',
              Icons.forum_rounded,
              AppColors.rumor,
            ),

            SizedBox(
              height: 100,
              child: Card(
                color: AppColors.infoSurface,
                child: Center(child: Text('🙋이거 진짜인가요?')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 3), // 그림자 위치
          ),
        ],
      ),
      child: Material(
        // 클릭 피드백(InkWell)을 위한 Material 위젯
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // TODO: 메뉴 클릭 이벤트
          },
          borderRadius: BorderRadius.circular(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // 아이콘 영역
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Icon(icon, color: color, size: 30),
                ),
                const SizedBox(width: 16.0),
                // 텍스트 영역
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // 화살표 아이콘
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAiChatCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.reportGradient,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/ai_chat'),
          borderRadius: BorderRadius.circular(20.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 24.0,
              horizontal: 20.0,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.smart_toy_outlined,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "이거 진짜인가요?",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "AI를 통해 올바른 정보를 확인해드립니다!",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white54,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _title() {
    return AppLogoImg(isHorizontal: true, width: 150);
  }

  Widget _buildFloatButtons() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: const IconThemeData(size: 22.0),
      overlayColor: Colors.black,
      overlayOpacity: 0.4,
      spacing: 10,
      children: [
        SpeedDialChild(
          child: Icon(Icons.create),
          onTap: () {},
          backgroundColor: Colors.white,
          label: '카드뉴스 작성하기',
        ),
        SpeedDialChild(
          child: Icon(Icons.image),
          onTap: () {},
          backgroundColor: Colors.blue,
          label: 'open image',
        ),
      ],
    );
  }
}

class _HotPick {
  final String imageUrl;
  final String title;
  final String tag;

  const _HotPick({
    required this.imageUrl,
    required this.title,
    required this.tag,
  });
}

class _HotPickSlider extends StatefulWidget {
  const _HotPickSlider();

  @override
  State<_HotPickSlider> createState() => _HotPickSliderState();
}

class _HotPickSliderState extends State<_HotPickSlider> {
  static const _items = <_HotPick>[
    _HotPick(
      imageUrl: 'https://picsum.photos/id/1/600/400',
      title: '최신 보이스피싱: "부고 문자" 주의!',
      tag: '긴급',
    ),
    _HotPick(
      imageUrl: 'https://picsum.photos/id/2/600/400',
      title: 'SNS 과대광고: 먹기만 해도 살 빠지는 약?',
      tag: '광고',
    ),
    _HotPick(
      imageUrl: 'https://picsum.photos/id/3/600/400',
      title: '잘못된 의학지식: 암 예방하는 식초?',
      tag: '의학',
    ),
  ];

  var _didPrecacheNeighbors = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didPrecacheNeighbors) return;
    _didPrecacheNeighbors = true;
    for (final item in _items.skip(1)) {
      precacheImage(
        NetworkImage(item.imageUrl),
        context,
        onError: (_, _) {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: PageView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: _HotPickSlide(item: _items[index]),
          );
        },
      ),
    );
  }
}

class _HotPickSlide extends StatelessWidget {
  final _HotPick item;

  const _HotPickSlide({required this.item});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BaseNetworkImage(
        url: item.imageUrl,
        builder: (context, child) {
          return Stack(
            fit: StackFit.expand,
            children: [
              child,
              _HotPickOverlay(item: item),
            ],
          );
        },
      ),
    );
  }
}

class _HotPickOverlay extends StatelessWidget {
  final _HotPick item;

  const _HotPickOverlay({required this.item});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  item.tag,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
