import 'package:unite_up/enums/media_type_enum.dart';
import 'package:unite_up/core/constants/app_constants.dart';
import 'package:unite_up/models/media_attachment_model.dart';
import 'package:unite_up/models/progress_entry_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ProgressDialog extends StatefulWidget {
  const ProgressDialog({super.key});

  @override
  State<ProgressDialog> createState() => _ProgressDialogState();
}

class _ProgressDialogState extends State<ProgressDialog> {
  final TextEditingController _noteController = TextEditingController();
  final List<MediaAttachmentModel> _mockAttachments = [];
  bool _isUploading = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _showMediaPicker() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppSizes.radiusXLarge),
            topRight: Radius.circular(AppSizes.radiusXLarge),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: AppSizes.spacing12),
              Container(
                width: AppSizes.containerSmall,
                height: AppSizes.spacing4,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .dividerColor
                      .withValues(alpha: AppOpacity.medium),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                ),
              ),
              const SizedBox(height: AppSizes.spacing24),
              _buildPickerOption(
                context,
                icon: AppIcons.image,
                label: 'progress.pickImage'.tr(),
                color: Colors.blue,
                onTap: () => Navigator.pop(context, 'image'),
              ),
              _buildPickerOption(
                context,
                icon: AppIcons.video,
                label: 'progress.pickVideo'.tr(),
                color: Colors.purple,
                onTap: () => Navigator.pop(context, 'video'),
              ),
              _buildPickerOption(
                context,
                icon: AppIcons.file,
                label: 'progress.pickFile'.tr(),
                color: Colors.orange,
                onTap: () => Navigator.pop(context, 'file'),
              ),
              const SizedBox(height: AppSizes.spacing16),
            ],
          ),
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() => _isUploading = true);
      // Simulate upload delay
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        setState(() => _isUploading = false);
        if (result == 'image') {
          _addMockImage();
        } else if (result == 'video') {
          _addMockVideo();
        } else if (result == 'file') {
          _addMockFile();
        }
      }
    }
  }

  Widget _buildPickerOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacing16,
        vertical: AppSizes.spacing4,
      ),
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          child: Container(
            padding: const EdgeInsets.all(AppSizes.spacing16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSizes.spacing8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: AppOpacity.light),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  ),
                  child: Icon(icon, color: color, size: AppSizes.iconMedium),
                ),
                const SizedBox(width: AppSizes.spacing16),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: AppSizes.fontLarge,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addMockImage() {
    setState(() {
      _mockAttachments.add(
        MediaAttachmentModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: MediaTypeEnum.image,
          path: 'mock/path/image_${_mockAttachments.length + 1}.jpg',
          fileName: 'image_${_mockAttachments.length + 1}.jpg',
          uploadedAt: DateTime.now(),
        ),
      );
    });
  }

  void _addMockVideo() {
    setState(() {
      _mockAttachments.add(
        MediaAttachmentModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: MediaTypeEnum.video,
          path: 'mock/path/video_${_mockAttachments.length + 1}.mp4',
          fileName: 'video_${_mockAttachments.length + 1}.mp4',
          uploadedAt: DateTime.now(),
        ),
      );
    });
  }

  void _addMockFile() {
    setState(() {
      _mockAttachments.add(
        MediaAttachmentModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: MediaTypeEnum.file,
          path: 'mock/path/document_${_mockAttachments.length + 1}.pdf',
          fileName: 'document_${_mockAttachments.length + 1}.pdf',
          uploadedAt: DateTime.now(),
        ),
      );
    });
  }

  void _removeAttachment(String id) {
    setState(() {
      _mockAttachments.removeWhere((attachment) => attachment.id == id);
    });
  }

  Future<void> _submitProgress() async {
    if (_noteController.text.trim().isEmpty && _mockAttachments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('progress.pleaseAddNote'.tr()),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isUploading = true);

    // Simulate submission delay
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      final entry = ProgressEntryModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        challengeId: 'current',
        note: _noteController.text.trim(),
        attachments: _mockAttachments,
        createdAt: DateTime.now(),
      );

      Navigator.of(context).pop(entry);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      backgroundColor: theme.scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusLarge)),
      title: Text(
        'progress.title'.tr(),
        style: TextStyle(
          color: theme.brightness == Brightness.dark
              ? Colors.white
              : const Color(0xFF1E293B),
          fontWeight: FontWeight.w600,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'progress.addNote'.tr(),
              style: TextStyle(
                fontSize: AppSizes.fontMedium,
                fontWeight: FontWeight.w600,
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: AppSizes.spacing12),
            TextField(
              controller: _noteController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'progress.describeProgress'.tr(),
                filled: true,
                fillColor: theme.brightness == Brightness.dark
                    ? theme.cardColor
                    : theme.scaffoldBackgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  borderSide: BorderSide.none,
                ),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: AppSizes.spacing16),
            Text(
              'progress.addProof'.tr(),
              style: TextStyle(
                fontSize: AppSizes.fontMedium,
                fontWeight: FontWeight.w600,
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: AppSizes.spacing12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _isUploading ? null : _showMediaPicker,
                icon: _isUploading
                    ? const SizedBox(
                        height: AppSizes.iconSmall,
                        width: AppSizes.iconSmall,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(AppIcons.add, size: AppSizes.iconMedium),
                label: Text(
                  _isUploading
                      ? 'progress.uploading'.tr()
                      : 'progress.addMedia'.tr(),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSizes.spacing16,
                  ),
                  side: BorderSide(
                    color: theme.colorScheme.primary
                        .withValues(alpha: AppOpacity.semiTransparent),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.spacing16),
            if (_mockAttachments.isNotEmpty)
              Column(
                children: _mockAttachments
                    .map((attachment) =>
                        _buildAttachmentPreview(attachment, theme))
                    .toList(),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('common.cancel'.tr()),
        ),
        ElevatedButton(
          onPressed: _submitProgress,
          child: Text('common.submit'.tr()),
        ),
      ],
    );
  }

  String _getFileSize(MediaAttachmentModel attachment) {
    // Mock file sizes for demonstration
    if (attachment.type == MediaTypeEnum.image) {
      return '2.3 MB';
    } else if (attachment.type == MediaTypeEnum.video) {
      return '15.7 MB';
    } else {
      return '0.8 MB';
    }
  }

  Color _getMediaColor(MediaTypeEnum type) {
    switch (type) {
      case MediaTypeEnum.image:
        return Colors.blue;
      case MediaTypeEnum.video:
        return Colors.purple;
      case MediaTypeEnum.file:
        return Colors.green;
    }
  }

  Widget _buildAttachmentPreview(
      MediaAttachmentModel attachment, ThemeData theme) {
    final mediaColor = _getMediaColor(attachment.type);
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spacing12),
      padding: const EdgeInsets.all(AppSizes.spacing12),
      decoration: BoxDecoration(
        color: mediaColor.withValues(alpha: AppOpacity.veryLight),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(
          color: mediaColor.withValues(alpha: AppOpacity.light),
          width: AppSizes.borderThin,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.spacing8),
            decoration: BoxDecoration(
              color: mediaColor.withValues(alpha: AppOpacity.light),
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            ),
            child: Icon(
              attachment.type == MediaTypeEnum.image
                  ? AppIcons.image
                  : attachment.type == MediaTypeEnum.video
                      ? AppIcons.video
                      : AppIcons.file,
              color: mediaColor,
              size: AppSizes.iconMedium,
            ),
          ),
          const SizedBox(width: AppSizes.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attachment.fileName ?? 'progress.unnamed'.tr(),
                  style: TextStyle(
                    color: theme.brightness == Brightness.dark
                        ? Colors.white
                        : const Color(0xFF1E293B),
                    fontWeight: FontWeight.w500,
                    fontSize: AppSizes.fontMedium,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: AppSizes.spacing2),
                Text(
                  _getFileSize(attachment),
                  style: TextStyle(
                    fontSize: AppSizes.fontSmall,
                    color: theme.iconTheme.color?.withValues(
                      alpha: AppOpacity.mostlyOpaque,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSizes.spacing8),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _removeAttachment(attachment.id),
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              child: Container(
                padding: const EdgeInsets.all(AppSizes.spacing8),
                child: Icon(
                  AppIcons.close,
                  size: AppSizes.iconSmall,
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
