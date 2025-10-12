@extends('layouts.sellerapp')

@section('content')
<div class="flex justify-between items-center mb-6">
    <h2 class="text-2xl font-bold text-gray-800">Tambah Menu Baru</h2>
    <a href="{{ route('seller.menu') }}" class="bg-gray-200 hover:bg-gray-300 text-gray-800 font-bold py-2 px-4 rounded-lg">
        Batal
    </a>
</div>

<div class="bg-white p-8 rounded-lg shadow-md">
    {{-- Ganti action ke route yang sesuai untuk menyimpan data --}}
    <form action="{{ route('seller.menu') }}" method="POST" enctype="multipart/form-data" class="space-y-6">
        @csrf
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
            {{-- Kolom Kiri: Upload Gambar --}}
            <div class="lg:col-span-1">
                <label class="block text-sm font-medium text-gray-700 mb-2">Foto Menu</label>
                <div class="mt-1 flex justify-center px-6 pt-5 pb-6 border-2 border-gray-300 border-dashed rounded-md">
                    <div class="space-y-1 text-center">
                        <svg class="mx-auto h-12 w-12 text-gray-400" stroke="currentColor" fill="none" viewBox="0 0 48 48" aria-hidden="true">
                            <path d="M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4 4m4-24h8m-4-4v8" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
                        </svg>
                        <div class="flex text-sm text-gray-600">
                            <label for="file-upload" class="relative cursor-pointer bg-white rounded-md font-medium text-blue-600 hover:text-blue-500 focus-within:outline-none focus-within:ring-2 focus-within:ring-offset-2 focus-within:ring-blue-500">
                                <span>Unggah file</span>
                                <input id="file-upload" name="file-upload" type="file" class="sr-only">
                            </label>
                            <p class="pl-1">atau tarik dan lepas</p>
                        </div>
                        <p class="text-xs text-gray-500">PNG, JPG, GIF hingga 10MB</p>
                    </div>
                </div>
            </div>

            {{-- Kolom Kanan: Detail Menu --}}
            <div class="lg:col-span-2 space-y-4">
                <div>
                    <label for="menu_name" class="block text-sm font-medium text-gray-700">Nama Menu</label>
                    <input type="text" name="menu_name" id="menu_name" placeholder="Contoh: Nasi Goreng Spesial" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm">
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label for="category" class="block text-sm font-medium text-gray-700">Kategori</label>
                        <select id="category" name="category" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm">
                            <option>Makanan Utama</option>
                            <option>Minuman</option>
                            <option>Camilan</option>
                        </select>
                    </div>
                    <div>
                        <label for="price" class="block text-sm font-medium text-gray-700">Harga</label>
                        <input type="number" name="price" id="price" placeholder="Contoh: 25000" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm">
                    </div>
                </div>

                <div>
                    <label for="description" class="block text-sm font-medium text-gray-700">Deskripsi</label>
                    <textarea id="description" name="description" rows="3" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm" placeholder="Deskripsi singkat tentang menu..."></textarea>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700">Status</label>
                    <div class="mt-2 flex items-center">
                        <input id="status_available" name="status" type="radio" value="tersedia" checked class="focus:ring-blue-500 h-4 w-4 text-blue-600 border-gray-300">
                        <label for="status_available" class="ml-3 block text-sm font-medium text-gray-700">Tersedia</label>
                        <input id="status_unavailable" name="status" type="radio" value="habis" class="ml-6 focus:ring-blue-500 h-4 w-4 text-blue-600 border-gray-300">
                        <label for="status_unavailable" class="ml-3 block text-sm font-medium text-gray-700">Habis</label>
                    </div>
                </div>
            </div>
        </div>

        <div class="pt-4 flex justify-end">
            <button type="submit" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-lg">
                Simpan Menu
            </button>
        </div>
    </form>
</div>
@endsection