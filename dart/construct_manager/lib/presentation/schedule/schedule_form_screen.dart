import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/services/schedule_service.dart';
import '../../l10n/app_localizations.dart';

class ScheduleFormScreen extends StatefulWidget {
  final String constructionUid;

  const ScheduleFormScreen({super.key, required this.constructionUid});

  @override
  State<ScheduleFormScreen> createState() => _ScheduleFormScreenState();
}

class _ScheduleFormScreenState extends State<ScheduleFormScreen> {
  final _titleController = TextEditingController();
  final _deadlineController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _service = ScheduleService();
  bool _isSaving = false;
  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (date != null) {
      _deadlineController.text = '${date.day}/${date.month}/${date.year}';
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      await _service.writeSchedule(
        widget.constructionUid,
        _titleController.text.trim(),
        _deadlineController.text.trim(),
        'ON_SCHEDULE',
        null,
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
    _deadlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(s.add_schedule)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: s.schedule_title),
                validator: (v) => v == null || v.trim().isEmpty ? s.toast_fill_title : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _deadlineController,
                decoration: InputDecoration(
                  labelText: s.deadline,
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: _pickDate,
                validator: (v) => v == null || v.trim().isEmpty ? s.toast_fill_deadline : null,
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
