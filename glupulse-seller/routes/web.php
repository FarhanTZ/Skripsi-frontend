<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('auth.login');
});

Route::prefix('seller')->group(function () {
    Route::view('/dashboard', 'seller.dashboard')->name('seller.dashboard');
    Route::view('/menu', 'seller.menu')->name('seller.menu');
    Route::view('/orders', 'seller.orders')->name('seller.orders');
    Route::view('/finance', 'seller.finance')->name('seller.finance');
    Route::view('/settings', 'seller.settings')->name('seller.settings');
});