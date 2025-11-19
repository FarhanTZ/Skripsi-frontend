import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:glupulse/features/auth/presentation/cubit/auth_state.dart';
import 'package:glupulse/features/auth/presentation/pages/otp_verification_page.dart';
import 'package:glupulse/features/auth/presentation/pages/register_page.dart';
import 'package:glupulse/features/Dashboard/presentation/pages/Dashboard_page.dart';
import 'package:glupulse/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:glupulse/features/auth/presentation/widgets/login_body.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _isPasswordVisible = false;
    super.dispose();
  }

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username dan Password tidak boleh kosong!')),
      );
      return;
    }
    // Panggil metode login dari AuthCubit
    context.read<AuthCubit>().login(username, password);
  }

  Future<void> _loginWithGoogle() async {
    // Panggil metode login dari AuthCubit
    context.read<AuthCubit>().loginWithGoogle();
  }

  void _goToRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false,
          );
        } else if (state is AuthOtpRequired) {
          Navigator.of(context).push(
            MaterialPageRoute(
              // Kirim kedua ID, OtpVerificationPage akan menggunakan yang tidak null.
              builder: (context) => OtpVerificationPage(
                  userId: state.userId, pendingId: state.pendingId),
            ),
          );
        } else if (state is AuthProfileIncomplete) {
          // Jika profil tidak lengkap, arahkan ke EditProfilePage
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => const EditProfilePage(isFromAuthFlow: true)),
            (route) => false,
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: Colors.white,
          body: LoginBody(
            usernameController: _usernameController,
            passwordController: _passwordController,
            isPasswordVisible: _isPasswordVisible,
            isLoading: isLoading,
            onToggleVisibility: () =>
                setState(() => _isPasswordVisible = !_isPasswordVisible),
            onLogin: _login,
            onLoginWithGoogle: _loginWithGoogle,
            onGoToRegister: _goToRegister,
          ),
        );
      },
    );
  }
}