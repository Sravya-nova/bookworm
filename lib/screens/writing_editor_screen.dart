import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/network_service.dart';
import '../models/author_models.dart';
import '../theme/bookworm_colors.dart';

class WritingEditorScreen extends StatefulWidget {
  final Draft? draft;
  const WritingEditorScreen({super.key, this.draft});

  @override
  State<WritingEditorScreen> createState() => _WritingEditorScreenState();
}

class _WritingEditorScreenState extends State<WritingEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  final _networkService = NetworkService();
  String? _draftId;
  Timer? _autoSaveTimer;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _draftId = widget.draft?.id;
    _titleController = TextEditingController(text: widget.draft?.title ?? 'Untitled Masterpiece');
    _contentController = TextEditingController(text: widget.draft?.content ?? '');

    _titleController.addListener(_onContentChanged);
    _contentController.addListener(_onContentChanged);
  }

  void _onContentChanged() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(const Duration(seconds: 3), _saveDraft);
  }

  Future<void> _saveDraft() async {
    if (_titleController.text.isEmpty && _contentController.text.isEmpty) return;
    if (!mounted) return;
    
    setState(() => _isSaving = true);
    try {
      final id = await _networkService.saveDraft(
        id: _draftId,
        title: _titleController.text,
        content: _contentController.text,
        progress: _calculateProgress(),
      );
      if (mounted) {
        _draftId = id;
      }
    } catch (e) {
      debugPrint('Auto-save failed: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  double _calculateProgress() {
    final len = _contentController.text.length;
    return (len / 1000).clamp(0.0, 1.0);
  }

  Future<void> _publish() async {
    await _saveDraft();
    await _networkService.notifyWorkPublished();
    
    if (mounted) {
      Navigator.pop(context, true); 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Work published and synced to your profile!')),
      );
    }
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    // Ensure final save on dispose if dirty
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          // If we are popping, perform a final save
          await _saveDraft();
        }
      },
      child: Scaffold(
        backgroundColor: BookwormColors.background,
        appBar: AppBar(
          title: Row(
            children: [
              Text('Writing Studio', style: GoogleFonts.notoSerif()),
              if (_isSaving) ...[
                const SizedBox(width: 12),
                const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ],
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () async {
                await _saveDraft();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Draft saved')),
                  );
                }
              },
            ),
            TextButton(
              onPressed: _publish,
              child: const Text('PUBLISH', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: TextField(
                controller: _titleController,
                style: GoogleFonts.notoSerif(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  hintText: 'Title...',
                  border: InputBorder.none,
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: TextField(
                  controller: _contentController,
                  maxLines: null,
                  expands: true,
                  style: const TextStyle(fontSize: 18, height: 1.6),
                  decoration: const InputDecoration(
                    hintText: 'Start writing your story here...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
