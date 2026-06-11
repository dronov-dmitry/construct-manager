import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/schedule.dart';
import '../../data/services/schedule_service.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/error_screen.dart';

class ScheduleFormScreen extends StatefulWidget {
  final String constructionUid;
  final Schedule? schedule;

  const ScheduleFormScreen({
    super.key,
    required this.constructionUid,
    this.schedule,
  });

  @override
  State<ScheduleFormScreen> createState() => _ScheduleFormScreenState();
}

class _ScheduleFormScreenState extends State<ScheduleFormScreen> {
  final _titleController = TextEditingController();
  final _startController = TextEditingController();
  final _deadlineController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _service = ScheduleService();
  bool _isSaving = false;

  bool get _isEditing => widget.schedule != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final s = widget.schedule!;
      _titleController.text = s.title;
      _startController.text = s.startDate ?? '';
      _deadlineController.text = s.deadline;
    }
  }

  Future<void> _pickDate(TextEditingController ctrl) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );
    if (date != null) {
      ctrl.text = '${date.day}/${date.month}/${date.year}';
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
        startDate: _startController.text.trim().isEmpty
            ? null
            : _startController.text.trim(),
        scheduleUid: _isEditing ? widget.schedule!.scheduleUid : null,
      );
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) context.pop();
        });
      }
    } catch (e, st) {
      if (mounted) ErrorReportDialog.show(context, error: e, stack: st);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _startController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Редактировать задачу' : s.add_schedule)),
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
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _save(),
                validator: (v) => v == null || v.trim().isEmpty ? s.toast_fill_title : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _startController,
                decoration: InputDecoration(
                  labelText: s.start_date,
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _pickDate(_startController),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _deadlineController,
                decoration: InputDecoration(
                  labelText: s.deadline,
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _pickDate(_deadlineController),
                validator: (v) => v == null || v.trim().isEmpty ? s.toast_fill_deadline : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(_isEditing ? 'Сохранить изменения' : s.save),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
