import 'package:flutter/material.dart';

import 'package:dare_u/enums/media_type_enum.dart';
import 'package:dare_u/models/media_attachment_model.dart';
import 'package:dare_u/models/progress_entry_model.dart';

class ProgressDialog extends StatefulWidget {
  const ProgressDialog({
    super.key,
  });

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
      _mockAttachments.add(MediaAttachmentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: MediaTypeEnum.image,
        path: 'mock/path/image_${_mockAttachments.length + 1}.jpg',
        fileName: 'image_${_mockAttachments.length + 1}.jpg',
        uploadedAt: DateTime.now(),
      ));
    });
  }

  void _addMockVideo() {
    setState(() {
      _mockAttachments.add(MediaAttachmentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: MediaTypeEnum.video,
        path: 'mock/path/video_${_mockAttachments.length + 1}.mp4',
        fileName: 'video_${_mockAttachments.length + 1}.mp4',
        uploadedAt: DateTime.now(),
      ));
    });
  }

  void _addMockFile() {
    setState(() {
      _mockAttachments.add(MediaAttachmentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: MediaTypeEnum.file,
        path: 'mock/path/document_${_mockAttachments.length + 1}.pdf',
        fileName: 'document_${_mockAttachments.length + 1}.pdf',
        uploadedAt: DateTime.now(),
      ));
    });
  }

  void _removeAttachment(String id) {
    setState(() {
      _mockAttachments.removeWhere((attachment) => attachment.id == id);
    });
  }

  void _submit() {
    if (_noteController.text.trim().isEmpty && _mockAttachments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add a note or attach a file'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final entry = ProgressEntryModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      challengeId: 'current', // Not needed anymore but kept for model compatibility
      note: _noteController.text.trim(),
      attachments: _mockAttachments,
      createdAt: DateTime.now(),
    );

    Navigator.of(context).pop(entry);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.upload_rounded,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Submit Progress',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: theme.brightness == Brightness.dark
                                ? Colors.white
                                : const Color(0xFF1E293B),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Share your progress',
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.iconTheme.color?.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _noteController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Describe what you did...',
                      filled: true,
                      fillColor: theme.brightness == Brightness.dark
                          ? theme.cardColor
                          : theme.scaffoldBackgroundColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Add proof (optional)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.brightness == Brightness.dark
                          ? Colors.white
                          : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildUploadButton(
                          context,
                          icon: Icons.image_rounded,
                          label: 'Image',
                          onTap: _addMockImage,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildUploadButton(
                          context,
                          icon: Icons.videocam_rounded,
                          label: 'Video',
                          onTap: _addMockVideo,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildUploadButton(
                          context,
                          icon: Icons.attach_file_rounded,
                          label: 'File',
                          onTap: _addMockFile,
                        ),
                      ),
                    ],
                  ),
                  if (_mockAttachments.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _mockAttachments.map((attachment) {
                        return Chip(
                          avatar: Icon(
                            _getMediaIcon(attachment.type),
                            size: 16,
                          ),
                          label: Text(
                            attachment.fileName ?? 'Attachment',
                            style: const TextStyle(fontSize: 12),
                          ),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () => _removeAttachment(attachment.id),
                          backgroundColor:
                              theme.colorScheme.primary.withOpacity(0.1),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: theme.dividerColor.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: theme.brightness == Brightness.dark
                ? theme.cardColor
                : theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.dividerColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: theme.colorScheme.primary,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.iconTheme.color?.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getMediaIcon(MediaTypeEnum type) {
    switch (type) {
      case MediaTypeEnum.image:
        return Icons.image_rounded;
      case MediaTypeEnum.video:
        return Icons.videocam_rounded;
      case MediaTypeEnum.file:
        return Icons.attach_file_rounded;
    }
  }
}

