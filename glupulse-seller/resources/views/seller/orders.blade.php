@extends('layouts.sellerapp')

@section('content')
<div class="flex justify-between items-center mb-6">
    <h2 class="text-2xl font-bold text-gray-800">Daftar Pesanan</h2>
    <!-- Kolom Pencarian -->
    <div class="relative">
        <div class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none">
            <svg class="w-4 h-4 text-gray-500" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 20 20">
                <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m19 19-4-4m0-7A7 7 0 1 1 1 8a7 7 0 0 1 14 0Z"/>
            </svg>
        </div>
        <input type="search" id="order-search" class="block w-full p-2.5 pl-10 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50 focus:ring-blue-500 focus:border-blue-500" placeholder="Cari ID Pesanan...">
    </div>
</div>

<!-- Navigasi Tab -->
<div class="mb-4 border-b border-gray-200">
    <ul class="flex flex-wrap -mb-px text-sm font-medium text-center" id="myTab" data-tabs-toggle="#myTabContent" role="tablist">
        <li class="mr-2" role="presentation">
            <button class="inline-block p-4 border-b-2 rounded-t-lg" id="new-tab" data-tabs-target="#new" type="button" role="tab" aria-controls="new" aria-selected="true">Pesanan Baru (3)</button>
        </li>
        <li class="mr-2" role="presentation">
            <button class="inline-block p-4 border-b-2 border-transparent rounded-t-lg hover:text-gray-600 hover:border-gray-300" id="progress-tab" data-tabs-target="#progress" type="button" role="tab" aria-controls="progress" aria-selected="false">Diproses (5)</button>
        </li>
        <li class="mr-2" role="presentation">
            <button class="inline-block p-4 border-b-2 border-transparent rounded-t-lg hover:text-gray-600 hover:border-gray-300" id="completed-tab" data-tabs-target="#completed" type="button" role="tab" aria-controls="completed" aria-selected="false">Selesai</button>
        </li>
    </ul>
</div>

<!-- Konten Tab -->
<div id="myTabContent">
    <!-- Konten Pesanan Baru -->
    <div class="hidden p-4 rounded-lg bg-gray-50" id="new" role="tabpanel" aria-labelledby="new-tab">
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <!-- Contoh Kartu Pesanan -->
            <div class="bg-white p-6 rounded-lg shadow-md">
                <div class="flex justify-between items-start">
                    <div>
                        <p class="font-bold text-lg text-gray-800">#ORD-12345</p>
                        <p class="text-sm text-gray-500">John Doe</p>
                    </div>
                    <span class="text-sm font-semibold text-blue-600">Baru</span>
                </div>
                <hr class="my-4">
                <div class="space-y-2 text-sm">
                    <p>2x Nasi Goreng Spesial</p>
                    <p>1x Es Teh Manis</p>
                </div>
                <hr class="my-4">
                <div class="flex justify-between items-center">
                    <p class="font-bold text-gray-900">Rp 55.000</p>
                    <button class="bg-green-500 hover:bg-green-600 text-white font-bold py-2 px-4 rounded-lg">
                        Terima
                    </button>
                </div>
            </div>
            <!-- Kartu lainnya -->
        </div>
    </div>
    <!-- Konten Diproses -->
    <div class="hidden p-4 rounded-lg bg-gray-50" id="progress" role="tabpanel" aria-labelledby="progress-tab">
        <p class="text-gray-600">Belum ada pesanan yang sedang diproses.</p>
    </div>
    <!-- Konten Selesai -->
    <div class="hidden p-4 rounded-lg bg-gray-50" id="completed" role="tabpanel" aria-labelledby="completed-tab">
        <p class="text-gray-600">Belum ada pesanan yang selesai.</p>
    </div>
</div>

<!-- Pastikan Anda memuat JavaScript untuk fungsionalitas tab (misalnya dari Flowbite) -->
@endsection