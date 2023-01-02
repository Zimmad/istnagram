import 'package:flutter/foundation.dart' show immutable;
import 'package:istnagram/state/enums/date_sorting.dart';
import 'package:istnagram/state/posts/typedef/post_id.dart';

@immutable
class RequestForPostAndComments {
  final PostId postId;
  final bool sortByCreatedAt;
  final DateSorting dateSorting;
  final int? limit;

  const RequestForPostAndComments({
    required this.postId,
    this.sortByCreatedAt = false,
    this.dateSorting = DateSorting.newestOnTop,
    this.limit,
  });

  @override

  /// by using [covairant] we can avoid usig [identical and runTimeType]
  bool operator ==(covariant RequestForPostAndComments other) =>
      postId == other.postId &&
      sortByCreatedAt == other.sortByCreatedAt &&
      dateSorting == other.dateSorting &&
      limit == other.limit;

  @override
  int get hashCode => Object.hashAll([
        postId,
        sortByCreatedAt,
        dateSorting,
        limit,
      ]);
}
