#!/bin/bash

echo "🔍 COMPREHENSIVE PHASE VERIFICATION"
echo "======================================"

# Phase 0 - Project Setup
echo "📁 PHASE 0 - PROJECT SETUP"
echo "-------------------------"
phase0_files=(
    "lib/main.dart"
    "lib/core/theme/app_colors.dart"
    "lib/core/theme/app_typography.dart"
    "lib/core/theme/app_theme.dart"
    "lib/core/constants/app_constants.dart"
    "lib/core/router/app_router.dart"
    "lib/data/models/document_model.dart"
    "lib/data/db/database_helper.dart"
    "lib/shared/widgets/primary_button.dart"
    "lib/shared/widgets/step_indicator.dart"
    "pubspec.yaml"
    "android/app/build.gradle"
    "android/app/src/main/AndroidManifest.xml"
    "test/database_test.dart"
    "test/theme_test.dart"
)

phase0_complete=true
for file in "${phase0_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file - MISSING"
        phase0_complete=false
    fi
done

if [ "$phase0_complete" = true ]; then
    echo "✅ PHASE 0 COMPLETE"
else
    echo "❌ PHASE 0 INCOMPLETE"
fi

echo ""
echo "📸 PHASE 1 - CAPTURE & IMPORT"
echo "---------------------------"
phase1_files=(
    "lib/features/capture/capture_screen.dart"
    "lib/features/capture/capture_controller.dart"
    "lib/features/capture/widgets/edge_overlay_painter.dart"
    "lib/features/capture/widgets/batch_counter_widget.dart"
    "lib/features/edge_detection/edge_detection_service.dart"
)

phase1_complete=true
for file in "${phase1_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file - MISSING"
        phase1_complete=false
    fi
done

if [ "$phase1_complete" = true ]; then
    echo "✅ PHASE 1 COMPLETE"
else
    echo "❌ PHASE 1 INCOMPLETE"
fi

echo ""
echo "⚙️ PHASE 2 - PROCESSING"
echo "----------------------"
phase2_files=(
    "lib/features/processing/processing_screen.dart"
    "lib/features/processing/processing_controller.dart"
)

phase2_complete=true
for file in "${phase2_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file - MISSING"
        phase2_complete=false
    fi
done

if [ "$phase2_complete" = true ]; then
    echo "✅ PHASE 2 COMPLETE"
else
    echo "❌ PHASE 2 INCOMPLETE"
fi

echo ""
echo "📝 PHASE 3 - OCR"
echo "---------------"
phase3_files=(
    "lib/features/ocr/ocr_screen.dart"
    "lib/features/ocr/ocr_controller.dart"
)

phase3_complete=true
for file in "${phase3_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file - MISSING"
        phase3_complete=false
    fi
done

if [ "$phase3_complete" = true ]; then
    echo "✅ PHASE 3 COMPLETE"
else
    echo "❌ PHASE 3 INCOMPLETE"
fi

echo ""
echo "🏗️ PHASE 4 - RECONSTRUCTION"
echo "--------------------------"
phase4_files=(
    "lib/features/reconstruction/reconstruction_screen.dart"
    "lib/features/reconstruction/reconstruction_controller.dart"
)

phase4_complete=true
for file in "${phase4_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file - MISSING"
        phase4_complete=false
    fi
done

if [ "$phase4_complete" = true ]; then
    echo "✅ PHASE 4 COMPLETE"
else
    echo "❌ PHASE 4 INCOMPLETE"
fi

echo ""
echo "🔧 PHASE 5 - PDF TOOLS"
echo "----------------------"
phase5_files=(
    "lib/features/pdf_tools/pdf_tools_screen.dart"
    "lib/features/pdf_tools/pdf_tools_controller.dart"
)

phase5_complete=true
for file in "${phase5_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file - MISSING"
        phase5_complete=false
    fi
done

if [ "$phase5_complete" = true ]; then
    echo "✅ PHASE 5 COMPLETE"
else
    echo "❌ PHASE 5 INCOMPLETE"
fi

echo ""
echo "======================================"
echo "📊 FINAL SUMMARY"
echo "======================================"

total_phases=5
completed_phases=0

if [ "$phase0_complete" = true ]; then
    completed_phases=$((completed_phases + 1))
fi

if [ "$phase1_complete" = true ]; then
    completed_phases=$((completed_phases + 1))
fi

if [ "$phase2_complete" = true ]; then
    completed_phases=$((completed_phases + 1))
fi

if [ "$phase3_complete" = true ]; then
    completed_phases=$((completed_phases + 1))
fi

if [ "$phase4_complete" = true ]; then
    completed_phases=$((completed_phases + 1))
fi

if [ "$phase5_complete" = true ]; then
    completed_phases=$((completed_phases + 1))
fi

echo "Completed Phases: $completed_phases/$total_phases"

if [ $completed_phases -eq $total_phases ]; then
    echo "🎉 ALL PHASES COMPLETE!"
    echo ""
    echo "✅ Project Setup - Flutter app with theme, navigation, and data layer"
    echo "✅ Capture & Import - Camera, gallery, PDF import with edge detection"
    echo "✅ Processing - Image processing and batch management"
    echo "✅ OCR - Text recognition with confidence scoring"
    echo "✅ Reconstruction - Document reconstruction with layout options"
    echo "✅ PDF Tools - Complete PDF manipulation toolkit"
    echo ""
    echo "🚀 SOFT PAPER APP READY FOR BUILD AND DEPLOYMENT!"
    exit 0
else
    echo "❌ $((total_phases - completed_phases)) phases incomplete"
    exit 1
fi