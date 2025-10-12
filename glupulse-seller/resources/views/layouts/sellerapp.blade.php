<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Seller Dashboard</title>
    {{-- Memuat Tailwind CSS dari CDN --}}
    <script src="https://cdn.tailwindcss.com"></script>
    {{-- 1. Memuat Alpine.js --}}
    <script defer src="https://cdn.jsdelivr.net/npm/@alpinejs/persist@3.x.x/dist/cdn.min.js"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
    {{-- Memuat Flowbite JS untuk komponen interaktif seperti Tab --}}
    <script src="https://cdnjs.cloudflare.com/ajax/libs/flowbite/2.2.1/flowbite.min.js"></script>
</head>
<body class="bg-white">
    {{-- 2. Pindahkan state Alpine ke pembungkus utama --}}
    {{-- Gunakan $persist untuk menyimpan state 'isLocked' di localStorage --}}
    <div class="flex" x-data="{ isLocked: $persist(false), isHovering: false }">
        {{-- Sidebar --}}
        <x-seller-sidebar />

        {{-- 3. Wrapper untuk Konten Utama yang akan bergeser --}}
        <div class="flex-grow flex flex-col transition-all duration-300 ease-in-out" :style="(isLocked || isHovering) ? 'margin-left: 250px' : 'margin-left: 72px'">
            {{-- Main Content --}}
            <main class="flex-grow p-6">
                @yield('content')
            </main>
        </div>
    </div>

    {{-- Stack untuk memuat script dari halaman spesifik (misal: Chart.js) --}}
    @stack('scripts')
</body>
</html>
