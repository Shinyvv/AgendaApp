/// Pantalla de login mejorada con principios UX/UI
///
/// Implementa retención de atención, micro-interacciones,
/// y CTAs efectivos basados en las mejores prácticas.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design/app_design_system.dart';
import '../../../core/widgets/enhanced_ui_components.dart';
import '../../../core/providers/auth_provider.dart';

class EnhancedLoginScreen extends ConsumerStatefulWidget {
  const EnhancedLoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<EnhancedLoginScreen> createState() =>
      _EnhancedLoginScreenState();
}

class _EnhancedLoginScreenState extends ConsumerState<EnhancedLoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  // Animaciones para micro-interacciones
  late AnimationController _fadeAnimationController;
  late AnimationController _slideAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Configurar animaciones de entrada
    _fadeAnimationController = AnimationController(
      duration: AppAnimations.slow,
      vsync: this,
    );

    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeAnimationController,
        curve: AppAnimations.fadeIn,
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _slideAnimationController,
            curve: AppAnimations.slideIn,
          ),
        );

    // Iniciar animaciones
    _fadeAnimationController.forward();
    _slideAnimationController.forward();
  }

  @override
  void dispose() {
    _fadeAnimationController.dispose();
    _slideAnimationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El email es requerido';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Ingresa un email válido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }
    if (value.length < 6) {
      return 'Mínimo 6 caracteres';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await ref
          .read(authServiceProvider)
          .signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: const RoundedRectangleBorder(borderRadius: AppBorders.small),
          ),
        );
      }
    }
  }

  void _handleForgotPassword() {
    // Implementar recuperación de contraseña
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Función de recuperación próximamente'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleSocialLogin(String provider) async {
    print('🔄 LoginScreen: _handleSocialLogin llamado con provider: $provider');

    if (provider == 'Google') {
      try {
        print('🔄 LoginScreen: Iniciando Google login...');
        setState(() => _isLoading = true);

        final authService = ref.read(authServiceProvider);
        print(
          '🔄 LoginScreen: AuthService obtenido, llamando signInWithGoogle...',
        );

        final userCredential = await authService.signInWithGoogle();
        print('🔄 LoginScreen: signInWithGoogle completado');

        if (userCredential != null && mounted) {
          print(
            '✅ LoginScreen: Login exitoso para: ${userCredential.user?.displayName}',
          );
          // Login exitoso - el router automáticamente navegará al dashboard
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '¡Bienvenido ${userCredential.user?.displayName ?? 'Usuario'}!',
              ),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          print('⚠️ LoginScreen: userCredential es null');
        }
      } catch (e) {
        print('❌ LoginScreen: Error en Google login: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al iniciar sesión con Google: $e'),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } finally {
        if (mounted) {
          print('🔄 LoginScreen: Finalizando, setState isLoading = false');
          setState(() => _isLoading = false);
        }
      }
    } else {
      // Otros proveedores (Facebook, etc.)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login con $provider próximamente'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.xxl),

                    // Header con impacto visual (primeros 8 segundos)
                    _buildHeader(),

                    const SizedBox(height: AppSpacing.xxl),

                    // Formulario principal
                    _buildLoginForm(isLoading),

                    const SizedBox(height: AppSpacing.lg),

                    // Opciones adicionales
                    _buildAdditionalOptions(),

                    const SizedBox(height: AppSpacing.xl),

                    // Login social (alternativas)
                    _buildSocialLogin(),

                    const SizedBox(height: AppSpacing.lg),

                    // CTA de registro
                    _buildSignUpPrompt(),
                  ],
                ),
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
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.large,
                ),
                child: const Icon(Icons.work, size: 40, color: Colors.white),
              ),
            );
          },
        ),

        const SizedBox(height: AppSpacing.lg),

        // Título impactante (retención de atención)
        Text(
          '¡Bienvenido de vuelta!',
          style: AppTypography.h1.copyWith(color: AppColors.textPrimary),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppSpacing.sm),

        // Subtítulo con valor claro
        Text(
          'Accede a tu cuenta y continúa\ngestionando tus servicios',
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoginForm(bool isLoading) {
    return EnhancedCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          // Campo email con validación visual
          EnhancedTextField(
            label: 'Email',
            hint: 'tu@email.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            validator: _validateEmail,
            enabled: !isLoading,
          ),

          const SizedBox(height: AppSpacing.md),

          // Campo contraseña con toggle
          EnhancedTextField(
            label: 'Contraseña',
            hint: 'Tu contraseña segura',
            controller: _passwordController,
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

          // Remember me checkbox y Forgot Password en filas separadas
          Row(
            children: [
              Checkbox(
                value: _rememberMe,
                onChanged: isLoading
                    ? null
                    : (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                activeColor: AppColors.primary,
              ),
              Flexible(
                child: Text('Recordarme', style: AppTypography.bodyMedium),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xs),

          // Forgot password centrado
          Center(
            child: TextButton(
              onPressed: isLoading ? null : _handleForgotPassword,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: Text(
                '¿Olvidaste tu contraseña?',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                  fontSize: 14,
                ),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // CTA principal - login (optimizado para conversión)
          PrimaryCTAButton(
            text: 'Iniciar Sesión',
            onPressed: isLoading ? null : _handleLogin,
            isLoading: isLoading,
            icon: Icons.login,
            fullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalOptions() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.textTertiary.withOpacity(0.3),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text('o continúa con', style: AppTypography.caption),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.textTertiary.withOpacity(0.3),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLogin() {
    return Row(
      children: [
        Expanded(
          child: SecondaryCTAButton(
            text: 'Google',
            icon: Icons.g_mobiledata,
            onPressed: () => _handleSocialLogin('Google'),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: SecondaryCTAButton(
            text: 'Facebook',
            icon: Icons.facebook,
            onPressed: () => _handleSocialLogin('Facebook'),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpPrompt() {
    return Column(
      children: [
        Text(
          '¿No tienes cuenta?',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // CTA secundario con urgencia sutil
        TextButton(
          onPressed: () {
            // Navegar a registro
            context.push('/register');
          },
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
              Text(
                'Crear cuenta gratis',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              const Icon(Icons.arrow_forward, size: AppIcons.small),
            ],
          ),
        ),
      ],
    );
  }
}
