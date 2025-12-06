import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/note.dart';
import '../services/storage_service.dart';
import '../services/settings_service.dart';
import 'note_editor.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StorageService _storageService = StorageService();
  final SettingsService _settingsService = SettingsService();
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
    _settingsService.addListener(_updateUI);
    _settingsService.loadSettings();
  }

  @override
  void dispose() {
    _settingsService.removeListener(_updateUI);
    super.dispose();
  }

  void _updateUI() {
    setState(() {});
  }

  Future<void> _loadNotes() async {
    final notes = await _storageService.loadNotes();
    setState(() {
      _notes = notes;
    });
  }

  Future<void> _addOrEditNote({Note? note}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditor(note: note),
      ),
    );
    _loadNotes();
  }
  
  void _deleteNote(int index) async {
    setState(() {
      _notes.removeAt(index);
    });
    await _storageService.saveNotes(_notes);
  }

  @override
  Widget build(BuildContext context) {
    final bgPath = _settingsService.backgroundImagePath;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'My Notepad',
          style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (c) => const SettingsPage()));
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amberAccent,
        onPressed: () => _addOrEditNote(),
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: Stack(
        children: [
          if (bgPath != null)
            Positioned.fill(
              child: Image.file(
                File(bgPath),
                fit: BoxFit.cover,
              ),
            ),
          
          if (bgPath != null)
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.3)),
            ),

          SafeArea(
            child: _notes.isEmpty
                ? Center(
                    child: Text(
                      'Create your first note...',
                      style: GoogleFonts.outfit(color: Colors.white70, fontSize: 18),
                    ),
                  )
                : MasonryGridView.count(
                    padding: const EdgeInsets.all(12),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    itemCount: _notes.length,
                    itemBuilder: (context, index) {
                      final note = _notes[index];
                      final textColor = Color(note.color);

                      return GestureDetector(
                        onTap: () => _addOrEditNote(note: note),
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Delete Note?', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                              content: Text('Are you sure you want to delete this note?', style: GoogleFonts.outfit()),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context), 
                                  child: Text('Cancel', style: GoogleFonts.outfit(color: textColor))
                                ),
                                TextButton(
                                  onPressed: () {
                                    _deleteNote(index);
                                    Navigator.pop(context);
                                  }, 
                                  child: Text('Delete', style: GoogleFonts.outfit(color: Colors.red))
                                ),
                              ],
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[900]!.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.white.withOpacity(0.1)),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (note.imagePath != null)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        File(note.imagePath!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  if (note.imagePath != null) const SizedBox(height: 10),
                                  
                                  if (note.title.isNotEmpty)
                                    Text(
                                      note.title,
                                      style: GoogleFonts.outfit(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                    ),
                                  if (note.title.isNotEmpty) const SizedBox(height: 8),
                                  
                                  if (note.type == 'text')
                                    Linkify(
                                      onOpen: (link) async {
                                        if (!await launchUrl(Uri.parse(link.url), mode: LaunchMode.externalApplication)) {
                                          throw Exception('Could not launch ${link.url}');
                                        }
                                      },
                                      text: note.content,
                                      maxLines: 6,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.outfit(
                                        fontSize: 14,
                                        color: textColor.withOpacity(0.8),
                                      ),
                                      linkStyle: GoogleFonts.outfit(
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    )
                                  else if (note.checklistItems != null)
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: note.checklistItems!.take(3).map((item) => Row(
                                        children: [
                                          Icon(
                                            item.isDone ? Icons.check_box : Icons.check_box_outline_blank,
                                            size: 14,
                                            color: textColor.withOpacity(0.6),
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              item.text,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.outfit(
                                                fontSize: 12,
                                                color: textColor.withOpacity(0.8),
                                                decoration: item.isDone ? TextDecoration.lineThrough : null,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )).toList(),
                                    ),

                                  const SizedBox(height: 12),
                                  Text(
                                    DateFormat('MMM d, h:mm a').format(note.createdAt),
                                    style: GoogleFonts.outfit(
                                      fontSize: 10,
                                      color: Colors.white38,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
