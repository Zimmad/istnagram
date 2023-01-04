import 'package:istnagram/state/comments/models/comment_post_request.dart';
import 'package:istnagram/state/comments/models/comment.dart';
import 'package:istnagram/state/enums/date_sorting.dart';

extension Sorting on Iterable<Comment> {
  Iterable<Comment> applySortingFrom(RequestForPostAndComments request) {
    if (request.sortByCreatedAt) {
      final sortedDocuments = toList()
        ..sort(
          (a, b) {
            switch (request.dateSorting) {
              case DateSorting.newestOnTop:

                /// If it is newest on top than compare b.created at to a.created at
                return b.createdAt.compareTo(a.createdAt);
              case DateSorting.oldesOnTop:

                ///if it is oldest on top than compare [b.createdAt] to [a.createdAt]
                return a.createdAt.compareTo(b.createdAt);
            }
          },
        );
      return sortedDocuments;
    } else {
      return this;
    }
  }
}
