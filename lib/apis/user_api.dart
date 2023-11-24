import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/core/failure.dart';
import 'package:twitter_clone/core/providers.dart';
import 'package:twitter_clone/core/type_def.dart';
import 'package:twitter_clone/models/user.dart';

final userAPIProvider = Provider<UserAPI>((ref) {
  final databases = ref.watch(appwriteDatabaseProvider);
  return UserAPI(db: databases);
});

abstract class IUserAPI {
  FutureEitherVoid saveUserData(UserModel user);
}

class UserAPI implements IUserAPI {
  final Databases _db;
  UserAPI({required Databases db}) : _db = db;

  @override
  FutureEitherVoid saveUserData(UserModel user) async {
    try {
      _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollection,
        documentId: ID.unique(),
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
}
