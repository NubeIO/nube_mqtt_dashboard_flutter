/// Abstract class to mark implementor as Closable Tree
// ignore: one_member_abstracts
abstract class CloseableTree {
  /// Closes a tree,
  /// use it to flush buffer/caches or close any resource.
  void close();
}
