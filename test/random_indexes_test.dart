import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:snap_sweep/core/utils/random_indexes.dart';

void main() {
  test('returns distinct indexes within range', () {
    final indexes = pickRandomIndexes(1000, 15, Random(1));
    expect(indexes, hasLength(15));
    expect(indexes.toSet(), hasLength(15));
    expect(indexes.every((i) => i >= 0 && i < 1000), isTrue);
  });

  test('returns every index when gallery is small', () {
    final indexes = pickRandomIndexes(4, 15, Random(1));
    expect(indexes.toSet(), {0, 1, 2, 3});
  });

  test('handles an empty gallery', () {
    expect(pickRandomIndexes(0, 15), isEmpty);
  });
}
