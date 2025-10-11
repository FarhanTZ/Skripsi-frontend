@extends('layouts.sellerapp')

@section('content')
<div class="flex justify-between items-center mb-6">
    <h2 class="text-2xl font-bold text-gray-800">Laporan Keuangan</h2>

    <!-- Filter Tanggal -->
    <div class="relative">
        <button id="dropdownDefaultButton" data-dropdown-toggle="dropdown-date" class="text-gray-700 bg-white hover:bg-gray-100 border border-gray-300 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center inline-flex items-center" type="button">
            Bulan Ini
            <svg class="w-2.5 h-2.5 ms-3" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 10 6">
                <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 1 4 4 4-4"/>
            </svg>
        </button>
        
        <!-- Dropdown menu -->
        <div id="dropdown-date" class="z-10 hidden bg-white divide-y divide-gray-100 rounded-lg shadow w-44">
            <ul class="py-2 text-sm text-gray-700" aria-labelledby="dropdownDefaultButton">
              <li><a href="#" class="block px-4 py-2 hover:bg-gray-100">Bulan Ini</a></li>
              <li><a href="#" class="block px-4 py-2 hover:bg-gray-100">Bulan Lalu</a></li>
              <li><a href="#" class="block px-4 py-2 hover:bg-gray-100">Tahun Ini</a></li>
            </ul>
        </div>
    </div>
</div>

<!-- Grid untuk kartu statistik -->
<div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">
    <div class="bg-white p-6 rounded-lg shadow-md">
        <h5 class="text-gray-500 text-sm font-medium mb-2">Total Pendapatan</h5>
        <p class="text-3xl font-bold text-gray-900">Rp 12.500.000</p>
    </div>
    <div class="bg-white p-6 rounded-lg shadow-md">
        <h5 class="text-gray-500 text-sm font-medium mb-2">Pendapatan Bulan Ini</h5>
        <p class="text-3xl font-bold text-gray-900">Rp 3.250.000</p>
    </div>
    <div class="bg-white p-6 rounded-lg shadow-md">
        <h5 class="text-gray-500 text-sm font-medium mb-2">Saldo Siap Ditarik</h5>
        <p class="text-3xl font-bold text-green-600">Rp 1.500.000</p>
    </div>
</div>

<!-- Grafik dan Riwayat Transaksi -->
<div class="grid grid-cols-1 lg:grid-cols-5 gap-6">
    <!-- Grafik Pendapatan -->
    <div class="lg:col-span-3 bg-white p-6 rounded-lg shadow-md">
        <h5 class="text-lg font-semibold text-gray-800 mb-4">📊 Grafik Pendapatan Bulanan</h5>
        <canvas id="incomeChart"></canvas>
    </div>

    <!-- Riwayat Transaksi -->
    <div class="lg:col-span-2 bg-white p-6 rounded-lg shadow-md">
        <h5 class="text-lg font-semibold text-gray-800 mb-4">Riwayat Transaksi Terakhir</h5>
        <div class="space-y-4">
            <!-- Contoh Transaksi -->
            <div class="flex justify-between items-center">
                <div>
                    <p class="font-semibold text-gray-800">Pesanan #ORD-12345</p>
                    <p class="text-sm text-gray-500">15 Nov 2023, 10:30</p>
                </div>
                <p class="font-bold text-green-600">+ Rp 55.000</p>
            </div>
            <hr>
            <div class="flex justify-between items-center">
                <div>
                    <p class="font-semibold text-gray-800">Penarikan Dana</p>
                    <p class="text-sm text-gray-500">14 Nov 2023, 09:00</p>
                </div>
                <p class="font-bold text-red-600">- Rp 1.000.000</p>
            </div>
            <hr>
            <!-- Transaksi lainnya -->
        </div>
    </div>
</div>
@endsection

@push('scripts')
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const ctx = document.getElementById('incomeChart').getContext('2d');
        const incomeChart = new Chart(ctx, {
            type: 'bar', // Menggunakan bar chart
            data: {
                labels: ['Minggu 1', 'Minggu 2', 'Minggu 3', 'Minggu 4'],
                datasets: [{
                    label: 'Pendapatan (Rp)',
                    data: [800000, 950000, 750000, 1100000],
                    backgroundColor: 'rgba(59, 130, 246, 0.5)',
                    borderColor: 'rgba(59, 130, 246, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                },
                plugins: {
                    legend: {
                        display: false
                    }
                }
            }
        });
    });
</script>
@endpush