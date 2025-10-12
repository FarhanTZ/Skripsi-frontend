@extends('layouts.sellerapp')

@section('content')
<div class="flex flex-wrap justify-between items-center mb-6 gap-4">
    <h2 class="text-2xl font-bold text-gray-800">Kelola Menu</h2>
    <div class="flex items-center gap-4">
        <!-- Filter Kategori Dropdown -->
        <button id="category-filter-button" data-dropdown-toggle="category-filter-dropdown" class="text-gray-700 bg-white hover:bg-gray-100 border border-gray-300 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center inline-flex items-center" type="button">
            Semua Kategori
            <svg class="w-2.5 h-2.5 ms-3" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 10 6"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 1 4 4 4-4"/></svg>
        </button>
        <div id="category-filter-dropdown" class="z-10 hidden bg-white divide-y divide-gray-100 rounded-lg shadow w-44">
            <ul class="py-2 text-sm text-gray-700" aria-labelledby="category-filter-button">
              <li><a href="#" class="block px-4 py-2 hover:bg-gray-100">Semua Kategori</a></li>
              <li><a href="#" class="block px-4 py-2 hover:bg-gray-100">Makanan Utama</a></li>
              <li><a href="#" class="block px-4 py-2 hover:bg-gray-100">Minuman</a></li>
              <li><a href="#" class="block px-4 py-2 hover:bg-gray-100">Camilan</a></li>
            </ul>
        </div>

        <!-- Filter Status Dropdown -->
        <button id="status-filter-button" data-dropdown-toggle="status-filter-dropdown" class="text-gray-700 bg-white hover:bg-gray-100 border border-gray-300 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center inline-flex items-center" type="button">
            Semua Status
            <svg class="w-2.5 h-2.5 ms-3" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 10 6"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 1 4 4 4-4"/></svg>
        </button>
        <div id="status-filter-dropdown" class="z-10 hidden bg-white divide-y divide-gray-100 rounded-lg shadow w-44">
            <ul class="py-2 text-sm text-gray-700" aria-labelledby="status-filter-button">
              <li><a href="#" class="block px-4 py-2 hover:bg-gray-100">Semua Status</a></li>
              <li><a href="#" class="block px-4 py-2 hover:bg-gray-100">Tersedia</a></li>
              <li><a href="#" class="block px-4 py-2 hover:bg-gray-100">Habis</a></li>
            </ul>
        </div>

        {{-- Arahkan ke route untuk membuat menu baru --}}
        <a href="{{ route('seller.menu.create') }}" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-lg flex items-center whitespace-nowrap">
            <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path></svg>
            Tambah Menu
        </a>
    </div>
</div>

<!-- Tabel Menu -->
<div class="bg-white shadow-md rounded-lg overflow-hidden">
    <div class="overflow-x-auto">
        <table class="min-w-full leading-normal">
            <thead>
                <tr>
                    <th class="px-5 py-3 border-b-2 border-gray-200 bg-gray-100 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                        Menu
                    </th>
                    <th class="px-5 py-3 border-b-2 border-gray-200 bg-gray-100 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                        Kategori
                    </th>
                    <th class="px-5 py-3 border-b-2 border-gray-200 bg-gray-100 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                        Harga
                    </th>
                    <th class="px-5 py-3 border-b-2 border-gray-200 bg-gray-100 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                        Status
                    </th>
                    <th class="px-5 py-3 border-b-2 border-gray-200 bg-gray-100 text-center text-xs font-semibold text-gray-600 uppercase tracking-wider">
                        Aksi
                    </th>
                </tr>
            </thead>
            <tbody>
                <!-- Contoh Item 1 -->
                <tr>
                    <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm">
                        <div class="flex items-center">
                            <div class="flex-shrink-0 w-16 h-16">
                                <img class="w-full h-full rounded-md object-cover" src="https://via.placeholder.com/150" alt="Nasi Goreng" />
                            </div>
                            <div class="ml-4">
                                <p class="text-gray-900 whitespace-no-wrap font-semibold">
                                    Nasi Goreng Spesial
                                </p>
                            </div>
                        </div>
                    </td>
                    <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm">
                        <p class="text-gray-900 whitespace-no-wrap">Makanan Utama</p>
                    </td>
                    <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm">
                        <p class="text-gray-900 whitespace-no-wrap">Rp 25.000</p>
                    </td>
                    <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm">
                        <span class="relative inline-block px-3 py-1 font-semibold text-green-900 leading-tight">
                            <span aria-hidden class="absolute inset-0 bg-green-200 opacity-50 rounded-full"></span>
                            <span class="relative">Tersedia</span>
                        </span>
                    </td>
                    <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm text-center">
                        {{-- Arahkan ke route edit dengan parameter ID menu (contoh: 1) --}}
                        <a href="{{ route('seller.menu.edit', ['id' => 1]) }}" class="text-indigo-600 hover:text-indigo-900 mr-4">Edit</a>
                        <a href="#" class="text-red-600 hover:text-red-900">Hapus</a>
                    </td>
                </tr>
                <!-- Contoh Item 2 -->
                <tr>
                    <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm">
                        <div class="flex items-center">
                            <div class="flex-shrink-0 w-16 h-16">
                                <img class="w-full h-full rounded-md object-cover" src="https://via.placeholder.com/150" alt="Es Teh" />
                            </div>
                            <div class="ml-4">
                                <p class="text-gray-900 whitespace-no-wrap font-semibold">
                                    Es Teh Manis
                                </p>
                            </div>
                        </div>
                    </td>
                    <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm">
                        <p class="text-gray-900 whitespace-no-wrap">Minuman</p>
                    </td>
                    <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm">
                        <p class="text-gray-900 whitespace-no-wrap">Rp 8.000</p>
                    </td>
                    <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm">
                        <span class="relative inline-block px-3 py-1 font-semibold text-green-900 leading-tight">
                            <span aria-hidden class="absolute inset-0 bg-green-200 opacity-50 rounded-full"></span>
                            <span class="relative">Tersedia</span>
                        </span>
                    </td>
                    <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm text-center">
                        <a href="{{ route('seller.menu.edit', ['id' => 2]) }}" class="text-indigo-600 hover:text-indigo-900 mr-4">Edit</a>
                        <a href="#" class="text-red-600 hover:text-red-900">Hapus</a>
                    </td>
                </tr>
                <!-- Contoh Item 3 -->
                <tr>
                    <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm">
                        <div class="flex items-center">
                            <div class="flex-shrink-0 w-16 h-16">
                                <img class="w-full h-full rounded-md object-cover" src="https://via.placeholder.com/150" alt="Kentang Goreng" />
                            </div>
                            <div class="ml-4">
                                <p class="text-gray-900 whitespace-no-wrap font-semibold">
                                    Kentang Goreng
                                </p>
                            </div>
                        </div>
                    </td>
                    <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm">
                        <p class="text-gray-900 whitespace-no-wrap">Camilan</p>
                    </td>
                    <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm">
                        <p class="text-gray-900 whitespace-no-wrap">Rp 15.000</p>
                    </td>
                    <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm">
                        <span class="relative inline-block px-3 py-1 font-semibold text-red-900 leading-tight">
                            <span aria-hidden class="absolute inset-0 bg-red-200 opacity-50 rounded-full"></span>
                            <span class="relative">Habis</span>
                        </span>
                    </td>
                    <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm text-center">
                        <a href="{{ route('seller.menu.edit', ['id' => 3]) }}" class="text-indigo-600 hover:text-indigo-900 mr-4">Edit</a>
                        <a href="#" class="text-red-600 hover:text-red-900">Hapus</a>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</div>
@endsection