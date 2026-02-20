import 'package:baroallgi/core/const/const_size.dart';
import 'package:baroallgi/core/provider/permission_provider.dart';
import 'package:baroallgi/core/provider/select_image_provider.dart';
import 'package:baroallgi/core/ui/layout/DefaultPageLayout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class ImagePickerPage extends HookConsumerWidget {
  static String get routeName => 'image_picker';
  final String nextPathName;

  const ImagePickerPage({super.key, this.nextPathName ='cardName'}); // 임시로 반드시 cardName으로 향하게 지정

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissionState = ref.watch(permissionProvider);
    final permissionNotifier = ref.watch(permissionProvider.notifier);
    final selectImageNotifier = ref.watch(selectImageProvider.notifier);

    // 상태 관리: 불러온 자산(Asset) 리스트와 선택된 리스트
    final assets = useState<List<AssetEntity>>([]);
    final selectedAssets = ref.watch(selectImageProvider);
    final maxCount = 20;

    useEffect(() {
      if (permissionState.photo.isAuth) {
        print('rlog :: photo state ${permissionState.photo.isAuth}');
        Future<void> loadAssets() async {
          final List<AssetPathEntity> paths =
              await PhotoManager.getAssetPathList(
                type: RequestType.image,
                filterOption: FilterOptionGroup(containsPathModified: true),
              );

          if (paths.isNotEmpty) {
            final recentAssets = await paths.first.getAssetListRange(
              start: 0,
              end: 80,
            );
            assets.value = recentAssets;
          }
        }

        loadAssets();
      }
      return null;
    }, [permissionState.photo, selectedAssets]);

    // 권한이 없는 경우 (거부됨 또는 아직 결정 안 됨)
    if (!permissionState.photo.isAuth) {
      return DefaultLayout(
        title: const Text("권한 필요"),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("사진을 선택하려면 권한이 필요합니다."),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => permissionNotifier.requestPhotoPermission(),
                child: const Text("권한 요청하기"),
              ),
            ],
          ),
        ),
      );
    }

    return DefaultLayout(
      title: const Text("사진 선택", style: TextStyle(fontWeight: FontWeight.bold)),
      useBackBtn: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildSubmitButton(context, selectedAssets),
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
                    Text(
                      "사진 촬영",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }

          final asset = assets.value[index - 1];
          final isSelected = selectedAssets.contains(asset);
          final selectIndex = selectedAssets.indexOf(asset);

          return GestureDetector(
            onTap: () {
              if (isSelected) {
                selectImageNotifier.selectedImagesToggle(asset, maxCount);
              } else if (selectedAssets.length < maxCount) {
                selectImageNotifier.selectedImagesToggle(asset, maxCount);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("최대 20장까지 선택 가능합니다.")),
                );
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
                              fontWeight: FontWeight.bold,
                            ),
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

  Widget _buildSubmitButton(BuildContext context, List<AssetEntity> selected) {
    if (selected.isNotEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: FloatingActionButton.extended(
          onPressed: () {
            context.pushNamed('cardEdit');
          },
          label: Text(
            "${selected.length}장 선택",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black87,
        ),
      );
    } else {
      return SizedBox(
        width: SizeUtil.getFloatingButtonSize(context),
        child: FloatingActionButton.extended(
          onPressed: () {},
          label: Text("사진을 선택해주세요", style: TextStyle(color: Colors.grey[600])),
          backgroundColor: Colors.grey[200],
        ),
      );
    }
  }
}
