import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/song_model.dart';
import '../provider/song_provider.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _artistController = TextEditingController();

  // Shows a dialog for adding or editing a song.
  void _showSongDialog(BuildContext context, {Song? song}) {
    if (song != null) {
      _titleController.text = song.title;
      _artistController.text = song.artist;
    } else {
      _titleController.clear();
      _artistController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(song == null ? 'Add Song' : 'Edit Song'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _artistController,
                  decoration: const InputDecoration(labelText: 'Artist'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an artist';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final SongProvider songProvider =
                      context.read<SongProvider>();
                  if (song == null) {
                    songProvider.addSong(
                      _titleController.text,
                      _artistController.text,
                    );
                  } else {
                    songProvider.updateSong(
                      song.id,
                      _titleController.text,
                      _artistController.text,
                    );
                  }
                  Navigator.pop(context);
                }
              },
              child: Text(song == null ? 'Add' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final songProvider = Provider.of<SongProvider>(context);

    Widget content = const Text('');
    if (songProvider.isLoading) {
      content = const CircularProgressIndicator();
    } else if (songProvider.hasData) {
      List<Song> songs = songProvider.songsState!.data!;

      if (songs.isEmpty) {
        content = const Text("No songs yet");
      } else {
        content = ListView.builder(
          itemCount: songs.length,
          itemBuilder:
              (context, index) => ListTile(
                title: Text(songs[index].title),
                subtitle: Text(songs[index].artist),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed:
                          () => _showSongDialog(context, song: songs[index]),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => songProvider.removeSong(songs[index].id),
                    ),
                  ],
                ),
              ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () => _showSongDialog(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Center(child: content),
    );
  }
}
