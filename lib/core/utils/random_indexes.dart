import 'dart:math';

// Picks up to [count] distinct indexes in [0, total) in random order.
List<int> pickRandomIndexes(int total, int count, [Random? random]) {
  final rng = random ?? Random();
  if (total <= count) return List.generate(total, (i) => i)..shuffle(rng);
  final picked = <int>{};
  while (picked.length < count) {
    picked.add(rng.nextInt(total));
  }
  return picked.toList();
}
