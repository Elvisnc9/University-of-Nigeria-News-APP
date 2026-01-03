import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:the_responsive_builder/the_responsive_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class UploadResourcePage extends StatefulWidget {
  const UploadResourcePage({super.key});

  @override
  State<UploadResourcePage> createState() => _UploadResourcePageState();
}

class _UploadResourcePageState extends State<UploadResourcePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  File? _selectedImage;
  bool _isUploading = false;

  final List<String> _allTags = [
    "Academics",
    "School Politics",
    "Week 3",
    "Past Events",
    "Authorities",
    "Trending",
    "Gender",
    "Investigation"
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

  /// PICK IMAGE
  Future<void> _onUploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        _selectedImage = File(result.files.single.path!);
      });
    }
  }

  /// UPLOAD ARTICLE
  Future<void> _submitArticle() async {
    if (_titleController.text.trim().isEmpty ||
        _descController.text.trim().isEmpty ||
        _selectedTags.isEmpty ||
        _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("All fields, tags, and image are required")),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      final user = FirebaseAuth.instance.currentUser!;

      /// Upload image to Firebase Storage
      final ref = FirebaseStorage.instance
          .ref()
          .child("article_images")
          .child("${DateTime.now().millisecondsSinceEpoch}.jpg");

      await ref.putFile(_selectedImage!);
      final imageUrl = await ref.getDownloadURL();

      /// Save article to Firestore with status = pending
      await FirebaseFirestore.instance.collection("articles").add({
        "title": _titleController.text.trim(),
        "description": _descController.text.trim(),
        "tags": _selectedTags,
        "imageUrl": imageUrl,
        "status": "pending",
        "authorId": user.uid,
        "authorName": user.displayName ?? "Unknown",
        "authorImage": user.photoURL ?? "",
        "timestamp": FieldValue.serverTimestamp(),
      });

      setState(() => _isUploading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Article submitted for admin approval")),
      );

      Navigator.pushNamed(context, '/home'); // go back after upload
    } catch (e) {
      setState(() => _isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
     leading:    IconButton(
          icon:  Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () { Navigator.pushNamed(context, '/home');}
        ),
        title: Text(
          'News Upload',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
       
      ),
      body: _isUploading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.red),
                  SizedBox(height: 16),
                  Text("Uploading article...",
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            )
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Card(
                    color: Colors.grey[900],
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Upload Article Photo",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.sp)),
                          SizedBox(height: 10),

                          /// Image preview
                          GestureDetector(
                            onTap: _onUploadFile,
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              color: Colors.grey,
                              dashPattern: [6, 3],
                              radius: Radius.circular(10),
                              child: Container(
                                width: double.infinity,
                                height: 180,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: _selectedImage == null
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.cloud_upload_rounded,
                                              size: 48, color: Colors.red),
                                          SizedBox(height: 10),
                                          Text("Tap to upload image",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ],
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(
                                          _selectedImage!,
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ),
                            ),
                          ),

                          SizedBox(height: 20),

                          /// Title
                          Text("Title",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 18.sp)),
                          TextField(
                            style: TextStyle(color: Colors.white),
                            controller: _titleController,
                            decoration: InputDecoration(
                              filled: true,
                              
                              fillColor: Colors.white10,
                              border: OutlineInputBorder(
                                
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none),
                              hintText: "News title",
                              hintStyle: TextStyle(color: Colors.white54),
                            ),
                          ),
                          SizedBox(height: 20),

                          /// Description
                          Text("Description",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 18.sp)),
                          TextField(
                            controller: _descController,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            maxLines: 10,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white10,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none),
                              hintText:
                                  "Write your full article content here...",
                              hintStyle: TextStyle(color: Colors.white54),
                            ),
                          ),

                          SizedBox(height: 20),

                          /// Tags
                          Text("Tags",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 18.sp)),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              ..._allTags.map((tag) => FilterChip(
                                    label: Text(tag),
                                    selected: _selectedTags.contains(tag),
                                    selectedColor: Colors.red,
                                    backgroundColor: Colors.grey,
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                    ),
                                    onSelected: (_) => _toggleTag(tag),
                                  )),
                              _AddTagChip(onNewTag: _addCustomTag),
                            ],
                          ),

                          SizedBox(height: 20),

                          /// Submit Button
                          GestureDetector(
                            onTap: _submitArticle,
                            child: Container(
                              height: 7.h,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(16)),
                              child: Center(
                                child: Text(
                                  "Submit for Approval",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
}
// Add Tag chip widget with dialog class _AddTagChip extends StatelessWidget { final Function(String) onNewTag; const _AddTagChip({required this.onNewTag}); @override Widget build(BuildContext context) { return ActionChip( avatar: Icon(Icons.add, size: 19, color: Colors.black), label: Text("Add Tag", style: TextStyle( color: Colors.black, fontWeight: FontWeight.w600, )), backgroundColor: Color(0xFFF3F6FC), onPressed: () async { final tag = await showDialog<String>( context: context, builder: (_) => _TagInputDialog(), ); if (tag != null && tag.trim().isNotEmpty) { onNewTag(tag.trim()); } }, ); } } class _TagInputDialog extends StatefulWidget { @override State<_TagInputDialog> createState() => _TagInputDialogState(); } class _TagInputDialogState extends State<_TagInputDialog> { final TextEditingController _controller = TextEditingController(); @override Widget build(BuildContext context) { return AlertDialog( backgroundColor: Colors.grey[900], title: Text( "Add a New Tag", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white), ), content: TextField( controller: _controller, decoration: InputDecoration(hintText: "Enter tag"), ), actions: [ TextButton( onPressed: () => Navigator.of(context).pop(), child: Text( "Cancel", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white), ), ), ElevatedButton( style: ButtonStyle( backgroundColor: MaterialStatePropertyAll(Colors.white), ), onPressed: () => Navigator.of(context).pop(_controller.text), child: Text( "Add", style: TextStyle(color: Colors.black), ), ), ]); }

class _AddTagChip extends StatelessWidget {
  final Function(String) onNewTag;
  const _AddTagChip({required this.onNewTag});
  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(Icons.add, size: 19, color: Colors.black),
      label: Text("Add Tag",
          style: TextStyle(
            color: Colors.black,
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
        backgroundColor: Colors.grey[900],
        title: Text(
          "Add a New Tag",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        content: TextField(
          controller: _controller,
          decoration: InputDecoration(hintText: "Enter tag"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              "Cancel",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.white),
            ),
            onPressed: () => Navigator.of(context).pop(_controller.text),
            child: Text(
              "Add",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ]);
  }
}
