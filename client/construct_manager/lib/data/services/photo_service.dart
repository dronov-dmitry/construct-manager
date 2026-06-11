import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import '../../core/constants/constants.dart';
import '../../core/network/supabase_client.dart';
import '../models/photo.dart';

class PhotoService {
  static const int _maxImageSize = 1920;
  static const int _jpegQuality = 85;

  Future<Photo> savePhoto({
    required String constructionId,
    required String description,
    required XFile imageFile,
  }) async {
    await _ensureBucketExists();
    await _compressImage(File(imageFile.path));
    final tempFile = File(imageFile.path);
    final photoId = DateTime.now().millisecondsSinceEpoch.toString();
    final fileName = '$constructionId/$photoId.jpg';

    await SupabaseClientManager.instance.storage
        .from(AppConstants.storageBucket)
        .upload(fileName, tempFile);

    final publicUrl = SupabaseClientManager.instance.storage
        .from(AppConstants.storageBucket)
        .getPublicUrl(fileName);

    final photo = Photo(
      constructionUid: constructionId,
      url: publicUrl,
      description: description,
      uid: photoId,
      createdAt: DateTime.now().toUtc().toIso8601String(),
    );

    await SupabaseClientManager.instance.client
        .from('photos')
        .insert(photo.toJson());

    return photo;
  }

  Future<List<Photo>> getPhotos(String constructionId) async {
    final data = await SupabaseClientManager.instance.client
        .from('photos')
        .select()
        .eq('construction_uid', constructionId)
        .order('created_at', ascending: false);
    final list = data as List<dynamic>;
    return list.map((e) => Photo.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> deletePhoto(String photoUid, String constructionId) async {
    await _ensureBucketExists();
    final fileName = '$constructionId/$photoUid.jpg';
    await SupabaseClientManager.instance.storage
        .from(AppConstants.storageBucket)
        .remove([fileName]);

    await SupabaseClientManager.instance.client
        .from('photos')
        .delete()
        .eq('uid', photoUid);
  }

  Future<Uint8List> _compressImage(File file) async {
    final original = img.decodeImage(await file.readAsBytes());
    if (original == null) throw Exception('Failed to decode image');

    img.Image resized;
    if (original.width > _maxImageSize || original.height > _maxImageSize) {
      final ratio = original.width / original.height;
      int newWidth, newHeight;
      if (original.width > original.height) {
        newWidth = _maxImageSize;
        newHeight = (_maxImageSize / ratio).round();
      } else {
        newHeight = _maxImageSize;
        newWidth = (_maxImageSize * ratio).round();
      }
      resized = img.copyResize(original, width: newWidth, height: newHeight);
    } else {
      resized = original;
    }

    return Uint8List.fromList(img.encodeJpg(resized, quality: _jpegQuality));
  }

  Future<void> _ensureBucketExists() async {
    try {
      await SupabaseClientManager.instance.client.rpc('create_photo_bucket');
    } catch (_) {
      // RPC may not exist on older deployments — ignore, upload will fail
      // with a clear "Bucket not found" error if the bucket is truly missing.
    }
  }
}
