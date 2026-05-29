import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/services/responsibility_service.dart';
import '../../l10n/app_localizations.dart';

class ResponsibilityFormScreen extends StatefulWidget {
  final String constructionUid;

  const ResponsibilityFormScreen({super.key, required this.constructionUid});

  @override
  State<ResponsibilityFormScreen> createState() => _ResponsibilityFormScreenState();
}

class _ResponsibilityFormScreenState extends State<ResponsibilityFormScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _deadlineController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _service = ResponsibilityService();
  bool _isSaving = false;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      await _service.writeResponsibility(
        widget.constructionUid,
        null,
        _titleController.text.trim(),
        _descController.text.trim(),
        _deadlineController.text.trim(),
        'OPEN',
        _emailController.text.trim(),
      );
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _deadlineController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(s.add_responsibility)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: s.responsibility_title),
                validator: (v) => v == null || v.trim().isEmpty ? s.toast_fill_title : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(labelText: s.responsibility_description),
                validator: (v) => v == null || v.trim().isEmpty ? s.toast_fill_description : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _deadlineController,
                decoration: InputDecoration(labelText: s.deadline),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: s.responsible_email),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(s.save),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
