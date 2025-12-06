import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

class StorageService {

  Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final String data = json.encode(notes.map((e) => e.toMap()).toList());
    await prefs.setString('my_notes', data);
  }

  Future<List<Note>> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('my_notes');
    
    if (data == null) {
      return [];
    }

    final List<dynamic> mapList = json.decode(data);
    return mapList.map((e) => Note.fromMap(e)).toList();
  }
}
