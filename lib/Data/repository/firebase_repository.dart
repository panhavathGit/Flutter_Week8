import '../../model/song_model.dart';
import '../repository/song_repository.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../DTO/song_dto.dart';
class FirebaseSongRepository extends SongRepository {
  static const String baseUrl = 'https://week8-flutter-default-rtdb.asia-southeast1.firebasedatabase.app/';
  static const String songsCollection = "songs";
  static const String allSongsUrl = '$baseUrl/$songsCollection.json';

  Future<Song> addSong({required String title, required String artist}) async {
    Uri uri = Uri.parse(allSongsUrl);

    final newSongData = {'title': title, 'artist': artist};
    final http.Response response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(newSongData),
    );

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to add song');
    }

    final newId = json.decode(response.body)['name'];

    return Song(id: newId, title: title, artist: artist);
  }

  @override
  // Fetches all songs from Firebase.
  Future<List<Song>> getSongs() async {
    Uri uri = Uri.parse(allSongsUrl);
    final http.Response response = await http.get(uri);

    if (response.statusCode != HttpStatus.ok &&
        response.statusCode != HttpStatus.created) {
      throw Exception('Failed to load songs');
    }

    final dynamic decodedBody = json.decode(response.body); // Use dynamic

    if (decodedBody == null || decodedBody is! Map<String, dynamic>) {
      // Handle cases where the response is not a valid map
      if (decodedBody is String) {
        print(
          "Firebase returned a string, likely the database node is empty, or has a string value",
        );
      }
      return []; // Return an empty list if the data is invalid
    }

    final data = decodedBody;

    return data.entries
        .map((entry) => SongDto.fromJson(entry.key, entry.value))
        .toList();
  }

  @override
  // Removes a song from Firebase.
  Future<void> removeSong(String id) async {
    final uri = Uri.parse('$baseUrl/$songsCollection/$id.json');
    final response = await http.delete(uri);

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to remove song');
    }
  }

  @override
  // Updates a song in Firebase.
  Future<Song> updateSong({
    required String id,
    required String title,
    required String artist,
  }) async {
    final uri = Uri.parse('$baseUrl/$songsCollection/$id.json');
    final updatedSongData = {'title': title, 'artist': artist};
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updatedSongData),
    );

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to update song');
    }

    return Song(id: id, title: title, artist: artist);
  }
}
