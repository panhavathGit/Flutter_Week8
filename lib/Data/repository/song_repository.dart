import '../../model/song_model.dart';

abstract class SongRepository {
  // Abstract methods for interacting with song data.
  Future<Song> addSong({required String title, required String artist});
  Future<List<Song>> getSongs();
  Future<void> removeSong(String id);
  Future<Song> updateSong({
    required String id,
    required String title,
    required String artist,
  });
}
