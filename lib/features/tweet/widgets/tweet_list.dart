import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/error_page.dart';
import 'package:twitter_clone/common/loading_page.dart';
import 'package:twitter_clone/constants/appwrite_constants.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_card.dart';

import '../../../models/tweet.dart';

class TweetList extends ConsumerWidget {
  const TweetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getTweetsProvider).when(
          data: (tweets) {
            return ref.watch(latestTweetProvider).when(
                  data: (data) {
                    if (data.events.contains(
                        'databases.${AppwriteConstants.databaseId}.collections.*.documents.*.create')) {
                      tweets.insert(0, Tweet.fromMap(data.payload));
                    } else if (data.events.contains(
                        'databases.${AppwriteConstants.databaseId}.collections.*.documents.*.update')) {
                      final updatedTweet = Tweet.fromMap(data.payload);
                      for (var i = 0; i < tweets.length; i++) {
                        if (tweets[i].id == updatedTweet.id) {
                          tweets[i] = updatedTweet;
                        }
                      }
                    }
                    return ListView.builder(
                      itemCount: tweets.length,
                      itemBuilder: ((context, index) {
                        final tweet = tweets[index];
                        return TweetCard(tweet: tweet);
                      }),
                    );
                  },
                  error: (e, stackTrace) => ErrorText(
                    error: e.toString(),
                  ),
                  loading: () {
                    return ListView.builder(
                      itemCount: tweets.length,
                      itemBuilder: ((context, index) {
                        final tweet = tweets[index];
                        return TweetCard(tweet: tweet);
                      }),
                    );
                  },
                );
          },
          error: (e, stackTrace) => ErrorText(
            error: e.toString(),
          ),
          loading: () => const LoadingPage(),
        );
  }
}
