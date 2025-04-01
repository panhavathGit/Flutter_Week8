import '../model/song_model.dart';
import 'package:flutter/material.dart';
import '../Data/repository/async_value.dart';

import '../Data/repository/song_repository.dart';

class SongProvider extends ChangeNotifier {
  final SongRepository _repository;
  AsyncValue<List<Song>>? songsState;

  SongProvider(this._repository) {
    fetchSongs();
  }

  bool get isLoading =>
      songsState != null && songsState!.state == AsyncValueState.loading;
  bool get hasData =>
      songsState != null && songsState!.state == AsyncValueState.success;

  void fetchSongs() async {
    try {
      songsState = AsyncValue.loading();
      notifyListeners();

      songsState = AsyncValue.success(await _repository.getSongs());

      print("SUCCESS: list size ${songsState!.data!.length.toString()}");
    } catch (error) {
      print("ERROR: $error");
      songsState = AsyncValue.error(error);
    }

    notifyListeners();
  }

  // Adds a song with optimistic update and error recovery.
  void addSong(String title, String artist) async {
    final newSong = Song(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      artist: artist,
    ); // Create a temporary song with a temp ID.

    //Add the song to the UI immediately.
    if (songsState != null && songsState!.state == AsyncValueState.success) {
      songsState!.data!.add(newSong);
    } else {
      songsState = AsyncValue.success([newSong]);
    }
    notifyListeners();

    try {
      final serverSong = await _repository.addSong(
        title: title,
        artist: artist,
      );
      //replace the temp id for the real id
      final index = songsState!.data!.indexWhere(
        (song) => song.id == newSong.id,
      );
      if (index != -1) {
        songsState!.data![index] = serverSong;
        notifyListeners();
      }
    } catch (e) {
      print("ERROR adding song: $e");
      // Revert the optimistic update if it fails.
      songsState!.data!.remove(newSong);
      notifyListeners();
      fetchSongs();
    }
  }
    // Removes a song with optimistic update and error recovery.
  void removeSong(String id) async {
    final removedSong = songsState!.data!.firstWhere(
      (song) => song.id == id,
    ); //get the removed song.
    //Remove the song from the UI immediately.
    songsState!.data!.removeWhere((song) => song.id == id);
    notifyListeners();

    try {
      await _repository.removeSong(id);
    } catch (e) {
      print("ERROR removing song: $e");
      // Revert the optimistic update if it fails.
      songsState!.data!.add(removedSong);
      notifyListeners();
      fetchSongs();
    }
  }

  // Updates a song with optimistic update and error recovery.
  void updateSong(String id, String title, String artist) async {
    final oldSong = songsState!.data!.firstWhere((song) => song.id == id);
    final updatedSong = Song(id: id, title: title, artist: artist);
    final index = songsState!.data!.indexWhere((song) => song.id == id);
    if (index != -1) {
      songsState!.data![index] = updatedSong;
      notifyListeners();
    }
    try {
      await _repository.updateSong(id: id, title: title, artist: artist);
    } catch (e) {
      print("ERROR updating song: $e");
      songsState!.data![index] = oldSong;
      notifyListeners();
      fetchSongs();
    }
  }
}
