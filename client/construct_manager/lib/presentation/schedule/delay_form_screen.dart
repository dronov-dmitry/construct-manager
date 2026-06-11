import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/delay.dart';
import '../../data/services/schedule_service.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/error_screen.dart';

class DelayFormScreen extends StatefulWidget {
  final String constructionUid;
  final String scheduleUid;

  const DelayFormScreen({super.key, required this.constructionUid, required this.scheduleUid});

  @override
  State<DelayFormScreen> createState() => _DelayFormScreenState();
}

class _DelayFormScreenState extends State<DelayFormScreen> {
  final _titleController = TextEditingController();
  final _reasonController = TextEditingController();
  final _daysController = TextEditingController();
  final _additionalController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _service = ScheduleService();
  bool _isSaving = false;
  bool _isExcusable = false;
  bool _isCompensable = false;
  bool _isConcurrent = false;
  bool _isCritical = false;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final delay = Delay(
        constructionUid: widget.constructionUid,
        scheduleUid: widget.scheduleUid,
        title: _titleController.text.trim(),
        reason: _reasonController.text.trim(),
        isExcusable: _isExcusable,
        isCompensable: _isCompensable,
        isConcurrent: _isConcurrent,
        isCritical: _isCritical,
        days: int.tryParse(_daysController.text.trim()) ?? 0,
        additionalInfo: _additionalController.text.trim(),
      );
      await _service.writeDelay(delay);
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
    _reasonController.dispose();
    _daysController.dispose();
    _additionalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(s.add_delay)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: s.delay_title),
                validator: (v) => v == null || v.trim().isEmpty ? s.toast_fill_title : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _reasonController,
                decoration: InputDecoration(labelText: s.delay_reason),
                validator: (v) => v == null || v.trim().isEmpty ? s.toast_fill_reason : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _daysController,
                decoration: InputDecoration(labelText: s.days),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  FilterChip(
                    label: Text(s.excusable),
                    selected: _isExcusable,
                    onSelected: (v) => setState(() => _isExcusable = v),
                  ),
                  FilterChip(
                    label: Text(s.compensable),
                    selected: _isCompensable,
                    onSelected: (v) => setState(() => _isCompensable = v),
                  ),
                  FilterChip(
                    label: Text(s.concurrent),
                    selected: _isConcurrent,
                    onSelected: (v) => setState(() => _isConcurrent = v),
                  ),
                  FilterChip(
                    label: Text(s.critical),
                    selected: _isCritical,
                    onSelected: (v) => setState(() => _isCritical = v),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _additionalController,
                decoration: InputDecoration(labelText: s.additional_info),
                maxLines: 3,
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
