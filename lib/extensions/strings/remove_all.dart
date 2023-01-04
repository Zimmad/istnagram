extension RemoveAll on String {
  String removeAll(Iterable<String> values) {
    return values.fold(
      this,
      (previousValue, element) => previousValue.replaceAll(element, ''),
    );
  }
}
