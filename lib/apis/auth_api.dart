import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/failure.dart';
import 'package:twitter_clone/core/providers.dart';
import 'package:twitter_clone/core/type_def.dart';

final authAPIProvider = Provider((ref) {
  final account = ref.watch(appwriteAccountProvider);
  return AuthAPI(
    account: account,
  );
});

abstract class IAuthAPI {
  FutureEither<models.User> signUp({
    required String email,
    required String password,
  });

  FutureEither<models.Session> login({
    required String email,
    required String password,
  });

  Future<models.User?> currentUserAccount();
}

class AuthAPI implements IAuthAPI {
  final Account _account;
  AuthAPI({required Account account}) : _account = account;

  @override
  Future<models.User?> currentUserAccount() async {
    try {
      return await _account.get();
    } on AppwriteException {
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  FutureEither<models.User> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );

      return right(user);
    } on AppwriteException catch (e, stacktrace) {
      return left(
        Failure(e.message ?? 'Some unexpected error happened', stacktrace),
      );
    } catch (e, stacktrace) {
      return left(Failure(e.toString(), stacktrace));
    }
  }

  @override
  FutureEither<models.Session> login({
    required String email,
    required String password,
  }) async {
    try {
      final session = await _account.createEmailSession(
        email: email,
        password: password,
      );
      return right(session);
    } on AppwriteException catch (e, stacktrace) {
      return left(
        Failure(e.message ?? 'Some unexpected error happened', stacktrace),
      );
    } catch (e, stacktrace) {
      return left(Failure(e.toString(), stacktrace));
    }
  }
}
