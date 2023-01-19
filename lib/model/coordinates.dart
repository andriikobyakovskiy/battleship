class Coordinates {
  final int length;
  final int width;

  const Coordinates(this.length, this.width);
  factory Coordinates.letterDigit(String x, int y) =>
    Coordinates(x.runes.first, y);

  Coordinates copyWith({int? length, int? width}) => Coordinates(
    length ?? this.length,
    width ?? this.width,
  );

  @override
  int get hashCode => (length << 16) + (width & 0xffff);

  @override
  bool operator ==(Object other) => identical(this, other) || (
    other is Coordinates && (other.length == this.length && other.width == this.width)
  );

  @override
  String toString() => "Coordinates($length,$width)";
}