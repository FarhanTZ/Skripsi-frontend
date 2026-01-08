import 'package:flutter/material.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'package:glupulse/core/widgets/custom_date_field.dart';
import 'package:glupulse/core/widgets/custom_dropdown_field.dart';
import 'package:glupulse/core/widgets/custom_text_field.dart';
import 'package:glupulse/core/widgets/password_text_field.dart';

class RegisterBody extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController dobController;
  final TextEditingController addressController;
  final TextEditingController cityController;
  final String? selectedGender;
  final List<String> genders;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool isLoading;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onToggleConfirmPasswordVisibility;
  final Function(String) onDateSelected;
  final Function(String?) onGenderChanged;
  final VoidCallback onRegister;
  final VoidCallback onLoginWithGoogle;
  final VoidCallback onGoToLogin;

  const RegisterBody({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.dobController,
    required this.addressController,
    required this.cityController,
    required this.selectedGender,
    required this.genders,
    required this.isPasswordVisible,
    required this.isConfirmPasswordVisible,
    required this.isLoading,
    required this.onTogglePasswordVisibility,
    required this.onToggleConfirmPasswordVisibility,
    required this.onDateSelected,
    required this.onGenderChanged,
    required this.onRegister,
    required this.onLoginWithGoogle,
    required this.onGoToLogin,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            'assets/images/Ellipse.png',
            width: double.infinity,
            height: 220,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Create Account!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(child: CustomTextField(controller: firstNameController, hintText: 'First Name')),
                    const SizedBox(width: 16),
                    Expanded(child: CustomTextField(controller: lastNameController, hintText: 'Last Name')),
                  ],
                ),
                const SizedBox(height: 24),
                CustomTextField(controller: usernameController, hintText: 'Username'),
                const SizedBox(height: 24),
                CustomTextField(controller: emailController, hintText: 'Email', keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 24),
                PasswordTextField(controller: passwordController, hintText: 'Password', isVisible: isPasswordVisible, onToggleVisibility: onTogglePasswordVisibility),
                const SizedBox(height: 24),
                PasswordTextField(controller: confirmPasswordController, hintText: 'Confirm Password', isVisible: isConfirmPasswordVisible, onToggleVisibility: onToggleConfirmPasswordVisibility),
                const SizedBox(height: 24),
                CustomDateField(controller: dobController, hintText: 'Date of Birth', onDateSelected: onDateSelected),
                const SizedBox(height: 24),
                CustomDropdownField<String>(
                  value: selectedGender,
                  hintText: 'Gender',
                  items: genders,
                  onChanged: onGenderChanged,
                  itemBuilder: (value) => Text(value),
                ),
                const SizedBox(height: 24),
                CustomTextField(controller: addressController, hintText: 'Address'),
                const SizedBox(height: 24),
                CustomTextField(controller: cityController, hintText: 'City'),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: ElevatedButton(
                    onPressed: isLoading ? null : onRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      elevation: 5,
                    ),
                    child: isLoading ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3)) : const Text('Sign Up', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                  child: Row(
                    children: [
                      Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text('OR', style: TextStyle(color: Colors.grey)),
                      ),
                      Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: isLoading ? null : onLoginWithGoogle,
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Image.asset('assets/images/google_logo.png', height: 30, width: 30),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?", style: TextStyle(color: AppTheme.inputLabelColor)),
                    TextButton(
                      onPressed: onGoToLogin,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, decoration: TextDecoration.underline, decorationColor: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
