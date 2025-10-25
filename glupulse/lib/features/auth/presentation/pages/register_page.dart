import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'package:glupulse/features/auth/domain/usecases/register_usecase.dart';
import 'package:glupulse/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:glupulse/features/auth/presentation/pages/otp_verification_page.dart';

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
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Menambahkan gambar di sini
                Image.asset(
                  'assets/images/Ellipse.png', // Path disesuaikan dengan pubspec.yaml
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20), // Memberi jarak setelah gambar
                      Text(
                        'Create Account!',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 30),
                      // First Name and Last Name Fields
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                                controller: _firstNameController,
                                hintText: 'First Name'),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                                controller: _lastNameController, hintText: 'Last Name'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Username Field
                      _buildTextField(
                          controller: _usernameController, hintText: 'Username'),
                      const SizedBox(height: 24),
                      // Email Field
                      _buildTextField(
                          controller: _emailController,
                          hintText: 'Email',
                          keyboardType: TextInputType.emailAddress),
                      const SizedBox(height: 24),
                      // Password Field
                      _buildPasswordTextField(
                          controller: _passwordController,
                          hintText: 'Password',
                          isVisible: _isPasswordVisible,
                          onToggleVisibility: () {
                            setState(() => _isPasswordVisible = !_isPasswordVisible);
                          }),
                      const SizedBox(height: 24),
                      // Confirm Password Field
                      _buildPasswordTextField(
                          controller: _confirmPasswordController,
                          hintText: 'Confirm Password',
                          isVisible: _isConfirmPasswordVisible,
                          onToggleVisibility: () {
                            setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
                          }),
                      const SizedBox(height: 24),
                      // Date of Birth Field
                      _buildDateField(context),
                      const SizedBox(height: 24),
                      // Gender Dropdown
                      _buildGenderDropdown(),
                      const SizedBox(height: 24),
                      // Address Field
                      _buildTextField(
                          controller: _addressController, hintText: 'Address'),
                      const SizedBox(height: 24),
                      // City Field
                      _buildTextField(
                          controller: _cityController, hintText: 'City'),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            elevation: 5,
                          ),
                          child: isLoading
                              ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                              : const Text('Sign Up',
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.0), // Menambahkan padding yang sama
                        child: Row(
                          children: [
                            Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                'OR',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Tombol Sign Up dengan Google
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            // TODO: Implement Google Sign-Up logic
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Image.asset(
                              'assets/images/google_logo.png', // Pastikan Anda punya file ini
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
                            style: TextStyle(color: AppTheme.inputLabelColor),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Sign In',
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper widget untuk membuat TextField yang konsisten
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.inputFieldColor,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: AppTheme.inputLabelColor),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        ),
        obscureText: isPassword,
        keyboardType: keyboardType,
      ),
    );
  }

  // Helper widget khusus untuk password field dengan ikon mata
  Widget _buildPasswordTextField({
    required TextEditingController controller,
    required String hintText,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.inputFieldColor,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: AppTheme.inputLabelColor),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          suffixIcon: IconButton(
            icon: Icon(
              // Ganti ikon berdasarkan state isVisible
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: AppTheme.inputLabelColor,
            ),
            onPressed: onToggleVisibility,
          ),
        ),
        obscureText: !isVisible, // Sembunyikan teks jika !isVisible
        keyboardType: TextInputType.visiblePassword,
      ),
    );
  }

  // Helper widget untuk field tanggal lahir
  Widget _buildDateField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.inputFieldColor,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _dobController,
        readOnly: true,
        decoration: const InputDecoration(
          hintText: 'Date of Birth',
          hintStyle: TextStyle(color: AppTheme.inputLabelColor),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          suffixIcon: Icon(Icons.calendar_today, color: AppTheme.inputLabelColor),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (pickedDate != null) {
            // Format tanggal menjadi YYYY-MM-DD
            String formattedDate = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
            setState(() {
              _dobController.text = formattedDate;
            });
          }
        },
      ),
    );
  }

  // Helper widget untuk dropdown jenis kelamin
  Widget _buildGenderDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: AppTheme.inputFieldColor,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedGender,
          isExpanded: true,
          hint: const Text('Gender', style: TextStyle(color: AppTheme.inputLabelColor)),
          items: _genders.map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (newValue) => setState(() => _selectedGender = newValue),
        ),
      ),
    );
  }
}
