import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

final permissionProvider =
    StateNotifierProvider<PermissionNotifier, AppPermissionState>((ref) {
      return PermissionNotifier();
    });

class PermissionNotifier extends StateNotifier<AppPermissionState> {
  PermissionNotifier() : super(AppPermissionState()) {
    // 앱 시작 시 현재 권한 상태 확인
    refreshAllStatus();
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
    } else {
      print('rlog :: 사용자가 권한을 거부하였습니다.');
    }
  }

  // 카메라 권한 요청 (camera 패키지 사용 시)
  Future<void> requestCameraPermission() async {
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
  Future<void> refreshAllStatus() async {
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

    print('rlog :: photoPs > ${photoPs.isAuth} || cameraPs > ${cameraPs.isAuth}');

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
  final TargetPlatform? platform; // 플랫폼 정보 추가

  AppPermissionState({
    this.photo = PermissionState.notDetermined,
    this.camera = PermissionState.notDetermined,
    this.platform,
  });

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
