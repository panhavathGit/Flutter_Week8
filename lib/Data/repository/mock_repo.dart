import '../../model/song_model.dart';
import './song_repository.dart';
class MockSongRepository extends SongRepository {
  final List<Song> songs = [];

  @override
  Future<Song> addSong({required String title, required String artist}) {
    return Future.delayed(Duration(seconds: 1), () {
      Song newSong = Song(id: "0", title: title, artist: artist);
      songs.add(newSong);
      return newSong;
    });
  }

  @override
  Future<List<Song>> getSongs() {
    return Future.delayed(Duration(seconds: 1), () => songs);
  }

  @override
  Future<void> removeSong(String id) {
    return Future.delayed(Duration(seconds: 1), () {
      songs.removeWhere((song) => song.id == id);
    });
  }

  @override
  Future<Song> updateSong({
    required String id,
    required String title,
    required String artist,
  }) {
    return Future.delayed(Duration(seconds: 1), () {
      final index = songs.indexWhere((song) => song.id == id);
      if (index != -1) {
        songs[index] = Song(id: id, title: title, artist: artist);
        return songs[index];
      } else {
        throw Exception('Song not found');
      }
    });
  }
}