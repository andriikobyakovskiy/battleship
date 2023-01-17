import 'package:battleship/model/coordinates.dart';

class Zone {
  final int length;
  final int width;
  final int lengthOffset;
  final int widthOffset;

  Zone(this.length, this.width, this.lengthOffset, this.widthOffset);

  bool contains(Coordinates coordinates) {
    if (coordinates.x < lengthOffset || coordinates.x > lengthOffset + length)
      return false;
    if (coordinates.y < widthOffset || coordinates.y > widthOffset + width)
      return false;

    return true;
  }

  Iterable<Coordinates> get coordinates => List.generate(
    length * width,
    (i) => Coordinates(lengthOffset + i % length, widthOffset + i ~/ length)
  );
}