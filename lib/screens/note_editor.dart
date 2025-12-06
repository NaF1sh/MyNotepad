import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../models/note.dart';
import '../services/storage_service.dart';
import 'package:google_fonts/google_fonts.dart';

class NoteEditor extends StatefulWidget {
  final Note? note;

  const NoteEditor({Key? key, this.note}) : super(key: key);

  @override
  _NoteEditorState createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  String? _imagePath;
  final StorageService _storageService = StorageService();

  // V2 State
  bool _isChecklist = false;
  List<ChecklistItem> _checklistItems = [];
  int _textColor = 0xFFFFFFFF; // Default White

  final List<int> _colors = [
    0xFFFFFFFF, // White
    0xFFFF8A80, // Red
    0xFFFFFF8D, // Yellow
    0xFFCCFF90, // Green
    0xFFA7FFEB, // Teal
    0xFF80D8FF, // Blue
    0xFFCFD8DC, // Grey
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    _imagePath = widget.note?.imagePath;
    
    // Load V2 Data
    _isChecklist = widget.note?.type == 'checklist';
    
    // Set default color
    if (widget.note?.color != null) {
      _textColor = widget.note!.color;
    }
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize color if it's a new note
    if (widget.note == null && _textColor == 0xFFFFFFFF) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      if (!isDark) {
        _textColor = 0xFF000000; // Default to Black for Light Theme
      }
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  // Auto-save logic
  Future<void> _saveNote() async {
    if (_titleController.text.trim().isEmpty &&
        !_isChecklist && _contentController.text.trim().isEmpty &&
        _isChecklist && _checklistItems.isEmpty &&
        _imagePath == null) {
      return;
    }

    final newNote = Note(
      id: widget.note?.id ?? const Uuid().v4(),
      title: _titleController.text,
      content: _isChecklist ? '' : _contentController.text, // If checklist, ignore content text
      imagePath: _imagePath,
      createdAt: widget.note?.createdAt ?? DateTime.now(),
      type: _isChecklist ? 'checklist' : 'text',
      checklistItems: _checklistItems,
      color: _textColor,
    );

    List<Note> notes = await _storageService.loadNotes();
    int index = notes.indexWhere((n) => n.id == newNote.id);
    
    if (index != -1) {
      notes[index] = newNote;
    } else {
      notes.add(newNote);
    }
    
    await _storageService.saveNotes(notes);
  }
  
  void _addChecklistItem() {
    setState(() {
      _checklistItems.add(ChecklistItem(text: ''));
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
         if (didPop) return;
         await _saveNote();
         if (context.mounted) Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor, 
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
            onPressed: () => Navigator.maybePop(context),
          ),
          actions: [
            // Color Picker
            PopupMenuButton<int>(
              icon: Icon(Icons.color_lens, color: Theme.of(context).iconTheme.color),
              onSelected: (color) {
                setState(() => _textColor = color);
              },
              itemBuilder: (context) => _colors.map((c) => PopupMenuItem(
                value: c,
                child: Container(width: 24, height: 24, color: Color(c)),
              )).toList(),
            ),
            // Toggle Checklist
            IconButton(
              icon: Icon(_isChecklist ? Icons.text_fields : Icons.check_box, color: Theme.of(context).iconTheme.color),
              onPressed: () {
                setState(() => _isChecklist = !_isChecklist);
              },
              tooltip: _isChecklist ? 'Switch to Text' : 'Switch to Checklist',
            ),
            IconButton(
              icon: Icon(Icons.attach_file, color: Theme.of(context).iconTheme.color),
              onPressed: _pickImage,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               if (_imagePath != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: FileImage(File(_imagePath!)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              TextField(
                controller: _titleController,
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(_textColor), // Applies Color
                ),
                decoration: const InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 10),
              
              if (!_isChecklist)
                TextField(
                  controller: _contentController,
                  maxLines: null,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    color: Color(_textColor).withOpacity(0.9),
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Type something...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                )
              else
                Column(
                  children: [
                    ..._checklistItems.map((item) {
                      return Row(
                        children: [
                          Checkbox(
                            value: item.isDone,
                            onChanged: (val) {
                              setState(() => item.isDone = val ?? false);
                            },
                            activeColor: Color(_textColor),
                            checkColor: Colors.black,
                            side: BorderSide(color: Color(_textColor)),
                          ),
                          Expanded(
                            child: TextField(
                              controller: TextEditingController(text: item.text)
                                ..selection = TextSelection.fromPosition(TextPosition(offset: item.text.length)),
                              onChanged: (val) => item.text = val,
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                color: item.isDone ? Colors.grey : Color(_textColor),
                                decoration: item.isDone ? TextDecoration.lineThrough : null,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Item...',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.grey, size: 20),
                            onPressed: () {
                              setState(() => _checklistItems.remove(item));
                            },
                          )
                        ],
                      );
                    }).toList(),
                    TextButton.icon(
                      onPressed: _addChecklistItem,
                      icon: Icon(Icons.add, color: Color(_textColor)),
                      label: Text('Add Item', style: TextStyle(color: Color(_textColor))),
                    )
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
