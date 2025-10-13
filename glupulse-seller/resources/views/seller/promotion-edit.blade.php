@extends('layouts.sellerapp')

@section('content')
<!-- Sesuai dengan "Display Form Update Promotion View" -->
<div class="flex justify-between items-center mb-6">
    <h2 class="text-2xl font-bold text-gray-800">Edit Promosi</h2>
    <a href="{{ route('seller.promotion.index') }}" class="bg-gray-200 hover:bg-gray-300 text-gray-800 font-bold py-2 px-4 rounded-lg">
        Batal
    </a>
</div>

<div class="bg-white p-8 rounded-lg shadow-md">
    <!-- Form untuk "Update Promotion" dan "Enter Promotion Data" -->
    <form action="{{ route('seller.promotion.update', 1) }}" method="POST" class="space-y-6">
        @csrf
        @method('PUT')
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
                <label for="promo_name" class="block text-sm font-medium text-gray-700">Nama Promosi</label>
                <input type="text" name="promo_name" id="promo_name" value="Diskon Gajian" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm p-2.5 text-base">
            </div>
            <div>
                <label for="promo_code" class="block text-sm font-medium text-gray-700">Kode Promosi</label>
                <input type="text" name="promo_code" id="promo_code" value="GAJIANSERU" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm p-2.5 text-base">
            </div>
        </div>

        <div>
            <label for="description" class="block text-sm font-medium text-gray-700">Deskripsi</label>
            <textarea id="description" name="description" rows="3" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm p-2.5 text-base">Diskon spesial untuk menyambut waktu gajian!</textarea>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
                <label for="promo_type" class="block text-sm font-medium text-gray-700">Tipe Promosi</label>
                <select id="promo_type" name="promo_type" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm p-2.5 text-base">
                    <option value="percentage" selected>Diskon Persentase (%)</option>
                    <option value="fixed">Potongan Harga Tetap (Rp)</option>
                </select>
            </div>
            <div>
                <label for="promo_value" class="block text-sm font-medium text-gray-700">Nilai Promosi</label>
                <input type="number" name="promo_value" id="promo_value" value="15" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm p-2.5 text-base">
            </div>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
                <label for="start_date" class="block text-sm font-medium text-gray-700">Tanggal Mulai</label>
                <input type="date" name="start_date" id="start_date" value="2025-10-25" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm p-2.5 text-base">
            </div>
            <div>
                <label for="end_date" class="block text-sm font-medium text-gray-700">Tanggal Selesai</label>
                <input type="date" name="end_date" id="end_date" value="2025-10-30" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm p-2.5 text-base">
            </div>
        </div>

        <div>
            <label class="block text-sm font-medium text-gray-700">Status</label>
            <div class="mt-2 flex items-center">
                <input id="status_active" name="status" type="radio" value="active" checked class="h-4 w-4 text-blue-600 border-gray-300">
                <label for="status_active" class="ml-3 block text-sm font-medium text-gray-700">Aktif</label>
                <input id="status_inactive" name="status" type="radio" value="inactive" class="ml-6 h-4 w-4 text-blue-600 border-gray-300">
                <label for="status_inactive" class="ml-3 block text-sm font-medium text-gray-700">Tidak Aktif</label>
            </div>
        </div>

        <div class="pt-4 flex justify-end">
            <button type="submit" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-6 rounded-lg">
                Update Promosi
            </button>
        </div>
    </form>
</div>
@endsection
