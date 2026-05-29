import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/network/supabase_client.dart';
import '../../core/utils/validators.dart';
import '../../data/models/user.dart';
import '../../data/services/construction_service.dart';
import '../../data/services/user_service.dart';
import '../../l10n/app_localizations.dart';

class ConstructionFormScreen extends StatefulWidget {
  const ConstructionFormScreen({super.key});

  @override
  State<ConstructionFormScreen> createState() => _ConstructionFormScreenState();
}

class _ConstructionFormScreenState extends State<ConstructionFormScreen> {
  final _titleController = TextEditingController();
  final _addressController = TextEditingController();
  final _typeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isSaving = false;

  final _constructionService = ConstructionService();
  final _userService = UserService();
  List<User> _availableUsers = [];
  final List<User> _selectedUsers = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    try {
      final users = await _userService.getAllUsers();
      setState(() => _availableUsers = users);
    } catch (_) {}
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final userId = SupabaseClientManager.instance.client.auth.currentUser!.id;
      await _constructionService.writeConstruction(
        userId,
        _titleController.text.trim(),
        _addressController.text.trim(),
        'ПОДГОТОВКА',
        _typeController.text.trim(),
        _selectedUsers,
        null,
      );
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _addressController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(s.create_project)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: s.project_title,
                        prefixIcon: const Icon(Icons.title),
                      ),
                      validator: (v) {
                        final err = Validators.required(v, s.toast_fill_title);
                        return err == s.toast_fill_title ? s.toast_fill_title : null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: s.project_address,
                        prefixIcon: const Icon(Icons.location_on),
                      ),
                      validator: (v) {
                        final err = Validators.required(v, s.toast_fill_address);
                        return err == s.toast_fill_address ? s.toast_fill_address : null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _typeController,
                      decoration: InputDecoration(
                        labelText: s.project_type,
                        prefixIcon: const Icon(Icons.category),
                      ),
                      validator: (v) {
                        final err = Validators.required(v, s.toast_fill_construction_type);
                        return err == s.toast_fill_construction_type
                            ? s.toast_fill_construction_type
                            : null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: s.select_responsible,
                        prefixIcon: const Icon(Icons.person),
                      ),
                      items: _availableUsers
                          .where((u) => !_selectedUsers.any((s) => s.uid == u.uid))
                          .map((u) => DropdownMenuItem(
                                value: u.email,
                                child: Text('${u.name} (${u.email})'),
                              ))
                          .toList(),
                      onChanged: (email) {
                        if (email != null) {
                          final user = _availableUsers.firstWhere((u) => u.email == email);
                          setState(() => _selectedUsers.add(user));
                        }
                      },
                    ),
                    if (_selectedUsers.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: _selectedUsers.map((u) {
                          return Chip(
                            label: Text(u.name),
                            onDeleted: () {
                              setState(() => _selectedUsers.remove(u));
                            },
                          );
                        }).toList(),
                      ),
                    ],
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isSaving ? null : _save,
                      child: _isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(s.save),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
