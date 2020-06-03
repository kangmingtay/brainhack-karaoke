class SongNameParser {
  static int songNameLengthLimit = 50;
  static String getSongName(String url) {
    try {
      const start = 'title=';
        final startIndex = url.indexOf(start);
        final lastCrossIndex = url.lastIndexOf('+');
        final endIndex = url.indexOf('&', lastCrossIndex);
        var stringSnip = url.substring(startIndex + start.length, endIndex);
        var rawSnipInList = stringSnip.split('+');
        var songnameInList = [];
        for (var i = 0; i < rawSnipInList.length; i ++) {
          if (!rawSnipInList[i].contains('%')) {
            songnameInList.add(rawSnipInList[i]);
          }
        }
        var songname = songnameInList.join(' ');
        return songname.length <= songNameLengthLimit ? songname : songname.substring(0,songNameLengthLimit - 3) + '...';
    } catch (e) {
      print('video url not from youtube, songname uses raw url');
      return url.length <= songNameLengthLimit ? url : url.substring(0,songNameLengthLimit - 3) + '...';
    }
  }
}