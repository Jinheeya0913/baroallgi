import 'package:baroallgi/core/ui/layout/DefaultPageLayout.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';


class ImagePickerPage extends HookConsumerWidget {
  static String get routeName => 'image_picker';
  const ImagePickerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // 상태 관리: 불러온 자산(Asset) 리스트와 선택된 리스트
    final assets = useState<List<AssetEntity>>([]);
    final selectedAssets = useState<List<AssetEntity>>([]);
    final maxCount = 20;

    // 초기 권한 요청 및 사진 로드
    useEffect(() {
      Future<void> loadAssets() async {
        // 1. 현재 라이브러리 버전의 권한 요청 메서드 사용
        final PermissionState ps = await PhotoManager.requestPermissionExtend();

        print("권한 상태: $ps");

        // 2. 권한이 허용(authorized)되었거나 일부 허용(limited)된 경우
        if (ps.isAuth || ps == PermissionState.limited) {

          // 3. 앨범 목록 가져오기 (오직 이미지만)
          final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
            type: RequestType.image,
            // 중요: 필터 옵션을 추가하여 모든 이미지를 강제로 스캔하도록 유도
            filterOption: FilterOptionGroup(
              containsPathModified: true,
            ),
          );

          if (paths.isNotEmpty) {
            // 첫 번째 앨범(보통 'Recent' 또는 '모든 사진') 선택
            final AssetPathEntity recentAlbum = paths.first;

            // 4. 사진 데이터 가져오기 (최근순 80장)
            final List<AssetEntity> recentAssets = await recentAlbum.getAssetListRange(
              start: 0,
              end: 80,
            );

            assets.value = recentAssets;
          } else {
            print("사진이 포함된 앨범 경로를 찾지 못했습니다.");
          }
        } else {
          print("권한이 거절되었습니다.");
          // 권한 거절 시 설정창으로 보낼 수 있습니다.
          // PhotoManager.openSetting();
        }
      }
      loadAssets();
      return null;
    }, []);

    return DefaultLayout(
      title: const Text("사진 선택", style: TextStyle(fontWeight: FontWeight.bold)),
      useBackBtn: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: selectedAssets.value.isNotEmpty
          ? SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: FloatingActionButton.extended(
          onPressed: () => Navigator.pop(context, selectedAssets.value),
          label: Text("${selectedAssets.value.length}장 선택 완료"),
          backgroundColor: Colors.white,
        ),
      )
          : null,
      // 우측 상단 완료 버튼
      child: GridView.builder(
        itemCount: assets.value.length + 1, // '추가' 버튼을 위해 +1
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 인스타처럼 3열
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
        ),
        itemBuilder: (context, index) {
          // 첫 번째 칸: 사진 추가(카메라 등) 아이콘
          if (index == 0) {
            return GestureDetector(
              onTap: () {
                // TODO: 카메라 실행 또는 외부 갤러리 호출 로직
                print('rlog :: 카메라 실행');
              },
              child: Container(
                color: Colors.grey[200],
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt_outlined, color: Colors.grey),
                    Text("사진 촬영", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            );
          }

          final asset = assets.value[index - 1];
          final isSelected = selectedAssets.value.contains(asset);
          final selectIndex = selectedAssets.value.indexOf(asset);

          return GestureDetector(
            onTap: () {
              if (isSelected) {
                selectedAssets.value =
                    selectedAssets.value.where((e) => e != asset).toList();
              } else {
                if (selectedAssets.value.length < maxCount) {
                  selectedAssets.value = [...selectedAssets.value, asset];
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("최대 20장까지 선택 가능합니다.")),
                  );
                }
              }
            },
            child: Stack(
              children: [
                // 사진 썸네일
                Positioned.fill(
                  child: AssetEntityImage(
                    asset,
                    isOriginal: false,
                    thumbnailSize: const ThumbnailSize.square(200),
                    fit: BoxFit.cover,
                  ),
                ),
                // 선택 시 오버레이 효과
                if (isSelected)
                  Positioned.fill(
                    child: Container(color: Colors.white.withOpacity(0.3)),
                  ),
                // 숫자 표시 (인스타 스타일)
                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    alignment: Alignment.center,
                    child: isSelected
                        ? Text(
                      "${selectIndex + 1}",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    )
                        : null,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}