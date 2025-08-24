/// Pantalla de registro mejorada con principios UX/UI
///
/// Implementa los mismos principios de diseño que el login
/// con formulario optimizado para conversión de registro.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/app_design_system.dart';
import '../../../core/widgets/enhanced_ui_components.dart' as ui;
import '../../../core/providers/auth_provider.dart';

class EnhancedRegisterScreen extends ConsumerStatefulWidget {
  const EnhancedRegisterScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<EnhancedRegisterScreen> createState() =>
      _EnhancedRegisterScreenState();
}

class _EnhancedRegisterScreenState extends ConsumerState<EnhancedRegisterScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  bool _isLoading = false;

  // Animaciones para micro-interacciones
  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Configurar animaciones de entrada
    _fadeAnimationController = AnimationController(
      duration: AppAnimations.slow,
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeInOut,
    );

    // Iniciar animaciones
    _fadeAnimationController.forward();
  }

  @override
  void dispose() {
    _fadeAnimationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Validaciones
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa tu nombre completo';
    }
    if (value.length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa tu email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Ingresa un email válido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa tu contraseña';
    }
    if (value.length < 6) {
      return 'Mínimo 6 caracteres';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirma tu contraseña';
    }
    if (value != _passwordController.text) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Debes aceptar los términos y condiciones'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref
          .read(authServiceProvider)
          .signUpWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            displayName: _nameController.text.trim(),
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('¡Cuenta creada exitosamente!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleGoogleSignUp() async {
    setState(() => _isLoading = true);

    try {
      await ref.read(authServiceProvider).signInWithGoogle();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('¡Registro exitoso con Google!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading || _isLoading;

    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.xl),

                  // Header con animación
                  _buildHeader(),

                  const SizedBox(height: AppSpacing.xxl),

                  // Formulario principal
                  _buildRegisterForm(isLoading),

                  const SizedBox(height: AppSpacing.lg),

                  // Login social alternativo
                  _buildSocialSignUp(),

                  const SizedBox(height: AppSpacing.lg),

                  // Link a login
                  _buildLoginPrompt(),

                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Logo/Icono animado
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1200),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: AppAnimations.bounce,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: AppColors.successGradient,
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.large,
                ),
                child: const Icon(
                  Icons.person_add,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),

        const SizedBox(height: AppSpacing.lg),

        // Título principal (optimizado para retención)
        Text(
          '¡Únete ahora!',
          style: AppTypography.h1.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppSpacing.sm),

        // Subtítulo con beneficio claro
        Text(
          'Crea tu cuenta gratis y comienza a ganar dinero',
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRegisterForm(bool isLoading) {
    return Column(
      children: [
        // Campo de nombre
        ui.EnhancedTextField(
          controller: _nameController,
          label: 'Nombre completo',
          hint: 'Ingresa tu nombre y apellido',
          prefixIcon: Icons.person_outlined,
          validator: _validateName,
          enabled: !isLoading,
        ),

        const SizedBox(height: AppSpacing.md),

        // Campo de email
        ui.EnhancedTextField(
          controller: _emailController,
          label: 'Email',
          hint: 'ejemplo@correo.com',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: _validateEmail,
          enabled: !isLoading,
        ),

        const SizedBox(height: AppSpacing.md),

        // Campo de contraseña
        ui.EnhancedTextField(
          controller: _passwordController,
          label: 'Contraseña',
          hint: 'Mínimo 6 caracteres',
          obscureText: _obscurePassword,
          prefixIcon: Icons.lock_outlined,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility : Icons.visibility_off,
              color: AppColors.textSecondary,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          validator: _validatePassword,
          enabled: !isLoading,
        ),

        const SizedBox(height: AppSpacing.md),

        // Campo de confirmar contraseña
        ui.EnhancedTextField(
          controller: _confirmPasswordController,
          label: 'Confirmar contraseña',
          hint: 'Confirma tu contraseña',
          obscureText: _obscureConfirmPassword,
          prefixIcon: Icons.lock_outlined,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
              color: AppColors.textSecondary,
            ),
            onPressed: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
          ),
          validator: _validateConfirmPassword,
          enabled: !isLoading,
        ),

        const SizedBox(height: AppSpacing.md),

        // Términos y condiciones
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: _acceptTerms,
              onChanged: isLoading
                  ? null
                  : (value) {
                      setState(() {
                        _acceptTerms = value ?? false;
                      });
                    },
              activeColor: AppColors.primary,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: RichText(
                  text: TextSpan(
                    style: AppTypography.bodyMedium,
                    children: [
                      const TextSpan(text: 'Acepto los '),
                      TextSpan(
                        text: 'términos y condiciones',
                        style: TextStyle(
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const TextSpan(text: ' y la '),
                      TextSpan(
                        text: 'política de privacidad',
                        style: TextStyle(
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.xl),

        // CTA principal - registro
        ui.PrimaryCTAButton(
          text: '¡Crear mi cuenta gratis!',
          onPressed: isLoading ? null : _handleRegister,
          isLoading: isLoading,
          icon: Icons.rocket_launch,
        ),
      ],
    );
  }

  Widget _buildSocialSignUp() {
    return Column(
      children: [
        // Divisor "o"
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text(
                'o regístrate con',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),

        const SizedBox(height: AppSpacing.lg),

        // Botón de Google
        SizedBox(
          width: double.infinity,
          child: ui.PrimaryCTAButton(
            text: 'Registrarse con Google',
            onPressed: _isLoading ? null : _handleGoogleSignUp,
            backgroundColor: Colors.white,
            textColor: AppColors.textPrimary,
            icon: Icons.g_mobiledata,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginPrompt() {
    return Column(
      children: [
        Text(
          '¿Ya tienes una cuenta?',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.arrow_back, size: AppIcons.small),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Iniciar sesión',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
