import 'package:collection/collection.dart';
import 'package:custom_pkg_obj_remove/pkg/src/controllers/drawables/background/background_drawable.dart';
import 'package:custom_pkg_obj_remove/pkg/src/controllers/drawables/drawable.dart';
import 'package:flutter/material.dart';

/// Painter that paints the drawables.
class Painter extends CustomPainter {
  /// The background drawable to be used as a background.
  ///
  /// If it is `null`, the painter will have a transparent background.
  final BackgroundDrawable? background;

  /// List of drawables to be painted.
  final List<Drawable> drawables;
  /// Size that the drawables will be scaled to.
  /// If it is null, the drawables will be drawn without scaling.
  final Size? scale;

  /// Creates a [Painter] that paints the [drawables] onto a background [background].
  const Painter({
    required this.drawables,
    this.background,
    this.scale,
  });
  /// Paints the drawables onto the [canvas] of size [size].
  @override
  void paint(Canvas canvas, Size size) {
    // This is to allow [scale_] to be upgraded to non-nullable after checking for null
    final scale_ = scale;

    // Draw the background if it was provided
    if (background != null && background!.isNotHidden) {
      background!.draw(canvas, size);
    }

    // If a scale size is being used, save the canvas (with the background), scale it
    // and then proceed to drawing the drawables
    if (scale_ != null) {
      canvas.save();
      canvas.transform(Matrix4.identity()
          .scaled(size.width / scale_.width, size.height / scale_.height)
          .storage);
    }

    canvas.saveLayer(Rect.largest, Paint());

    // Draw all the drawables
    for (final drawable
        in drawables.where((drawable) => drawable.isNotHidden)) {
      drawable.draw(canvas, scale_ ?? size); 
    }

    canvas.restore();
    // If a scale size is being used, restore the saved canvas, which will scale all the drawn drawables
    if (scale_ != null) {
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // Unnecessary check to enforce the [Painter] type
    if (oldDelegate is! Painter) return true;

    // If the background changed, or any of the drawables changed, a repaint is needed
    return oldDelegate.background != background ||
        !const ListEquality().equals(oldDelegate.drawables, drawables);
  }
}
