<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Services\ApiService;
use Illuminate\Support\Facades\Session;

class AuthController extends Controller
{
    protected $apiService;

    public function __construct(ApiService $apiService)
    {
        $this->apiService = $apiService;
    }

    // --- LOGIN ---

    public function showLoginForm()
    {
        return view('auth.login');
    }

    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required'
        ]);

        $response = $this->apiService->login($request->email, $request->password);

        if ($response && $response->successful()) {
            $data = $response->json();
            
            // Asumsi API mengembalikan token/user object
            // Kita simpan di session agar user dianggap "Login"
            // Sesuaikan 'access_token' dengan key JSON yang sebenarnya dari API Anda
            if (isset($data['access_token'])) {
                Session::put('api_token', $data['access_token']);
            }
            if (isset($data['user'])) {
                Session::put('user', $data['user']);
            }
            
            // Jika struktur JSON berbeda, sesuaikan di sini. 
            // Minimal kita set flag login
            Session::put('is_logged_in', true);

            return redirect()->route('seller.dashboard')->with('success', 'Login berhasil!');
        }

        // Jika gagal
        $errorMessage = 'Login gagal. Periksa email dan password.';
        if ($response) {
            // Ambil pesan error dari API jika ada
            $errorData = $response->json();
            $errorMessage = $errorData['message'] ?? $errorMessage;
        }

        return back()->withErrors(['email' => $errorMessage])->withInput($request->only('email'));
    }

    // --- REGISTER ---

    public function showRegisterForm()
    {
        return view('auth.register');
    }

    public function register(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|max:255',
            'password' => 'required|min:6|confirmed', // butuh field password_confirmation di view
        ]);

        $data = [
            'name' => $request->name,
            'email' => $request->email,
            'password' => $request->password,
            // Tambahkan field lain jika API membutuhkan (misal: phone_number)
        ];

        $response = $this->apiService->register($data);

        if ($response && $response->successful()) {
            return redirect()->route('login')->with('success', 'Registrasi berhasil! Silakan login.');
        }

        // Jika gagal
        $errorMessage = 'Registrasi gagal. Silakan coba lagi.';
        if ($response) {
            $errorData = $response->json();
            // Cek apakah API mengembalikan validasi error spesifik
            $errorMessage = $errorData['message'] ?? $errorMessage;
        }

        return back()->withErrors(['email' => $errorMessage])->withInput();
    }

    // --- LOGOUT ---

    public function logout()
    {
        Session::flush(); // Hapus semua data session
        return redirect()->route('login')->with('success', 'Anda telah logout.');
    }
}
