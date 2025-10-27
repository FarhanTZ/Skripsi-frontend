import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/features/auth/domain/usecases/register_usecase.dart';
import 'package:glupulse/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:glupulse/features/auth/presentation/cubit/auth_state.dart';
import 'package:glupulse/features/auth/presentation/pages/otp_verification_page.dart';
import 'package:glupulse/features/auth/presentation/widgets/register_body.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _dobController = TextEditingController();
  final _addressController = TextEditingController(); // Tambahan
  final _cityController = TextEditingController(); // Tambahan
  String? _selectedGender;
  final List<String> _genders = ['Male', 'Female'];
  bool _isPasswordVisible = false; // Tetap pertahankan untuk UI
  bool _isConfirmPasswordVisible = false; // Tetap pertahankan untuk UI

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _isPasswordVisible = false;
    _isConfirmPasswordVisible = false;
    super.dispose();
  }

  Future<void> _register() async {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final dob = _dobController.text.trim();
    final address = _addressController.text.trim();
    final city = _cityController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty || username.isEmpty || email.isEmpty || password.isEmpty || dob.isEmpty || _selectedGender == null || address.isEmpty || city.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi!')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password dan konfirmasi password tidak cocok!')),
      );
      return;
    }

    final params = RegisterParams(
      username: username,
      password: password,
      email: email,
      firstName: firstName,
      lastName: lastName,
      dob: dob,
      gender: _selectedGender!,
      addressLine1: address,
      city: city,
    );

    context.read<AuthCubit>().register(params);
  }

  // Fungsi untuk memanggil login/register dengan Google
  Future<void> _loginWithGoogle() async {
    context.read<AuthCubit>().loginWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthOtpRequired) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => OtpVerificationPage(userId: state.user.id)));
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: Colors.white,
          body: RegisterBody(
            firstNameController: _firstNameController,
            lastNameController: _lastNameController,
            usernameController: _usernameController,
            emailController: _emailController,
            passwordController: _passwordController,
            confirmPasswordController: _confirmPasswordController,
            dobController: _dobController,
            addressController: _addressController,
            cityController: _cityController,
            selectedGender: _selectedGender,
            genders: _genders,
            isPasswordVisible: _isPasswordVisible,
            isConfirmPasswordVisible: _isConfirmPasswordVisible,
            isLoading: isLoading,
            onTogglePasswordVisibility: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
            onToggleConfirmPasswordVisibility: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
            onDateSelected: (formattedDate) => setState(() => _dobController.text = formattedDate),
            onGenderChanged: (newValue) => setState(() => _selectedGender = newValue),
            onRegister: _register,
            onLoginWithGoogle: _loginWithGoogle,
            onGoToLogin: () => Navigator.of(context).pop(),
          ),
        );
      },
    );
  }
}
