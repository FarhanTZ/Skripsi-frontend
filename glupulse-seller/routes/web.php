<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;

Route::get('/', [AuthController::class, 'showLoginForm'])->name('login');
Route::post('/login', [AuthController::class, 'login'])->name('login.perform');

Route::get('/register', [AuthController::class, 'showRegisterForm'])->name('register');
Route::post('/register', [AuthController::class, 'register'])->name('register.perform');

Route::post('/logout', [AuthController::class, 'logout'])->name('logout');

Route::prefix('seller')->group(function () {
    Route::view('/dashboard', 'seller.dashboard')->name('seller.dashboard');
    Route::view('/menu', 'seller.menu')->name('seller.menu');
    Route::view('/menu/create', 'seller.menu-create')->name('seller.menu.create');
    // Route untuk menampilkan halaman edit menu. {id} adalah placeholder untuk ID menu.
    Route::view('/menu/{id}/edit', 'seller.menu-edit')->name('seller.menu.edit');
    // Route untuk menghandle proses update data menu.
    // Ini tidak menampilkan view, tapi akan menghandle logic (nantinya).
    // Untuk sekarang, kita arahkan kembali ke halaman menu.
    Route::put('/menu/{id}', function () {
        return redirect()->route('seller.menu');
    })->name('seller.menu.update');

    // Routes untuk Promosi
    Route::view('/promotions', 'seller.promotion')->name('seller.promotion.index');
    Route::view('/promotions/create', 'seller.promotion-create')->name('seller.promotion.create');
    Route::post('/promotions', function () {
        return redirect()->route('seller.promotion.index');
    })->name('seller.promotion.store');
    Route::view('/promotions/{id}/edit', 'seller.promotion-edit')->name('seller.promotion.edit');
    Route::put('/promotions/{id}', function () {
        return redirect()->route('seller.promotion.index');
    })->name('seller.promotion.update');
    Route::delete('/promotions/{id}', function () {
        return redirect()->route('seller.promotion.index');
    })->name('seller.promotion.destroy');

    Route::view('/orders', 'seller.orders')->name('seller.orders');
    Route::view('/finance', 'seller.finance')->name('seller.finance');
    Route::view('/settings', 'seller.settings')->name('seller.settings');
});