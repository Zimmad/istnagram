import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:istnagram/state/auth/provider/auth_state_notifier_provider.dart';
import 'package:istnagram/state/image_uploads/providers/image_uploader_provider.dart';

final isLoadingProvider = Provider<bool>(((ref) {
  final authState = ref.watch(authStateProvider);
  final isUploadingImage = ref.watch(imageUpoadProvider);
  return authState.isLoading || isUploadingImage;
}));
