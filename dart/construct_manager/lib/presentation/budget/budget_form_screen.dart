import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/budget.dart';
import '../../data/services/budget_service.dart';
import '../../l10n/app_localizations.dart';

class BudgetFormScreen extends StatefulWidget {
  final String constructionUid;
  final Budget? existing;

  const BudgetFormScreen({super.key, required this.constructionUid, this.existing});

  @override
  State<BudgetFormScreen> createState() => _BudgetFormScreenState();
}

class _BudgetFormScreenState extends State<BudgetFormScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _valueController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _service = BudgetService();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      _titleController.text = widget.existing!.title;
      _descController.text = widget.existing!.desc;
      _valueController.text = widget.existing!.value.toString();
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final budget = Budget(
        constructionUid: widget.constructionUid,
        title: _titleController.text.trim(),
        desc: _descController.text.trim(),
        value: double.parse(_valueController.text.trim()),
        budgetUid: widget.existing?.budgetUid ?? '',
      );
      await _service.writeBudget(budget);
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
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(widget.existing != null ? s.edit_budget : s.add_budget)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: s.budget_title),
                validator: (v) => v == null || v.trim().isEmpty ? s.toast_fill_title : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(labelText: s.budget_description),
                validator: (v) => v == null || v.trim().isEmpty ? s.toast_fill_description : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _valueController,
                decoration: InputDecoration(labelText: s.budget_value),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return s.toast_fill_value;
                  if (double.tryParse(v.trim()) == null) return s.toast_value_only_numbers;
                  return null;
                },
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
