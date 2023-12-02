import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/core/providers.dart';

final storageAPIProvider = Provider((ref) {
  return StorageAPI(
    storage: ref.watch(appwriteStorageProvider),
  );
});

class StorageAPI {
  final Storage _storage;
  StorageAPI({required Storage storage}) : _storage = storage;

  Future<List<String>> uploadImages(List<File> images) async {
    List<String> imageLinks = [];

    for (final image in images) {
      final uploadedImage = await _storage.createFile(
        bucketId: AppwriteConstants.imagesBucketId,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: image.path),
      );
      imageLinks.add(AppwriteConstants.getImageUrl(uploadedImage.$id));
    }

    return imageLinks;
  }
}
