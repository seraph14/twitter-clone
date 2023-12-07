import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/storage_api.dart';
import 'package:twitter_clone/apis/tweet_api.dart';
import 'package:twitter_clone/core/enums/tweet_type_enum.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/models/tweet.dart';
import 'package:twitter_clone/models/user.dart';

final tweetControllerProvider = StateNotifierProvider<TweetController, bool>(
  (ref) {
    return TweetController(
      ref: ref,
      tweetAPI: ref.watch(tweetAPIProvider),
      storageAPI: ref.watch(storageAPIProvider),
    );
  },
);

final getTweetsProvider = FutureProvider((ref) async {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweets();
});

final getRepliesToTweetsProvider =
    FutureProvider.family((ref, Tweet tweet) async {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getRepliesToTweet(tweet);
});

final getTweetByIdProvider = FutureProvider.family((ref, String id) async {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweetById(id);
});

final latestTweetProvider = StreamProvider((ref) {
  final tweetAPI = ref.watch(tweetAPIProvider);
  return tweetAPI.getLatestTweet();
});

class TweetController extends StateNotifier<bool> {
  final Ref _ref;
  final TweetAPI _tweetAPI;
  final StorageAPI _storageAPI;
  TweetController({
    required Ref ref,
    required TweetAPI tweetAPI,
    required StorageAPI storageAPI,
  })  : _ref = ref,
        _storageAPI = storageAPI,
        _tweetAPI = tweetAPI,
        super(false);

  Future<List<Tweet>> getTweets() async {
    final tweets = await _tweetAPI.getTweets();
    return tweets.map((e) => Tweet.fromMap(e.data)).toList();
  }

  Future<Tweet> getTweetById(String id) async {
    final tweet = await _tweetAPI.getTweetById(id);
    return Tweet.fromMap(tweet.data);
  }

  void reshareTweet(Tweet tweet, UserModel user, BuildContext context) async {
    Tweet updatedTweet = tweet.copyWith(
      likes: [],
      commentIds: [],
      retweetedBy: user.name,
      reshareCount: tweet.reshareCount + 1,
    );

    final res = await _tweetAPI.updateReshareCount(updatedTweet);
    res.fold((l) => showSnackbar(context, l.message), (r) async {
      tweet = updatedTweet.copyWith(
        id: ID.unique(),
        reshareCount: 0,
        tweetedAt: DateTime.now(),
      );
      final res2 = await _tweetAPI.shareTweet(tweet);
      res2.fold(
        (l) => showSnackbar(context, l.message),
        (r) => showSnackbar(context, 'Retweeted'),
      );
    });
  }

  Future<List<Tweet>> getRepliesToTweet(Tweet tweet) async {
    final documents = await _tweetAPI.getRepliesToTweets(tweet);
    return List<Tweet>.from(documents.map((e) => e.data));
  }

  void likeTweet(Tweet tweet, UserModel user) async {
    List<String> likes = tweet.likes;
    if (likes.contains(user.uid)) {
      likes.remove(user.uid);
    } else {
      likes.add(user.uid);
    }

    Tweet updatedTweet = tweet.copyWith(likes: likes);
    final res = await _tweetAPI.likeTweet(updatedTweet);
    res.fold((l) => null, (r) => null);
  }

  void shareTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
    required String repliedTo,
  }) {
    if (text.isEmpty) {
      showSnackbar(context, 'Please enter a text');
      return;
    }

    if (images.isNotEmpty) {
      _shareImageTweet(
        images: images,
        text: text,
        context: context,
        repliedTo: repliedTo,
      );
    } else {
      _shareTextTweet(
        text: text,
        context: context,
        repliedTo: repliedTo,
      );
    }
  }

  void _shareImageTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
    required String repliedTo,
  }) async {
    state = true;
    final hashtags = _getHashtagsFromText(text);
    final link = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;
    final imageLinks = await _storageAPI.uploadImages(images);

    Tweet tweet = Tweet(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: imageLinks,
      uid: user.uid,
      tweetType: TweetType.image,
      tweetedAt: DateTime.now(),
      likes: [],
      commentIds: [],
      reshareCount: 0,
      retweetedBy: '',
      repliedTo: repliedTo,
      id: '',
    );

    final res = await _tweetAPI.shareTweet(tweet);

    state = false;
    res.fold(
      (l) {
        showSnackbar(context, l.message);
      },
      (r) => null,
    );
  }

  void _shareTextTweet({
    required String text,
    required BuildContext context,
    required String repliedTo,
  }) async {
    state = true;
    final hashtags = _getHashtagsFromText(text);
    final link = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;
    Tweet tweet = Tweet(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: [],
      uid: user.uid,
      tweetType: TweetType.text,
      tweetedAt: DateTime.now(),
      likes: [],
      commentIds: [],
      reshareCount: 0,
      retweetedBy: '',
      repliedTo: repliedTo,
      id: '',
    );

    final res = await _tweetAPI.shareTweet(tweet);

    state = false;
    res.fold(
      (l) {
        showSnackbar(context, l.message);
      },
      (r) => null,
    );
  }

  String _getLinkFromText(String text) {
    List<String> words = text.split(' ');
    String link = '';

    for (final word in words) {
      if (word.startsWith('https://') || word.startsWith('wwww.')) {
        link = word;
      }
    }

    return link;
  }

  List<String> _getHashtagsFromText(String text) {
    List<String> words = text.split(' ');
    List<String> hashtags = [];

    for (final word in words) {
      if (word.startsWith('#')) hashtags.add(word);
    }

    return hashtags;
  }
}
