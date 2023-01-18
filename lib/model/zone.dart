import 'package:battleship/model/coordinates.dart';

class Zone {
  final int length;
  final int width;
  final int lengthOffset;
  final int widthOffset;

  const Zone(this.length, this.width, [this.lengthOffset=0, this.widthOffset=0]);

  bool contains(Coordinates coordinates) {
    if (coordinates.x < lengthOffset || coordinates.x >= lengthOffset + length) {
      return false;
    }
    if (coordinates.y < widthOffset || coordinates.y >= widthOffset + width) {
      return false;
    }

    return true;
  }

  List<Coordinates> get coordinates => List.generate(
    length * width,
    (i) => Coordinates(lengthOffset + i ~/ width, widthOffset + i % width)
  );

  @override
  int get hashCode => length << 24
      + (width & 0xff) << 16
      + (lengthOffset & 0xff) << 8
      + (widthOffset & 0xff);

  @override
  bool operator ==(Object other) => identical(this, other) || (
    other is Zone
    && (other.length == length
        && other.width == width
        && other.lengthOffset == lengthOffset
        && other.widthOffset == widthOffset)
  );
}