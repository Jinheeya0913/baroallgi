import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

final selectImageProvider = StateNotifierProvider.autoDispose<SelectImageProvider, List<AssetEntity>>((ref) {
  return SelectImageProvider();
});



class SelectImageProvider extends StateNotifier<List<AssetEntity>> {
  SelectImageProvider() : super([]);

  void selectedImagesToggle(AssetEntity asset, int max){
    if(state.contains(asset)){
      state = state.where((e)=> e!=asset).toList();
    } else if(state.length < max){
      state = [...state, asset];
    }
  }
}