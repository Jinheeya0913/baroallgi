import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
});

final fireStorageProvider = Provider<FireStorageProvider>((ref) {
  return FireStorageProvider(storage: FirebaseStorage.instance);
});

class FireStorageProvider {
  final FirebaseStorage storage;

  FireStorageProvider({required this.storage});


  Future<void> deleteFolder({
    String filePath = '',

  }) async{
    try {
      print('rlog :: Firebase Storage 삭제 수행!');
      final ref = storage.ref().child(filePath);
      final listResult = await ref.listAll();

      // 폴더 내 모든 파일을 병렬로 삭제
      await Future.wait(listResult.items.map((item) => item.delete()));
    } catch(e){
      print('rlog :: Firebase Storage 삭제 실패!');
      throw Exception(e);
    }
  }

  Future<List<String>> uploadMultipleImages({
    required String path,
    required List<File> files,
    String? type,
    String? id,
  }) async {
    try{
      // map 함수는 실행 결과를 만들어서 새로운 목록을 만듦.
      // 업로드 결과의 url(=>getDownloadURL)을 차곡차곡 쌓아서 uploadTask(Iterable)에 저장.
      // Future.wait : 인자값(Iterator) 내부의 모든 Future 작업이 끝날 때까지 대기.
      final uploadTask = files.asMap().entries.map((entry) async {
          final index = entry.key;
          final file = entry.value;
          String extraFilename = '';

          if(type != null){
            extraFilename += '_$type';
          }

          if(id != null){
            extraFilename += '_$id';
          }
          
          print('rlog :: fileName : $extraFilename');
          
          final ref =  storage.ref().child('$path/$id/image${extraFilename}_$index.jpg');
          

          await ref.putFile(file);

          return await ref.getDownloadURL();
      });
      
      return await Future.wait(uploadTask);
    } catch (e){
      print('rlog :: Firebase Storage 업로드 실패!');
      throw Exception(e);
    }
  }
}
