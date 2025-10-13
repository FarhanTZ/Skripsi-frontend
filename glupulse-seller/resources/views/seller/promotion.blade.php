@extends('layouts.sellerapp')

@section('content')
<!-- Sesuai dengan "Display Promotion View" -->
<div class="flex flex-wrap justify-between items-center mb-6 gap-4">
    <h2 class="text-2xl font-bold text-gray-800">Kelola Promosi</h2>
    <div class="flex items-center gap-4">
        <!-- Filter Status -->
        <button id="status-filter-button" data-dropdown-toggle="status-filter-dropdown" class="text-gray-700 bg-white hover:bg-gray-100 border border-gray-300 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center inline-flex items-center" type="button">
            Semua Status
            <svg class="w-2.5 h-2.5 ms-3" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 10 6"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 1 4 4 4-4"/></svg>
        </button>
        <div id="status-filter-dropdown" class="z-10 hidden bg-white divide-y divide-gray-100 rounded-lg shadow w-44">
            <ul class="py-2 text-sm text-gray-700" aria-labelledby="status-filter-button">
                <li><a href="#" class="block px-4 py-2 hover:bg-gray-100">Semua Status</a></li>
                <li><a href="#" class="block px-4 py-2 hover:bg-gray-100">Aktif</a></li>
                <li><a href="#" class="block px-4 py-2 hover:bg-gray-100">Tidak Aktif</a></li>
                <li><a href="#" class="block px-4 py-2 hover:bg-gray-100">Kadaluarsa</a></li>
            </ul>
        </div>
        <!-- Tombol "Click Form Input Promotion" -->
        <a href="{{ route('seller.promotion.create') }}" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-lg flex items-center whitespace-nowrap">
            <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path></svg>
            Tambah Promosi
        </a>
    </div>
</div>

<!-- Tabel Daftar Promosi -->
<div class="bg-white shadow-md rounded-lg overflow-hidden">
    <div class="overflow-x-auto">
        <table class="min-w-full leading-normal">
            <thead>
                <tr>
                    <th class="px-5 py-3 border-b-2 border-gray-200 bg-gray-100 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Promosi</th>
                    <th class="px-5 py-3 border-b-2 border-gray-200 bg-gray-100 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Tipe</th>
                    <th class="px-5 py-3 border-b-2 border-gray-200 bg-gray-100 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Nilai</th>
                    <th class="px-5 py-3 border-b-2 border-gray-200 bg-gray-100 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Periode</th>
                    <th class="px-5 py-3 border-b-2 border-gray-200 bg-gray-100 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Status</th>
                    <th class="px-5 py-3 border-b-2 border-gray-200 bg-gray-100 text-center text-xs font-semibold text-gray-600 uppercase tracking-wider">Aksi</th>
                </tr>
            </thead>
            <tbody>
                <!-- Contoh Item 1 -->
                <tr>
                    <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm">
                        <p class="text-gray-900 whitespace-no-wrap font-semibold">Diskon Gajian</p>
                        <p class="text-gray-600 whitespace-no-wrap text-xs">GAJIANSERU</p>
                    </td>
                    <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm">Diskon Persentase</td>
                    <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm">15%</td>
                    <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm">25 Okt - 30 Okt 2025</td>
                    <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm">
                        <span class="relative inline-block px-3 py-1 font-semibold text-green-900 leading-tight">
                            <span aria-hidden class="absolute inset-0 bg-green-200 opacity-50 rounded-full"></span>
                            <span class="relative">Aktif</span>
                        </span>
                    </td>
                    <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm text-center">
                        <!-- Keputusan "Do you want to update/delete?" -->
                        <a href="{{ route('seller.promotion.edit', 1) }}" class="text-indigo-600 hover:text-indigo-900 mr-4">Edit</a>
                        <form action="{{ route('seller.promotion.destroy', 1) }}" method="POST" class="inline-block" onsubmit="return confirm('Apakah Anda yakin ingin menghapus promosi ini?');">
                            @csrf
                            @method('DELETE')
                            <button type="submit" class="text-red-600 hover:text-red-900">Hapus</button>
                        </form>
                    </td>
                </tr>
                 <!-- Contoh Item 2 -->
                <tr>
                    <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm">
                        <p class="text-gray-900 whitespace-no-wrap font-semibold">Potongan Ongkir</p>
                        <p class="text-gray-600 whitespace-no-wrap text-xs">GRATISONGKIR</p>
                    </td>
                    <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm">Potongan Harga</td>
                    <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm">Rp 10.000</td>
                    <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm">1 Nov - 30 Nov 2025</td>
                    <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm">
                        <span class="relative inline-block px-3 py-1 font-semibold text-yellow-900 leading-tight">
                            <span aria-hidden class="absolute inset-0 bg-yellow-200 opacity-50 rounded-full"></span>
                            <span class="relative">Akan Datang</span>
                        </span>
                    </td>
                    <td class="px-5 py-5 border-b border-gray-200 bg-white text-sm text-center">
                        <a href="{{ route('seller.promotion.edit', 2) }}" class="text-indigo-600 hover:text-indigo-900 mr-4">Edit</a>
                        <form action="{{ route('seller.promotion.destroy', 2) }}" method="POST" class="inline-block" onsubmit="return confirm('Apakah Anda yakin ingin menghapus promosi ini?');">
                            @csrf
                            @method('DELETE')
                            <button type="submit" class="text-red-600 hover:text-red-900">Hapus</button>
                        </form>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</div>
@endsection
