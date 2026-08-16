import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final String currentStepName;
  
  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.currentStepName,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Progress bar
          LinearProgressIndicator(
            value: (currentStep + 1) / totalSteps,
            backgroundColor: AppColors.divider,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
            minHeight: 4,
          ),
          
          const SizedBox(height: 12),
          
          // Step counter
          Row(
            children: [
              Text(
                'Step ${currentStep + 1} of $totalSteps',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  currentStepName,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Step list
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: List.generate(totalSteps, (index) {
              final isCompleted = index < currentStep;
              final isCurrent = index == currentStep;
              
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isCurrent
                      ? AppColors.accent.withOpacity(0.1)
                      : isCompleted
                          ? AppColors.success.withOpacity(0.1)
                          : AppColors.divider,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: isCurrent
                          ? AppColors.accent
                          : isCompleted
                              ? AppColors.success
                              : AppColors.divider,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: isCurrent || isCompleted
                              ? AppColors.white
                              : AppColors.textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      AppConstants.processingSteps[index],
                      style: AppTypography.caption.copyWith(
                        color: isCurrent
                            ? AppColors.accent
                            : isCompleted
                                ? AppColors.success
                                : AppColors.textSecondary,
                        fontWeight: isCurrent || isCompleted
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}