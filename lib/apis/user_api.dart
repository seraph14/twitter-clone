import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/core/failure.dart';
import 'package:twitter_clone/core/providers.dart';
import 'package:twitter_clone/core/type_def.dart';
import 'package:twitter_clone/models/user.dart';

final userAPIProvider = Provider<UserAPI>((ref) {
  final databases = ref.watch(appwriteDatabaseProvider);
  final realtime = ref.watch(appwriteRealtimeProvider);
  return UserAPI(db: databases, realtime: realtime);
});

abstract class IUserAPI {
  FutureEitherVoid saveUserData(UserModel user);
  Future<model.Document> getUserData(String uid);
  Future<List<model.Document>> searchUserByName(String name);
  FutureEitherVoid updateUserData(UserModel userModel);
  Stream<RealtimeMessage> getLatestUserData();
}

class UserAPI implements IUserAPI {
  final Databases _db;
  final Realtime _realtime;

  UserAPI({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;

  @override
  Future<model.Document> getUserData(String uid) async {
    return _db.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.usersCollection,
      documentId: uid,
    );
  }

  @override
  FutureEitherVoid saveUserData(UserModel user) async {
    try {
      _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollection,
        documentId: user.uid,
        data: user.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error happened',
          stackTrace,
        ),
      );
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  Future<List<model.Document>> searchUserByName(String name) async {
    final listDocuments = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollection,
        queries: [
          Query.search('name', name),
        ]);

    return listDocuments.documents;
  }

  @override
  FutureEitherVoid updateUserData(UserModel userModel) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollection,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error happened',
          stackTrace,
        ),
      );
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  Stream<RealtimeMessage> getLatestUserData() {
    return _realtime.subscribe([
      "databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.tweetsCollection}.documents",
    ]).stream;
  }
  

}
