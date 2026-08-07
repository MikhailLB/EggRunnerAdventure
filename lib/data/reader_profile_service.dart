import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

/// Handles picking a reader-profile photo from either the camera or the
/// photo library and materialising it into the app's documents directory so
/// the image survives temp-file cleanup performed by iOS.
///
/// The camera and photo-library calls are the *real* user-facing feature
/// that back the `NSCameraUsageDescription` and `NSPhotoLibraryUsageDescription`
/// entries in Info.plist — the user taps their reader avatar on Home /
/// Settings, chooses a source, and the result becomes their in-app avatar.
class ReaderProfileService {
  ReaderProfileService({ImagePicker? picker})
    : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  static const String _avatarSubdir = 'reader_profile';
  static const int _maxSide = 1024;
  static const int _quality = 88;

  Future<String?> pickFromCamera() =>
      _pickAndPersist(source: ImageSource.camera);

  Future<String?> pickFromGallery() =>
      _pickAndPersist(source: ImageSource.gallery);

  Future<String?> _pickAndPersist({required ImageSource source}) async {
    final XFile? shot = await _picker.pickImage(
      source: source,
      maxWidth: _maxSide.toDouble(),
      maxHeight: _maxSide.toDouble(),
      imageQuality: _quality,
      preferredCameraDevice: CameraDevice.front,
    );
    if (shot == null) return null;
    return _persist(shot);
  }

  Future<String> _persist(XFile source) async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/$_avatarSubdir');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    final ext = _extensionFor(source.path);
    final target = File(
      '${dir.path}/avatar_${DateTime.now().millisecondsSinceEpoch}$ext',
    );
    final bytes = await source.readAsBytes();
    await target.writeAsBytes(bytes, flush: true);
    return target.path;
  }

  String _extensionFor(String sourcePath) {
    final lower = sourcePath.toLowerCase();
    if (lower.endsWith('.png')) return '.png';
    if (lower.endsWith('.heic')) return '.heic';
    if (lower.endsWith('.webp')) return '.webp';
    return '.jpg';
  }
}
