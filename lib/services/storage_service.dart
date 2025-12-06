import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

// This class handles saving and loading data
class StorageService {

  // Save list of notes
  Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    // Convert list to text
    final String data = json.encode(notes.map((e) => e.toMap()).toList());
    await prefs.setString('my_notes', data);
  }

  // Get list of notes
  Future<List<Note>> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('my_notes');
    
    if (data == null) {
      return []; // Return empty list if no data
    }

    // Convert text back to list
    final List<dynamic> mapList = json.decode(data);
    return mapList.map((e) => Note.fromMap(e)).toList();
  }
}
