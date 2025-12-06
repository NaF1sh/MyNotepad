import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../services/settings_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingsService _settings = SettingsService();

  Future<void> _pickBackground() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      await _settings.setBackgroundImage(image.path);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // Basic color setup
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // SIMPLE SCROLLABLE LIST
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. HEADER
          Center(
            child: Text(
              'Select Theme', 
              style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)
            ),
          ),
          const SizedBox(height: 20),

          // 2. THEME GRID (Simple Container)
          GridView.count(
            shrinkWrap: true, // IMPORTANT: Allows Grid inside List
            physics: const NeverScrollableScrollPhysics(), // Disable grid's own scrolling
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.5,
            children: [
               _buildThemeCard('Dracula', 'dracula', const Color(0xFF282a36), const Color(0xFFbd93f9)),
               _buildThemeCard('Nord', 'nord', const Color(0xFF2e3440), const Color(0xFF88c0d0)),
               _buildThemeCard('Sunset', 'sunset', const Color(0xFF2d1b2e), const Color(0xFFfd5e53)),
               _buildThemeCard('ThinkPad', 'thinkpad', const Color(0xFF101010), const Color(0xFFFF0000)),
               _buildThemeCard('Dark', 'dark', Colors.black, Colors.amber),
               _buildThemeCard('White', 'light', Colors.white, Colors.black),
               _buildThemeCard('Kawaii', 'kawaii', const Color(0xFFFFF0F5), Colors.pinkAccent),
               _buildThemeCard('Cyberpunk', 'cyberpunk', const Color(0xFF0D0221), Colors.cyanAccent),
               _buildThemeCard('Coffee', 'coffee', const Color(0xFFEFEBE9), const Color(0xFF4E342E)),
               _buildThemeCard('Coder', 'coder', Colors.black, Colors.greenAccent),
               _buildThemeCard('Minimal', 'minimal', Colors.white, Colors.black),
               _buildThemeCard('Sky', 'sky', const Color(0xFFE3F2FD), Colors.blue),
               _buildThemeCard('Nature', 'nature', const Color(0xFF1B5E20), Colors.lightGreenAccent),
               _buildThemeCard('Matrix', 'coder', Colors.black, Colors.green),
               _buildThemeCard('Slate', 'minimal_more', const Color(0xFF263238), const Color(0xFFB0BEC5)),
               _buildThemeCard('Device', 'system', Colors.grey.shade800, Colors.white),
            ],
          ),

          const SizedBox(height: 30),
          const Divider(),
          const SizedBox(height: 10),

          // 3. BACKGROUND IMAGE SETTINGS
          ListTile(
            title: Text('Custom Background', style: GoogleFonts.outfit(color: textColor, fontWeight: FontWeight.bold)),
            subtitle: Text('Tap to choose image', style: TextStyle(color: textColor.withOpacity(0.6))),
            trailing: Icon(Icons.image, color: textColor),
            onTap: _pickBackground,
          ),
          
          if (_settings.backgroundImagePath != null)
             TextButton.icon(
               label: Text('Remove Background', style: GoogleFonts.outfit(color: Colors.redAccent)),
               icon: const Icon(Icons.delete, color: Colors.redAccent),
               onPressed: () async {
                 await _settings.setBackgroundImage(null);
                 setState(() {});
               },
             ),

          // 4. ABOUT SECTION
          ListTile(
            leading: Icon(Icons.info_outline, color: textColor),
            title: Text('About', style: GoogleFonts.outfit(color: textColor, fontWeight: FontWeight.bold)),
            subtitle: Text('Credits', style: TextStyle(color: textColor.withOpacity(0.6))),
            onTap: () {
               showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('About'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Created by:'),
                      Text('Syed Nafish Shakir', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Tonmoy Sarker', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text('https://github.com/NaF1sh/MyNotepad', style: TextStyle(color: Colors.blue)),
                    ],
                  ),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: Text('Close'))
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 50), // Extra space at bottom
        ],
      ),
    );
  }

  // Simple Helper Widget for Theme Cards
  Widget _buildThemeCard(String name, String mode, Color bg, Color accent) {
    bool isSelected = _settings.themeMode == mode;
    
    return GestureDetector(
      onTap: () {
        _settings.setTheme(mode);
        setState(() {}); // Refresh screen
      },
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.amber : Colors.grey, 
            width: isSelected ? 3 : 1
          ),
        ),
        child: Center(
          child: Text(
            name,
            style: TextStyle(
              color: bg.computeLuminance() > 0.5 ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}
