class Coordinates {
  final int x;
  final int y;

  const Coordinates(this.x, this.y);
  factory Coordinates.letterDigit(String x, int y) =>
    Coordinates(x.runes.first, y);

  Coordinates copyWith({int? x, int? y}) => Coordinates(
    x ?? this.x,
    y ?? this.y,
  );

  @override
  int get hashCode => (x << 16) + (y & 0xffff);

  @override
  bool operator ==(Object other) => identical(this, other) || (
    other is Coordinates && (other.x == this.x && other.y == this.y)
  );

  @override
  String toString() => "Coordinates($x,$y)";
}