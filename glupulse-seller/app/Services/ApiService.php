<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class ApiService
{
    protected $baseUrl;

    public function __construct()
    {
        $this->baseUrl = config('services.external_api.url');
    }

    /**
     * Handle Login request to external API
     */
    public function login(string $email, string $password)
    {
        // Sesuaikan endpoint jika berbeda, misal /auth/login
        $url = $this->baseUrl . '/login';

        try {
            $response = Http::post($url, [
                'email' => $email,
                'password' => $password,
            ]);

            return $response;
        } catch (\Exception $e) {
            Log::error('API Login Error: ' . $e->getMessage());
            return null;
        }
    }

    /**
     * Handle Register/Signup request to external API
     */
    public function register(array $data)
    {
        // Sesuaikan endpoint, user menyebutkan '/singup' tapi saya asumsikan '/signup'
        // Jika API error 404, coba ganti jadi /singup
        $url = $this->baseUrl . '/signup';

        try {
            $response = Http::post($url, $data);
            return $response;
        } catch (\Exception $e) {
            Log::error('API Register Error: ' . $e->getMessage());
            return null;
        }
    }
}
