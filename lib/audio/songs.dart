
const Set<Song> songs = {
  Song('theme_music.mp3', 'Theme music', artist: 'GioeleFazzeri'),

};

class Song {
  final String filename;

  final String name;

  final String? artist;

  const Song(this.filename, this.name, {this.artist});

  @override
  String toString() => 'Song<$filename>';
}
