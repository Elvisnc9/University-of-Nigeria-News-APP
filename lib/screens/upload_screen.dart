import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class UploadResourcePage extends StatefulWidget {
  const UploadResourcePage({super.key});

  @override
  State<UploadResourcePage> createState() => _UploadResourcePageState();
}

class _UploadResourcePageState extends State<UploadResourcePage> {
  String? _selectedCourse;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final List<String> _allTags = [
    "Assignment",
    "Lecture Notes",
    "Week 3",
    "Past Questions",
    "Test Review",
    "Midterm",
    "Final Exam",
    "Lab Report"
  ];
  final List<String> _selectedTags = [];

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  void _addCustomTag(String tag) {
    if (tag.isNotEmpty && !_allTags.contains(tag)) {
      setState(() {
        _allTags.add(tag);
        _selectedTags.add(tag);
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  // Dummy upload file handler
  void _onUploadFile() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Upload Resource',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Steps Navigation (for visual, not functional in this example)
          Card(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            margin: EdgeInsets.only(bottom: 18),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _stepIndicator("Course", true),
                  _stepIndicator("Details", false),
                  _stepIndicator("Tags", false),
                  _stepIndicator("Submit", false),
                ],
              ),
            ),
          ),
          // Upload Form
          Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Select Course
                  Text("Select Course *",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  SizedBox(height: 8),
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Color(0xFFF3F6FC),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedCourse,
                        hint: Text("Select Course",
                            style: TextStyle(color: Colors.grey[700])),
                        items: ["Cos 414", "MTH 102", "PHY 220"]
                            .map((e) => DropdownMenuItem<String>(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => _selectedCourse = v),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Title
                  Text("Resource Title *",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  SizedBox(height: 8),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: "e.g., Lecture Notes on Data Structures",
                      fillColor: Color(0xFFF3F6FC),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Description
                  Text("Description",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  SizedBox(height: 8),
                  TextField(
                    controller: _descController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Add a short description of the material...",
                      fillColor: Color(0xFFF3F6FC),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Tags
                  Text("Tags",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      ..._allTags.map((tag) => FilterChip(
                            label: Text(tag),
                            selected: _selectedTags.contains(tag),
                            selectedColor: Color(0xFFDFECFF),
                            backgroundColor: Color(0xFFF3F6FC),
                            labelStyle: TextStyle(
                                color: _selectedTags.contains(tag)
                                    ? Color(0xFF156BFF)
                                    : Colors.black),
                            onSelected: (_) => _toggleTag(tag),
                          )),
                      _AddTagChip(onNewTag: _addCustomTag),
                    ],
                  ),
                  SizedBox(height: 24),
                  // Upload File
                  Text("Upload File *",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: _onUploadFile,
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      color: Color(0xFF156BFF),
                      dashPattern: [6, 3],
                      radius: Radius.circular(10),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 28),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color(0xFFF8FBFF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.cloud_upload_rounded,
                                size: 48, color: Color(0xFF156BFF)),
                            SizedBox(height: 10),
                            Text("Tap to upload file",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 14)),
                            SizedBox(height: 7),
                            Text("PDF, DOCX, PPT, Images",
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 13)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Color(0xFF156BFF),
        child: Icon(Icons.add, color: Colors.white, size: 32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _bottomNavItem(Icons.home_rounded, "Home"),
              _bottomNavItem(Icons.chat_bubble_rounded, "Message"),
              SizedBox(width: 48), // Space for FAB
              _bottomNavItem(Icons.bookmark, "Bookmarks"),
              _bottomNavItem(Icons.person_rounded, "Profile"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stepIndicator(String title, bool active) {
    return Column(
      children: [
        CircleAvatar(
          radius: 13,
          backgroundColor: active ? Color(0xFF156BFF) : Color(0xFFE8EAF0),
          child:
              active ? Icon(Icons.check, color: Colors.white, size: 17) : null,
        ),
        SizedBox(height: 4),
        Text(title,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black)),
      ],
    );
  }

  Widget _bottomNavItem(IconData icon, String label) {
    return Expanded(
      child: InkWell(
        customBorder:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Color(0xFF575D6A)),
              Text(label,
                  style: TextStyle(
                    color: Color(0xFF575D6A),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

// Add Tag chip widget with dialog
class _AddTagChip extends StatelessWidget {
  final Function(String) onNewTag;
  const _AddTagChip({required this.onNewTag});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(Icons.add, size: 19, color: Color(0xFF156BFF)),
      label: Text("Add Tag",
          style: TextStyle(
            color: Color(0xFF156BFF),
            fontWeight: FontWeight.w600,
          )),
      backgroundColor: Color(0xFFF3F6FC),
      onPressed: () async {
        final tag = await showDialog<String>(
          context: context,
          builder: (_) => _TagInputDialog(),
        );
        if (tag != null && tag.trim().isNotEmpty) {
          onNewTag(tag.trim());
        }
      },
    );
  }
}

class _TagInputDialog extends StatefulWidget {
  @override
  State<_TagInputDialog> createState() => _TagInputDialogState();
}

class _TagInputDialogState extends State<_TagInputDialog> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text("New Tag"),
        content: TextField(
          controller: _controller,
          decoration: InputDecoration(hintText: "Enter tag"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(_controller.text),
            child: Text("Add"),
          ),
        ]);
  }
}
