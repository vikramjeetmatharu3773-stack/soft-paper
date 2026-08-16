import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/step_indicator.dart';
import '../../shared/widgets/primary_button.dart';
import 'reconstruction_controller.dart';

class ReconstructionScreen extends ConsumerStatefulWidget {
  const ReconstructionScreen({super.key});

  @override
  ConsumerState<ReconstructionScreen> createState() => _ReconstructionScreenState();
}

class _ReconstructionScreenState extends ConsumerState<ReconstructionScreen> {
  @override
  Widget build(BuildContext context) {
    final reconstructionState = ref.watch(reconstructionControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Reconstruction'),
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
                  StepIndicator(
                    currentStep: 4,
                    totalSteps: 5,
                    currentStepName: 'Reconstruction',
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Document reconstruction options
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
                              Icons.reconstruct,
                              color: AppColors.accent,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Reconstruction Options',
                              style: AppTypography.h3,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Layout selection
                        Text(
                          'Layout Style',
                          style: AppTypography.body1,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            _buildLayoutChip('Perfect Copy', true),
                            _buildLayoutChip('Clean Scan', false),
                            _buildLayoutChip('Enhanced Scan', false),
                            _buildLayoutChip('Text Only', false),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Size selection
                        Text(
                          'Document Size',
                          style: AppTypography.body1,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            _buildSizeChip('Letter', true),
                            _buildSizeChip('A4', false),
                            _buildSizeChip('Legal', false),
                            _buildSizeChip('Custom', false),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Orientation selection
                        Text(
                          'Orientation',
                          style: AppTypography.body1,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: reconstructionState.isPortrait
                                      ? AppColors.accent.withOpacity(0.1)
                                      : AppColors.divider,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.portrait,
                                      color: reconstructionState.isPortrait
                                          ? AppColors.accent
                                          : AppColors.textSecondary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Portrait',
                                      style: AppTypography.body1.copyWith(
                                        color: reconstructionState.isPortrait
                                            ? AppColors.accent
                                            : AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: !reconstructionState.isPortrait
                                      ? AppColors.accent.withOpacity(0.1)
                                      : AppColors.divider,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.landscape,
                                      color: !reconstructionState.isPortrait
                                          ? AppColors.accent
                                          : AppColors.textSecondary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Landscape',
                                      style: AppTypography.body1.copyWith(
                                        color: !reconstructionState.isPortrait
                                            ? AppColors.accent
                                            : AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Preview of reconstructed document
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
                              Icons.preview,
                              color: AppColors.accent,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Reconstruction Preview',
                              style: AppTypography.h3,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Document preview
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.paperCream,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Document header
                              Row(
                                children: [
                                  Icon(
                                    Icons.file_present,
                                    color: AppColors.accent,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Reconstructed Document',
                                    style: AppTypography.h4,
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${reconstructionState.totalPages} pages',
                                    style: AppTypography.caption,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              
                              // Preview content
                              Expanded(
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: min(3, reconstructionState.totalPages),
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: AppColors.divider),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Page ${index + 1}',
                                                style: AppTypography.caption.copyWith(
                                                  color: AppColors.textSecondary,
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                '${(index + 1) * 250} chars',
                                                style: AppTypography.caption.copyWith(
                                                  color: AppColors.textSecondary,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'This is a preview of the reconstructed document content. In a real implementation, this would show the actual reconstructed text with proper formatting, layout, and styling.',
                                            style: AppTypography.body2.copyWith(
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Reconstruction settings
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
                              Icons.settings,
                              color: AppColors.accent,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Reconstruction Settings',
                              style: AppTypography.h3,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        
                        // Font selection
                        Text(
                          'Font',
                          style: AppTypography.body1,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            _buildFontChip('Inter', true),
                            _buildFontChip('Source Serif', false),
                            _buildFontChip('Roboto', false),
                            _buildFontChip('Open Sans', false),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Font size
                        Text(
                          'Font Size',
                          style: AppTypography.body1,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Small',
                                style: AppTypography.caption,
                              ),
                            ),
                            Expanded(
                              child: Slider(
                                value: reconstructionState.fontSize,
                                min: 0.8,
                                max: 1.4,
                                divisions: 3,
                                onChanged: (value) {
                                  ref.read(reconstructionControllerProvider).setFontSize(value);
                                },
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Large',
                                style: AppTypography.caption,
                                textAlign: TextAlign.end,
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
          
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                if (!reconstructionState.isProcessing && reconstructionState.errorMessage == null)
                  PrimaryButton(
                    text: 'Generate PDF',
                    icon: Icons.picture_as_pdf,
                    onPressed: () {
                      ref.read(reconstructionControllerProvider).generatePDF();
                    },
                  ),
                if (reconstructionState.errorMessage != null)
                  PrimaryButton(
                    text: 'Retry Reconstruction',
                    icon: Icons.refresh,
                    onPressed: () {
                      ref.read(reconstructionControllerProvider).reconstructDocument();
                    },
                  ),
                if (reconstructionState.isProcessing)
                  const CircularProgressIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLayoutChip(String layout, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.accent
            : AppColors.divider,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        layout,
        style: AppTypography.caption.copyWith(
          color: isSelected ? AppColors.white : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
  
  Widget _buildSizeChip(String size, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.accent
            : AppColors.divider,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        size,
        style: AppTypography.caption.copyWith(
          color: isSelected ? AppColors.white : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
  
  Widget _buildFontChip(String font, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.accent
            : AppColors.divider,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        font,
        style: AppTypography.caption.copyWith(
          color: isSelected ? AppColors.white : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}