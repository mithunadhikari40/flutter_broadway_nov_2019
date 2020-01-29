class PathHelper {
  static String removeInvalidCharactersForFirebase(String path) {
    /*
    '.', '#', '$', '[', or ']'
     */
    path = path
        .replaceAll(".", "")
        .replaceAll("#", "")
        .replaceAll("[", "")
        .replaceAll("]", "");
    return path;
  }
}
