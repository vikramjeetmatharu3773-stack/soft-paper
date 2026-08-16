import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../lib/core/theme/app_colors.dart';
import '../lib/core/theme/app_typography.dart';
import '../lib/core/theme/app_theme.dart';
import '../lib/shared/widgets/primary_button.dart';
import '../lib/shared/widgets/step_indicator.dart';

void main() {
  group('Theme Tests', () {
    testWidgets('App theme colors are correctly defined', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: Container(color: AppColors.paperCream),
          ),
        ),
      );

      // Check if the background color is correct
      final container = tester.firstWidget<Container>();
      expect((container as Container).color, AppColors.paperCream);
    });

    testWidgets('App typography styles are correctly defined', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: Column(
              children: [
                Text('Heading', style: AppTypography.h1),
                Text('Body', style: AppTypography.body1),
                Text('Caption', style: AppTypography.caption),
              ],
            ),
          ),
        ),
      );

      // Check if text widgets are present
      expect(find.text('Heading'), findsOneWidget);
      expect(find.text('Body'), findsOneWidget);
      expect(find.text('Caption'), findsOneWidget);
    });

    testWidgets('Primary button widget renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: Center(
              child: PrimaryButton(
                text: 'Test Button',
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('Step indicator widget renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: Center(
              child: StepIndicator(
                currentStep: 1,
                totalSteps: 3,
                currentStepName: 'Processing...',
              ),
            ),
          ),
        ),
      );

      expect(find.text('Step 2 of 3'), findsOneWidget);
      expect(find.text('Processing...'), findsOneWidget);
    });
  });
}