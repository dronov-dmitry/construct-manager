import 'package:flutter/material.dart';

import '../../data/services/construction_service.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/error_screen.dart';

class InfoEditScreen extends StatefulWidget {
  final String constructionUid;

  const InfoEditScreen({super.key, required this.constructionUid});

  @override
  State<InfoEditScreen> createState() => _InfoEditScreenState();
}

class _InfoEditScreenState extends State<InfoEditScreen> {
  final _titleController = TextEditingController();
  final _addressController = TextEditingController();
  final _typeController = TextEditingController();
  final _notesController = TextEditingController();
  final _service = ConstructionService();
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final c = await _service.getConstruction(widget.constructionUid);
      if (c != null) {
        _titleController.text = c.title;
        _addressController.text = c.address;
        _typeController.text = c.type;
        _notesController.text = c.information;
      }
    } catch (e, st) {
      if (mounted) ErrorReportDialog.show(context, error: e, stack: st);
    }
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      await _service.updateConstruction(widget.constructionUid,
        title: _titleController.text,
        address: _addressController.text,
        type: _typeController.text,
        information: _notesController.text,
      );
      if (mounted) Navigator.pop(context);
    } catch (e, st) {
      if (mounted) ErrorReportDialog.show(context, error: e, stack: st);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _addressController.dispose();
    _typeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;

    if (_isLoading) return Scaffold(body: const Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        title: Text(s.information),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : Text(s.save_changes),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: s.project_title),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(labelText: s.project_address),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _typeController,
              decoration: InputDecoration(labelText: s.project_type),
            ),
            const SizedBox(height: 24),
            Text(s.notes, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter notes...',
              ),
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }
}
