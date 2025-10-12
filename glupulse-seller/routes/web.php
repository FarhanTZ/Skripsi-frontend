<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('auth.login');
});

Route::prefix('seller')->group(function () {
    Route::view('/dashboard', 'seller.dashboard')->name('seller.dashboard');
    Route::view('/menu', 'seller.menu')->name('seller.menu');
    Route::view('/menu/create', 'seller.menu-create')->name('seller.menu.create');
    // Route untuk menampilkan halaman edit menu. {id} adalah placeholder untuk ID menu.
    Route::view('/menu/{id}/edit', 'seller.menu-edit')->name('seller.menu.edit');
    Route::view('/orders', 'seller.orders')->name('seller.orders');
    Route::view('/finance', 'seller.finance')->name('seller.finance');
    Route::view('/settings', 'seller.settings')->name('seller.settings');
});