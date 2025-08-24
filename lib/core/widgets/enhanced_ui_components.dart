/// Componentes de UI mejorados con micro-interacciones
///
/// Implementa principios de retención de atención, feedback visual,
/// y llamadas a la acción efectivas.
library;

import 'package:flutter/material.dart';
import '../design/app_design_system.dart';

/// Botón CTA principal con micro-interacciones
class PrimaryCTAButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final bool fullWidth;

  const PrimaryCTAButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.fullWidth = false,
  }) : super(key: key);

  @override
  State<PrimaryCTAButton> createState() => _PrimaryCTAButtonState();
}

class _PrimaryCTAButtonState extends State<PrimaryCTAButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppAnimations.buttonPress,
      ),
    );

    _shadowAnimation = Tween<double>(begin: 4.0, end: 8.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppAnimations.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: widget.onPressed != null ? _onTapDown : null,
            onTapUp: widget.onPressed != null ? _onTapUp : null,
            onTapCancel: widget.onPressed != null ? _onTapCancel : null,
            child: Container(
              width: widget.fullWidth ? double.infinity : null,
              height: 56,
              decoration: BoxDecoration(
                gradient: widget.backgroundColor != null
                    ? null
                    : AppColors.primaryGradient,
                color: widget.backgroundColor ?? AppColors.primary,
                borderRadius: AppBorders.medium,
                boxShadow: [
                  BoxShadow(
                    color: (widget.backgroundColor ?? AppColors.primary)
                        .withOpacity(0.3),
                    blurRadius: _shadowAnimation.value,
                    offset: Offset(0, _shadowAnimation.value / 2),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: widget.isLoading ? null : widget.onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: widget.textColor ?? Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppBorders.medium,
                  ),
                ),
                child: widget.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.icon != null) ...[
                            Icon(widget.icon, size: AppIcons.medium),
                            const SizedBox(width: AppSpacing.sm),
                          ],
                          Text(
                            widget.text,
                            style: AppTypography.ctaPrimary.copyWith(
                              color: widget.textColor ?? Colors.white,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Botón CTA secundario
class SecondaryCTAButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const SecondaryCTAButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(
            color: AppColors.primary,
            width: AppBorders.strokeWidth,
          ),
          shape: const RoundedRectangleBorder(borderRadius: AppBorders.medium),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: AppIcons.medium),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Text(text, style: AppTypography.ctaSecondary),
                ],
              ),
      ),
    );
  }
}

/// Card mejorado con hover effects
class EnhancedCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final bool elevated;

  const EnhancedCard({
    Key? key,
    required this.child,
    this.onTap,
    this.padding,
    this.backgroundColor,
    this.elevated = true,
  }) : super(key: key);

  @override
  State<EnhancedCard> createState() => _EnhancedCardState();
}

class _EnhancedCardState extends State<EnhancedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.normal,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppAnimations.smooth,
      ),
    );

    _elevationAnimation =
        Tween<double>(
          begin: widget.elevated ? 4.0 : 0.0,
          end: widget.elevated ? 12.0 : 2.0,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: AppAnimations.smooth,
          ),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Card(
            color: widget.backgroundColor ?? AppColors.surface,
            elevation: _elevationAnimation.value,
            shape: const RoundedRectangleBorder(
              borderRadius: AppBorders.medium,
            ),
            child: InkWell(
              onTap: widget.onTap,
              onHover: (isHovered) {
                if (isHovered) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }
              },
              borderRadius: AppBorders.medium,
              child: Padding(
                padding: widget.padding ?? const EdgeInsets.all(AppSpacing.md),
                child: widget.child,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Indicador de progreso con gamificación
class ProgressIndicator extends StatefulWidget {
  final double value; // 0.0 to 1.0
  final String? label;
  final Color? backgroundColor;
  final Color? progressColor;
  final bool showPercentage;
  final bool animated;

  const ProgressIndicator({
    Key? key,
    required this.value,
    this.label,
    this.backgroundColor,
    this.progressColor,
    this.showPercentage = true,
    this.animated = true,
  }) : super(key: key);

  @override
  State<ProgressIndicator> createState() => _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.slow,
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: widget.value).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppAnimations.smooth,
      ),
    );

    if (widget.animated) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(ProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && widget.animated) {
      _progressAnimation =
          Tween<double>(begin: oldWidget.value, end: widget.value).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: AppAnimations.smooth,
            ),
          );
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.label!, style: AppTypography.bodyMedium),
              if (widget.showPercentage)
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return Text(
                      '${(_progressAnimation.value * 100).round()}%',
                      style: AppTypography.caption.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    );
                  },
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? AppColors.surfaceVariant,
            borderRadius: AppBorders.small,
          ),
          child: AnimatedBuilder(
            animation: widget.animated
                ? _progressAnimation
                : kAlwaysCompleteAnimation,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: widget.animated
                    ? _progressAnimation.value
                    : widget.value,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(
                  widget.progressColor ?? AppColors.primary,
                ),
                borderRadius: AppBorders.small,
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Badge de notificación con animación
class NotificationBadge extends StatefulWidget {
  final int count;
  final Widget child;
  final Color? backgroundColor;
  final Color? textColor;

  const NotificationBadge({
    Key? key,
    required this.count,
    required this.child,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  State<NotificationBadge> createState() => _NotificationBadgeState();
}

class _NotificationBadgeState extends State<NotificationBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.normal,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppAnimations.bounce,
      ),
    );

    if (widget.count > 0) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(NotificationBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.count != widget.count) {
      if (widget.count > 0) {
        _animationController.reset();
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        widget.child,
        if (widget.count > 0)
          Positioned(
            right: -8,
            top: -8,
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: widget.backgroundColor ?? AppColors.error,
                      borderRadius: AppBorders.pill,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      widget.count > 99 ? '99+' : widget.count.toString(),
                      style: AppTypography.caption.copyWith(
                        color: widget.textColor ?? Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

/// Input field mejorado con validación visual
class EnhancedTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;

  const EnhancedTextField({
    Key? key,
    this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<EnhancedTextField> createState() => _EnhancedTextFieldState();
}

class _EnhancedTextFieldState extends State<EnhancedTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _borderColorAnimation;
  bool _isFocused = false;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.normal,
      vsync: this,
    );

    _borderColorAnimation = ColorTween(
      begin: AppColors.textTertiary,
      end: AppColors.primary,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onFocusChange(bool hasFocus) {
    setState(() {
      _isFocused = hasFocus;
    });

    if (hasFocus) {
      _animationController.forward();
    } else {
      _animationController.reverse();
      // Validate on focus lost
      if (widget.validator != null && widget.controller != null) {
        setState(() {
          _validationError = widget.validator!(widget.controller!.text);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null || _validationError != null;
    final errorText = widget.errorText ?? _validationError;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        AnimatedBuilder(
          animation: _borderColorAnimation,
          builder: (context, child) {
            return Focus(
              onFocusChange: _onFocusChange,
              child: TextFormField(
                controller: widget.controller,
                obscureText: widget.obscureText,
                keyboardType: widget.keyboardType,
                enabled: widget.enabled,
                onChanged: (value) {
                  widget.onChanged?.call(value);
                  // Clear validation error on change
                  if (_validationError != null) {
                    setState(() {
                      _validationError = null;
                    });
                  }
                },
                style: AppTypography.bodyLarge,
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  prefixIcon: widget.prefixIcon != null
                      ? Icon(
                          widget.prefixIcon,
                          color: _isFocused || hasError
                              ? (hasError ? AppColors.error : AppColors.primary)
                              : AppColors.textTertiary,
                        )
                      : null,
                  suffixIcon: widget.suffixIcon,
                  filled: true,
                  fillColor: widget.enabled
                      ? AppColors.surfaceVariant
                      : AppColors.textTertiary.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: AppBorders.medium,
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppBorders.medium,
                    borderSide: BorderSide(
                      color: hasError
                          ? AppColors.error
                          : _borderColorAnimation.value!,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: AppBorders.medium,
                    borderSide: const BorderSide(
                      color: AppColors.error,
                      width: 2,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: AppBorders.medium,
                    borderSide: const BorderSide(
                      color: AppColors.error,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(AppSpacing.md),
                ),
              ),
            );
          },
        ),
        if (hasError) ...[
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const Icon(Icons.error_outline, size: 16, color: AppColors.error),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  errorText!,
                  style: AppTypography.caption.copyWith(color: AppColors.error),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
