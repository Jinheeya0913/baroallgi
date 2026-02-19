import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

final permissionProvider =
    StateNotifierProvider<PermissionProvider, AppPermissionState>((ref) {
      return PermissionProvider();
    });

class PermissionProvider extends StateNotifier<AppPermissionState> {
  PermissionProvider() : super(AppPermissionState()) {
    initAllStatus();
  }

  // 사진 권한 요청
  Future<void> requestPhotoPermission() async {
    PermissionRequestOption requestOption;
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      requestOption = const PermissionRequestOption(
        iosAccessLevel: IosAccessLevel.readWrite,
      );
    } else {
      requestOption = const PermissionRequestOption(
        androidPermission: AndroidPermission(
          type: RequestType.common,
          mediaLocation: false,
        ),
      );
    }

    final photosPs = await PhotoManager.requestPermissionExtend(
      requestOption: requestOption,
    );
    // 상태 업데이트
    if (photosPs.isAuth) {
      state = state.copyWith(photo: photosPs);
    }
  }

  // 카메라 권한 요청 (camera 패키지 사용 시)
  Future<void> requestCameraPermission() async {
    print('rlog :: 카메라 권한 요청');
    final status = await ph.Permission.camera.request();

    PermissionState cameraPs;

    if (status.isGranted) {
      cameraPs = PermissionState.authorized;
      final cameras = await availableCameras();
    } else if (status.isPermanentlyDenied) {
      cameraPs = PermissionState.denied;
    } else {
      cameraPs = PermissionState.denied;
    }

    state = state.copyWith(camera: cameraPs);
  }

  // 모든 권한 상태 새로고침
  Future<void> initAllStatus() async {
    // 사진 권한 상태
    PermissionRequestOption requestOption = _getOption();
    final photoPs = await PhotoManager.getPermissionState(
      requestOption: requestOption,
    );
    // 카메라 권한 상태
    final cameraStatus = await ph.Permission.camera.status;
    final cameraPs = cameraStatus.isGranted
        ? PermissionState.authorized
        : PermissionState.denied;

    print('rlog :: init 사진 권한 상태 :: ${photoPs.isAuth}');
    print('rlog :: init 카메라 권한 상태 :: ${cameraPs.isAuth}');


    state = state.copyWith(photo: photoPs, camera: cameraPs);
  }

  // 플랫폼별 옵션을 반환
  PermissionRequestOption _getOption() {
    if (state.platform == TargetPlatform.iOS) {
      return const PermissionRequestOption(
        iosAccessLevel: IosAccessLevel.readWrite,
      );
    }
    return const PermissionRequestOption(
      androidPermission: AndroidPermission(
        type: RequestType.common,
        mediaLocation: false,
      ),
    );
  }
}

class AppPermissionState {
  final PermissionState photo;
  final PermissionState camera;
  final TargetPlatform platform; // 플랫폼 정보 추가

  AppPermissionState({
    this.photo = PermissionState.notDetermined,
    this.camera = PermissionState.notDetermined,
    TargetPlatform? platform,
  }) : platform = platform ?? defaultTargetPlatform;

  AppPermissionState copyWith({
    PermissionState? photo,
    PermissionState? camera,
    TargetPlatform? platform,
  }) {
    return AppPermissionState(
      photo: photo ?? this.photo,
      camera: camera ?? this.camera,
      platform: platform ?? this.platform,
    );
  }
}
