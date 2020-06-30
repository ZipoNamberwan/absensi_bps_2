class Apputil {
  static String doubleRemoveZeroTrailing(double value) {
    return value.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
  }
}
