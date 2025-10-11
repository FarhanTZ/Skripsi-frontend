@extends('layouts.sellerapp')

@section('content')
<div class="flex justify-between items-center mb-6">
    <h2 class="text-2xl font-bold text-gray-800">Dashboard</h2>

    <!-- Filter Tanggal -->
    <div class="relative">
        <button id="dropdownDefaultButton" data-dropdown-toggle="dropdown-date" class="text-gray-700 bg-white hover:bg-gray-100 border border-gray-300 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center inline-flex items-center" type="button">
            Minggu Ini
            <svg class="w-2.5 h-2.5 ms-3" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 10 6">
                <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 1 4 4 4-4"/>
            </svg>
        </button>
        
        <!-- Dropdown menu -->
        <div id="dropdown-date" class="z-10 hidden bg-white divide-y divide-gray-100 rounded-lg shadow w-44">
            <ul class="py-2 text-sm text-gray-700" aria-labelledby="dropdownDefaultButton">
              <li><a href="#" class="block px-4 py-2 hover:bg-gray-100">Minggu Ini</a></li>
              <li><a href="#" class="block px-4 py-2 hover:bg-gray-100">Bulan Ini</a></li>
              <li><a href="#" class="block px-4 py-2 hover:bg-gray-100">Tahun Ini</a></li>
            </ul>
        </div>
    </div>
</div>

<!-- Grid untuk kartu statistik -->
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-6">
    <!-- Kartu Total Penjualan -->
    <div class="bg-white p-6 rounded-lg shadow-md flex flex-col items-center justify-center">
        <div class="text-gray-500 text-sm font-medium mb-2">Total Penjualan</div>
        <div class="text-3xl font-bold text-gray-900">Rp 3.250.000</div>
    </div>

    <!-- Kartu Pesanan Hari Ini -->
    <div class="bg-white p-6 rounded-lg shadow-md flex flex-col items-center justify-center">
        <div class="text-gray-500 text-sm font-medium mb-2">Pesanan Hari Ini</div>
        <div class="text-3xl font-bold text-gray-900">25</div>
    </div>

    <!-- Kartu Menu Aktif -->
    <div class="bg-white p-6 rounded-lg shadow-md flex flex-col items-center justify-center">
        <div class="text-gray-500 text-sm font-medium mb-2">Menu Aktif</div>
        <div class="text-3xl font-bold text-gray-900">14</div>
    </div>

    <!-- Kartu Rating Rata-rata -->
    <div class="bg-white p-6 rounded-lg shadow-md flex flex-col items-center justify-center">
        <div class="text-gray-500 text-sm font-medium mb-2">Rating Rata-rata</div>
        <div class="text-3xl font-bold text-gray-900 flex items-center">
            4.8 <span class="text-yellow-400 ml-2">⭐</span>
        </div>
    </div>
</div>

<!-- Grafik Penjualan -->
<div class="bg-white p-6 rounded-lg shadow-md">
    <h5 class="text-lg font-semibold text-gray-800 mb-4">📈 Grafik Penjualan Mingguan</h5>
    <canvas id="salesChart"></canvas>
</div>
@endsection

@push('scripts')
<!-- Memuat Chart.js dari CDN -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const ctx = document.getElementById('salesChart').getContext('2d');

        // Data contoh untuk grafik. Anda bisa menggantinya dengan data dari backend.
        const salesData = {
            labels: ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'],
            datasets: [{
                label: 'Penjualan (Rp)',
                data: [450000, 520000, 480000, 610000, 550000, 750000, 680000],
                backgroundColor: 'rgba(75, 192, 192, 0.2)',
                borderColor: 'rgba(75, 192, 192, 1)',
                borderWidth: 2,
                tension: 0.4, // Membuat garis lebih melengkung
                fill: true
            }]
        };

        const salesChart = new Chart(ctx, {
            type: 'line', // Tipe grafik (bisa 'bar', 'pie', dll)
            data: salesData,
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    });
</script>
@endpush
