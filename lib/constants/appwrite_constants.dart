class AppwriteConstants {
  static const String databaseId = '6560974a23a420105553';
  static const String projectId = '656096f909fcacdd56a8';
  static const String endpoint = 'http://localhost/v1';
  static const String usersCollection = '6560b550a2b8e4dbae4f';
  static const String tweetsCollection = '656b09a2d6606583a54b';
  static const String imagesBucketId = '656b4cdd531f1d9e9755';
  static String getImageUrl(String imageId) =>
      "$endpoint/storage/buckets/$imagesBucketId/files/$imageId/view?project=$projectId&mode=admin";
}
