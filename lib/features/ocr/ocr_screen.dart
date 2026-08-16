import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/step_indicator.dart';
import '../../shared/widgets/primary_button.dart';
import 'ocr_controller.dart';

class OCRScreen extends ConsumerStatefulWidget {
  const OCRScreen({super.key});

  @override
  ConsumerState<OCRScreen> createState() => _OCRScreenState();
}

class _OCRScreenState extends ConsumerState<OCRScreen> {
  @override
  Widget build(BuildContext context) {
    final ocrState = ref.watch(ocrControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Recognition'),
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
                    currentStep: 3,
                    totalSteps: 5,
                    currentStepName: 'Text Recognition',
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Document preview with text overlay
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
                              Icons.text_fields,
                              color: AppColors.accent,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Text Recognition Results',
                              style: AppTypography.h3,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // OCR confidence indicator
                        if (ocrState.processedPages.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.paperCream,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.verified,
                                  color: AppColors.success,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'OCR Confidence',
                                        style: AppTypography.caption,
                                      ),
                                      Text(
                                        '${(ocrState.averageConfidence * 100).toInt()}%',
                                        style: AppTypography.body1.copyWith(
                                          color: AppColors.success,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                LinearProgressIndicator(
                                  value: ocrState.averageConfidence,
                                  backgroundColor: AppColors.divider,
                                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
                                  minHeight: 4,
                                ),
                              ],
                            ),
                          ),
                        
                        const SizedBox(height: 16),
                        
                        // Text preview
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.paperCream,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  'Extracted Text',
                                  style: AppTypography.h4,
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  padding: const EdgeInsets.all(12),
                                  itemCount: ocrState.processedPages.length,
                                  itemBuilder: (context, index) {
                                    final page = ocrState.processedPages[index];
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
                                              Icon(
                                                Icons.page,
                                                size: 16,
                                                color: AppColors.textSecondary,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Page ${index + 1}',
                                                style: AppTypography.caption.copyWith(
                                                  color: AppColors.textSecondary,
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                '${page.ocrText.length} chars',
                                                style: AppTypography.caption.copyWith(
                                                  color: AppColors.textSecondary,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            page.ocrText.isNotEmpty
                                                ? page.ocrText
                                                : 'No text detected in this page',
                                            style: AppTypography.body2.copyWith(
                                              color: page.ocrText.isNotEmpty
                                                  ? AppColors.textPrimary
                                                  : AppColors.textSecondary,
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
                  
                  // OCR settings
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
                              'OCR Settings',
                              style: AppTypography.h3,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        
                        // Language selection
                        Text(
                          'Language',
                          style: AppTypography.body1,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            _buildLanguageChip('English', true),
                            _buildLanguageChip('Spanish', false),
                            _buildLanguageChip('French', false),
                            _buildLanguageChip('German', false),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // OCR quality
                        Text(
                          'OCR Quality',
                          style: AppTypography.body1,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Fast',
                                style: AppTypography.caption,
                              ),
                            ),
                            Expanded(
                              child: Slider(
                                value: ocrState.qualityLevel,
                                min: 0.0,
                                max: 1.0,
                                divisions: 2,
                                onChanged: (value) {
                                  ref.read(ocrControllerProvider).setQualityLevel(value);
                                },
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'High',
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
                if (!ocrState.isProcessing && ocrState.errorMessage == null)
                  PrimaryButton(
                    text: 'Continue to Reconstruction',
                    icon: Icons.reconstruct,
                    onPressed: () {
                      ref.read(ocrControllerProvider).processOCR();
                    },
                  ),
                if (ocrState.errorMessage != null)
                  PrimaryButton(
                    text: 'Retry OCR',
                    icon: Icons.refresh,
                    onPressed: () {
                      ref.read(ocrControllerProvider).processOCR();
                    },
                  ),
                if (ocrState.isProcessing)
                  const CircularProgressIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLanguageChip(String language, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.accent
            : AppColors.divider,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        language,
        style: AppTypography.caption.copyWith(
          color: isSelected ? AppColors.white : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}