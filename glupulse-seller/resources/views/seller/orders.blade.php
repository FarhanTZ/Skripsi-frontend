@extends('layouts.sellerapp')

@section('content')

<!-- Awal: Sesuai dengan "Click Order List View" -> "Display Order List View" -->
<div class="flex justify-between items-center mb-6">
    <h2 class="text-2xl font-bold text-gray-800">Daftar Pesanan</h2>
    <div class="relative">
        <div class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none">
            <svg class="w-4 h-4 text-gray-500" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 20 20">
                <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m19 19-4-4m0-7A7 7 0 1 1 1 8a7 7 0 0 1 14 0Z"/>
            </svg>
        </div>
        <input type="search" id="order-search" class="block w-full p-2.5 pl-10 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50 focus:ring-blue-500 focus:border-blue-500" placeholder="Cari ID Pesanan...">
    </div>
</div>

<!-- Navigasi Tab untuk memfilter status pesanan -->
<div class="mb-4 border-b border-gray-200">
    <ul class="flex flex-wrap -mb-px text-sm font-medium text-center" id="myTab" data-tabs-toggle="#myTabContent" role="tablist">
        <li class="mr-2" role="presentation">
            <button class="inline-block p-4 border-b-2 rounded-t-lg" id="new-tab" data-tabs-target="#new" type="button" role="tab" aria-controls="new" aria-selected="true">Pesanan Baru (1)</button>
        </li>
        <li class="mr-2" role="presentation">
            <button class="inline-block p-4 border-b-2 border-transparent rounded-t-lg hover:text-gray-600 hover:border-gray-300" id="progress-tab" data-tabs-target="#progress" type="button" role="tab" aria-controls="progress" aria-selected="false">Diproses (1)</button>
        </li>
        <li class="mr-2" role="presentation">
            <button class="inline-block p-4 border-b-2 border-transparent rounded-t-lg hover:text-gray-600 hover:border-gray-300" id="completed-tab" data-tabs-target="#completed" type="button" role="tab" aria-controls="completed" aria-selected="false">Selesai (1)</button>
        </li>
        <li class="mr-2" role="presentation">
            <button class="inline-block p-4 border-b-2 border-transparent rounded-t-lg hover:text-gray-600 hover:border-gray-300" id="rejected-tab" data-tabs-target="#rejected" type="button" role="tab" aria-controls="rejected" aria-selected="false">Ditolak (1)</button>
        </li>
    </ul>
</div>

<!-- Konten Tab -->
<div id="myTabContent">
    <!-- 1. Konten Pesanan Baru -->
    <!-- Sesuai dengan "Display Incoming Order View" -->
    <div class="hidden p-4 rounded-lg bg-gray-50" id="new" role="tabpanel" aria-labelledby="new-tab">
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <!-- Contoh Kartu Pesanan Baru -->
            <div class="bg-white p-6 rounded-lg shadow-md hover:shadow-xl transition-shadow duration-300">
                <div class="flex justify-between items-start">
                    <div>
                        <p class="font-bold text-lg text-gray-800">#ORD-12345</p>
                        <p class="text-sm text-gray-500">John Doe - <span class="text-xs text-gray-400">5 menit yang lalu</span></p>
                    </div>
                    <span class="text-sm font-semibold text-white bg-blue-500 px-2 py-1 rounded-md">Baru</span>
                </div>
                <hr class="my-4">
                <div class="space-y-2 text-sm">
                    <p>2x Nasi Goreng Spesial</p>
                    <p>1x Es Teh Manis</p>
                    <p class="text-gray-500 italic">Catatan: "Nasi gorengnya jangan pedas."</p>
                </div>
                <hr class="my-4">
                <div class="flex justify-between items-center">
                    <p class="font-bold text-gray-900">Rp 55.000</p>
                    <!-- Aksi: "Select Order" untuk melihat detail -->
                    <button data-modal-target="order-detail-modal" data-modal-toggle="order-detail-modal" class="bg-gray-200 hover:bg-gray-300 text-gray-800 font-bold py-2 px-4 rounded-lg">
                        Lihat Detail
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- 2. Konten Diproses -->
    <div class="hidden p-4 rounded-lg bg-gray-50" id="progress" role="tabpanel" aria-labelledby="progress-tab">
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
             <div class="bg-white p-6 rounded-lg shadow-md">
                <div class="flex justify-between items-start">
                    <div>
                        <p class="font-bold text-lg text-gray-800">#ORD-12344</p>
                        <p class="text-sm text-gray-500">Jane Smith - <span class="text-xs text-gray-400">15 menit yang lalu</span></p>
                    </div>
                    <span class="text-sm font-semibold text-white bg-yellow-500 px-2 py-1 rounded-md">Diproses</span>
                </div>
                <hr class="my-4">
                <div class="space-y-2 text-sm">
                    <p>1x Ayam Bakar</p>
                </div>
                <hr class="my-4">
                <div class="flex justify-between items-center">
                    <p class="font-bold text-gray-900">Rp 25.000</p>
                    <!-- Aksi selanjutnya setelah pesanan diterima -->
                    <button class="bg-green-500 hover:bg-green-600 text-white font-bold py-2 px-4 rounded-lg">
                        Selesaikan Pesanan
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- 3. Konten Selesai -->
    <div class="hidden p-4 rounded-lg bg-gray-50" id="completed" role="tabpanel" aria-labelledby="completed-tab">
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <div class="bg-white p-6 rounded-lg shadow-sm border border-gray-200 opacity-75">
                <div class="flex justify-between items-start">
                    <div>
                        <p class="font-bold text-lg text-gray-800">#ORD-12340</p>
                        <p class="text-sm text-gray-500">Alex Johnson - <span class="text-xs text-gray-400">1 jam yang lalu</span></p>
                    </div>
                    <span class="text-sm font-semibold text-white bg-gray-500 px-2 py-1 rounded-md">Selesai</span>
                </div>
                <hr class="my-4">
                <div class="space-y-2 text-sm">
                    <p>1x Kopi Hitam</p>
                </div>
                <hr class="my-4">
                <div class="flex justify-between items-center">
                    <p class="font-bold text-gray-900">Rp 10.000</p>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 4. Konten Ditolak -->
    <div class="hidden p-4 rounded-lg bg-gray-50" id="rejected" role="tabpanel" aria-labelledby="rejected-tab">
         <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <div class="bg-white p-6 rounded-lg shadow-sm border border-gray-200 opacity-75">
                <div class="flex justify-between items-start">
                    <div>
                        <p class="font-bold text-lg text-gray-800">#ORD-12333</p>
                        <p class="text-sm text-gray-500">Michael Bay - <span class="text-xs text-gray-400">Kemarin</span></p>
                    </div>
                    <span class="text-sm font-semibold text-white bg-red-500 px-2 py-1 rounded-md">Ditolak</span>
                </div>
                <hr class="my-4">
                <div class="space-y-2 text-sm">
                    <p>10x Nasi Goreng Spesial</p>
                </div>
                <hr class="my-4">
                <div class="flex justify-between items-center">
                    <p class="font-bold text-gray-900">Rp 250.000</p>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Akhir: Sesuai dengan "Display Order List View" -->


<!-- Modal Detail Pesanan -->
<!-- Ini adalah implementasi dari "Detail Order View" -->
<div id="order-detail-modal" tabindex="-1" aria-hidden="true" class="hidden overflow-y-auto overflow-x-hidden fixed top-0 right-0 left-0 z-50 justify-center items-center w-full md:inset-0 h-[calc(100%-1rem)] max-h-full">
    <div class="relative p-4 w-full max-w-2xl max-h-full">
        <!-- Modal content -->
        <div class="relative bg-white rounded-lg shadow">
            <!-- Modal header -->
            <div class="flex items-center justify-between p-4 md:p-5 border-b rounded-t">
                <h3 class="text-xl font-semibold text-gray-900">
                    Detail Pesanan #ORD-12345
                </h3>
                <button type="button" class="text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 ms-auto inline-flex justify-center items-center" data-modal-hide="order-detail-modal">
                    <svg class="w-3 h-3" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 14 14"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6"/></svg>
                    <span class="sr-only">Tutup modal</span>
                </button>
            </div>
            <!-- Modal body -->
            <div class="p-4 md:p-5 space-y-4">
                <div class="grid grid-cols-2 gap-4 text-sm">
                    <div>
                        <p class="font-semibold text-gray-500">Nama Pelanggan</p>
                        <p class="text-gray-800">John Doe</p>
                    </div>
                    <div>
                        <p class="font-semibold text-gray-500">Waktu Pesanan</p>
                        <p class="text-gray-800">5 menit yang lalu</p>
                    </div>
                </div>
                <hr>
                <div>
                    <p class="font-semibold text-gray-500 mb-2">Item Pesanan</p>
                    <ul class="list-disc list-inside space-y-1 text-gray-800">
                        <li>2x Nasi Goreng Spesial</li>
                        <li>1x Es Teh Manis</li>
                    </ul>
                </div>
                <hr>
                <div>
                    <p class="font-semibold text-gray-500">Catatan Pelanggan</p>
                    <p class="text-gray-800 italic p-2 bg-gray-100 rounded-md">"Nasi gorengnya jangan pedas."</p>
                </div>
                <hr>
                <div class="text-right">
                    <p class="font-semibold text-gray-500">Total Pembayaran</p>
                    <p class="text-2xl font-bold text-gray-900">Rp 55.000</p>
                </div>
            </div>
            <!-- Modal footer: Ini adalah Decision Point "Accept/Reject Order" -->
            <div class="flex items-center justify-end p-4 md:p-5 border-t border-gray-200 rounded-b space-x-3">
                <!-- Aksi: "Click Reject Order" -->
                <button data-modal-hide="order-detail-modal" type="button" class="bg-red-600 hover:bg-red-700 text-white font-bold py-2.5 px-5 rounded-lg">
                    Tolak Pesanan
                </button>
                <!-- Aksi: "Click Accept Order" -->
                <button data-modal-hide="order-detail-modal" type="button" class="bg-green-600 hover:bg-green-700 text-white font-bold py-2.5 px-5 rounded-lg">
                    Terima & Proses Pesanan
                </button>
            </div>
        </div>
    </div>
</div>


<!-- Pastikan Anda memuat JavaScript untuk fungsionalitas tab dan modal (misalnya dari Flowbite) -->
@endsection
