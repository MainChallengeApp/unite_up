import 'package:dare_u/enums/media_type_enum.dart';
import 'package:dare_u/core/constants/app_constants.dart';
import 'package:dare_u/models/media_attachment_model.dart';
import 'package:dare_u/models/progress_entry_model.dart';
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

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
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

  void _submitProgress() {
    if (_noteController.text.trim().isEmpty && _mockAttachments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('progress.pleaseAddNote'.tr()),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final entry = ProgressEntryModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      challengeId: 'current',
      note: _noteController.text.trim(),
      attachments: _mockAttachments,
      createdAt: DateTime.now(),
    );

    Navigator.of(context).pop(entry);
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
            Row(
              children: [
                Expanded(
                  child: _buildUploadButton(
                    context,
                    icon: AppIcons.image,
                    label: 'progress.image'.tr(),
                    onTap: _addMockImage,
                  ),
                ),
                const SizedBox(width: AppSizes.spacing8),
                Expanded(
                  child: _buildUploadButton(
                    context,
                    icon: AppIcons.video,
                    label: 'progress.video'.tr(),
                    onTap: _addMockVideo,
                  ),
                ),
                const SizedBox(width: AppSizes.spacing8),
                Expanded(
                  child: _buildUploadButton(
                    context,
                    icon: AppIcons.attachFile,
                    label: 'progress.file'.tr(),
                    onTap: _addMockFile,
                  ),
                ),
              ],
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

  Widget _buildUploadButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: AppSizes.size18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: theme.colorScheme.primary,
        side: BorderSide(color: theme.colorScheme.primary.withValues(alpha: AppOpacity.semiTransparent)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMedium)),
      ),
    );
  }

  Widget _buildAttachmentPreview(
      MediaAttachmentModel attachment, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spacing8),
      padding: const EdgeInsets.all(AppSizes.spacing8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(color: theme.dividerColor.withValues(alpha: AppOpacity.light)),
      ),
      child: Row(
        children: [
          Icon(
            attachment.type == MediaTypeEnum.image
                ? AppIcons.image
                : attachment.type == MediaTypeEnum.video
                    ? AppIcons.video
                    : AppIcons.file,
            color: theme.iconTheme.color?.withValues(alpha: AppOpacity.almostOpaque),
            size: AppSizes.iconLarge,
          ),
          const SizedBox(width: AppSizes.spacing12),
          Expanded(
            child: Text(
              attachment.fileName ?? 'progress.unnamed'.tr(),
              style: TextStyle(
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : const Color(0xFF1E293B),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(AppIcons.close),
            onPressed: () => _removeAttachment(attachment.id),
            color: theme.colorScheme.error,
          ),
        ],
      ),
    );
  }
}
