import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../data/models/photo.dart';
import '../../data/services/photo_service.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/empty_state.dart';

class PhotoListScreen extends StatefulWidget {
  final String constructionUid;

  const PhotoListScreen({super.key, required this.constructionUid});

  @override
  State<PhotoListScreen> createState() => _PhotoListScreenState();
}

class _PhotoListScreenState extends State<PhotoListScreen> {
  final _service = PhotoService();
  List<Photo> _photos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final photos = await _service.getPhotos(widget.constructionUid);
      setState(() => _photos = photos);
    } catch (_) {}
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _delete(Photo photo) async {
    try {
      await _service.deletePhoto(photo.uid, widget.constructionUid);
      _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  void _viewPhoto(Photo photo) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(imageUrl: photo.url),
            ),
            if (photo.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(photo.description),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(s.photos)),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera_alt),
        onPressed: () => context.push('/constructions/${widget.constructionUid}/photos/new'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _photos.isEmpty
              ? EmptyState(icon: Icons.photo_library, message: s.no_photos)
              : RefreshIndicator(
                  onRefresh: _load,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemCount: _photos.length,
                    itemBuilder: (context, index) {
                      final photo = _photos[index];
                      return GestureDetector(
                        onTap: () => _viewPhoto(photo),
                        onLongPress: () => _delete(photo),
                        child: CachedNetworkImage(
                          imageUrl: photo.url,
                          fit: BoxFit.cover,
                          placeholder: (_, _) => Container(color: Colors.grey[200]),
                          errorWidget: (_, _, _) => const Icon(Icons.broken_image),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
