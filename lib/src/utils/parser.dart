
class SongNameParser {
  static int songNameLengthLimit = 70;
  static String getSongName(String url) {
    try {
      const start = 'title=';
        final startIndex = url.indexOf(start);
        final lastCrossIndex = url.lastIndexOf('+');
        final endIndex = url.indexOf('&', lastCrossIndex);
        var stringSnip = url.substring(startIndex + start.length, endIndex);
        var uriDecodedString = Uri.decodeFull(stringSnip);
        var songname = uriDecodedString.replaceAll('+', ' ');
        return songname.length <= songNameLengthLimit ? songname : songname.substring(0,songNameLengthLimit - 3) + '...';
    } catch (e) {
      print('video url not from youtube, songname uses raw url');
      return url.length <= songNameLengthLimit ? url : url.substring(0,songNameLengthLimit - 3) + '...';
    }
  }
}