import 'package:flutter/material.dart';

import '../../core/doc_type.dart';

/// Icon used to represent a document of the given normalized [DocType].
IconData docTypeIcon(String docType) => switch (docType) {
      DocType.pdf => Icons.picture_as_pdf_outlined,
      DocType.image => Icons.image_outlined,
      DocType.office => Icons.description_outlined,
      DocType.archive => Icons.folder_zip_outlined,
      DocType.text => Icons.article_outlined,
      _ => Icons.insert_drive_file_outlined,
    };

/// Accent color for a document type, kept readable in both themes.
Color docTypeColor(String docType, ColorScheme scheme) => switch (docType) {
      DocType.pdf => const Color(0xFFE2574C),
      DocType.image => const Color(0xFF2A9D8F),
      DocType.office => const Color(0xFF3D7EDB),
      DocType.archive => const Color(0xFFE0A100),
      DocType.text => const Color(0xFF4C9A52),
      _ => scheme.outline,
    };
