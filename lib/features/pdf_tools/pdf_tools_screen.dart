import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/primary_button.dart';
import 'pdf_tools_controller.dart';

class PDFToolsScreen extends ConsumerStatefulWidget {
  const PDFToolsScreen({super.key});

  @override
  ConsumerState<PDFToolsScreen> createState() => _PDFToolsScreenState();
}

class _PDFToolsScreenState extends ConsumerState<PDFToolsScreen> {
  @override
  Widget build(BuildContext context) {
    final pdfToolsState = ref.watch(pdfToolsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Tools'),
        backgroundColor: AppColors.paperCream,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recent documents
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.history,
                              color: AppColors.accent,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Recent Documents',
                              style: AppTypography.h3,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        if (pdfToolsState.recentDocuments.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.paperCream,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.file_present,
                                  size: 48,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No recent documents',
                                  style: AppTypography.body1.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: pdfToolsState.recentDocuments.length,
                            itemBuilder: (context, index) {
                              final document = pdfToolsState.recentDocuments[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.paperCream,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: AppColors.accent.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.picture_as_pdf,
                                        color: AppColors.accent,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            document.title,
                                            style: AppTypography.body1,
                                          ),
                                          Text(
                                            '${document.pageCount} pages • ${document.createdAt.toLocal().toString().split(' ')[0]}',
                                            style: AppTypography.caption.copyWith(
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuButton<String>(
                                      onSelected: (value) {
                                        _handleDocumentAction(value, document);
                                      },
              items: [
                const PopupMenuItem(
                  value: 'open',
                  child: Row(
                    children: [
                      Icon(Icons.open_in_new),
                      SizedBox(width: 8),
                      Text('Open'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'share',
                  child: Row(
                    children: [
                      Icon(Icons.share),
                      SizedBox(width: 8),
                      Text('Share'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete),
                      SizedBox(width: 8),
                      Text('Delete'),
                    ],
                  ),
                ),
              ],
            ),
                                  ],
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // PDF Tools
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.build,
                              color: AppColors.accent,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'PDF Tools',
                              style: AppTypography.h3,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Tool categories
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.2,
                          ),
                          itemCount: _buildToolItems().length,
                          itemBuilder: (context, index) {
                            final tool = _buildToolItems()[index];
                            return _buildToolCard(tool);
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Quick actions
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.paperCream,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.bolt,
                              color: AppColors.accent,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Quick Actions',
                              style: AppTypography.h3,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        
                        Row(
                          children: [
                            Expanded(
                              child: PrimaryButton(
                                text: 'Merge PDFs',
                                icon: Icons.merge_type,
                                onPressed: () {
                                  ref.read(pdfToolsControllerProvider).mergePDFs();
                                },
                                isFullWidth: true,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: PrimaryButton(
                                text: 'Split PDF',
                                icon: Icons.content_cut,
                                onPressed: () {
                                  ref.read(pdfToolsControllerProvider).splitPDF();
                                },
                                isFullWidth: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  List<Map<String, dynamic>> _buildToolItems() {
    return [
      {
        'title': 'Compress',
        'icon': Icons.compress,
        'description': 'Reduce file size',
        'color': AppColors.success,
      },
      {
        'title': 'Encrypt',
        'icon': Icons.lock,
        'description': 'Add password protection',
        'color': AppColors.warning,
      },
      {
        'title': 'Decrypt',
        'icon': Icons.lock_open,
        'description': 'Remove password protection',
        'color': AppColors.info,
      },
      {
        'title': 'Convert',
        'icon': Icons.file_download,
        'description': 'Change file format',
        'color': AppColors.accent,
      },
      {
        'title': 'Rotate',
        'icon': Icons.rotate_right,
        'description': 'Change page orientation',
        'color': AppColors.primary,
      },
      {
        'title': 'Extract',
        'icon': Icons.extract,
        'description': 'Extract pages',
        'color': AppColors.secondary,
      },
    ];
  }
  
  Widget _buildToolCard(Map<String, dynamic> tool) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: tool['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              tool['icon'],
              color: tool['color'],
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            tool['title'],
            style: AppTypography.h4.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            tool['description'],
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
  
  void _handleDocumentAction(String action, DocumentModel document) {
    switch (action) {
      case 'open':
        // Navigate to document viewer
        break;
      case 'share':
        // Share document
        break;
      case 'delete':
        // Delete document
        ref.read(pdfToolsControllerProvider).deleteDocument(document.id);
        break;
    }
  }
}