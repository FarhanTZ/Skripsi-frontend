@extends('layouts.sellerapp')

@section('content')
<h2 class="text-2xl font-bold text-gray-800 mb-6">Pengaturan Toko</h2>

<div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
    <!-- Kolom Kiri: Form Pengaturan -->
    <div class="lg:col-span-2 space-y-6">
        <!-- Profil Toko -->
        <div class="bg-white p-6 rounded-lg shadow-md">
            <h3 class="text-lg font-semibold border-b pb-2 mb-4">Profil Toko</h3>
            <form class="space-y-4">
                <div>
                    <label for="store_name" class="block text-sm font-medium text-gray-700">Nama Toko</label>
                    <input type="text" name="store_name" id="store_name" value="Toko Makanan Enak" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm">
                </div>
                <div>
                    <label for="address" class="block text-sm font-medium text-gray-700">Alamat</label>
                    <textarea name="address" id="address" rows="3" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm">Jl. Kenangan No. 123, Jakarta</textarea>
                </div>
                <div>
                    <label for="description" class="block text-sm font-medium text-gray-700">Deskripsi Singkat</label>
                    <input type="text" name="description" id="description" value="Menjual aneka makanan lezat dan halal." class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm">
                </div>
            </form>
        </div>

        <!-- Jam Operasional -->
        <div class="bg-white p-6 rounded-lg shadow-md">
            <h3 class="text-lg font-semibold border-b pb-2 mb-4">Jam Operasional</h3>
            <div class="space-y-2">
                <div class="grid grid-cols-4 items-center gap-4">
                    <label class="text-sm font-medium text-gray-700">Senin - Jumat</label>
                    <input type="time" value="09:00" class="col-span-1 block w-full rounded-md border-gray-300 shadow-sm sm:text-sm">
                    <span>-</span>
                    <input type="time" value="21:00" class="col-span-1 block w-full rounded-md border-gray-300 shadow-sm sm:text-sm">
                </div>
                 <div class="grid grid-cols-4 items-center gap-4">
                    <label class="text-sm font-medium text-gray-700">Sabtu - Minggu</label>
                    <input type="time" value="10:00" class="col-span-1 block w-full rounded-md border-gray-300 shadow-sm sm:text-sm">
                    <span>-</span>
                    <input type="time" value="22:00" class="col-span-1 block w-full rounded-md border-gray-300 shadow-sm sm:text-sm">
                </div>
            </div>
        </div>
    </div>

    <!-- Kolom Kanan: Aksi -->
    <div class="lg:col-span-1">
        <div class="bg-white p-6 rounded-lg shadow-md">
            <h3 class="text-lg font-semibold mb-4">Aksi</h3>
            <div class="space-y-4">
                <button class="w-full bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-lg">
                    Simpan Perubahan
                </button>
                <button class="w-full bg-gray-200 hover:bg-gray-300 text-gray-800 font-bold py-2 px-4 rounded-lg">
                    Ubah Password
                </button>
            </div>
        </div>
    </div>
</div>
@endsection