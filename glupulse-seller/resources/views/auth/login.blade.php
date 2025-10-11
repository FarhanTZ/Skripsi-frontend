<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Halaman Login</title>
    {{-- Ini akan memuat Tailwind CSS dari CDN --}}
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-[#242E49]">

    {{-- Kontainer Utama untuk menengahkan form --}}
    <div class="min-h-screen flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
        <div class="max-w-md w-full space-y-8">
            
            {{-- Card Form Login --}}
            <div class="bg-white rounded-[30px] shadow-xl p-8 w-[411px] h-[433px]">
                {{-- Judul di dalam Card --}}
                <div class="mb-[58px]">
                    <h2 class="text-center text-3xl font-extrabold text-[#242E49]">
                        GluPulse
                    </h2>
                </div>
                
                <form class="space-y-[58px]" action="{{ route('seller.dashboard') }}" method="GET" novalidate>                    
                    {{-- Input untuk Email --}}
                    <div>
                        <input id="email" name="email" type="email" autocomplete="email" required placeholder="Email" 
                               class="appearance-none block w-[331px] h-[55px] mx-auto px-4 border-0 rounded-[20px] shadow-md bg-[#E0E0E0] text-gray-900 placeholder-[#808B9B] focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:text-sm">
                    </div>

                    {{-- Input untuk Password --}}
                    <div>
                        <input id="password" name="password" type="password" autocomplete="current-password" required placeholder="Password" 
                               class="appearance-none block w-[331px] h-[55px] mx-auto px-4 border-0 rounded-[20px] shadow-md bg-[#E0E0E0] text-gray-900 placeholder-[#808B9B] focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:text-sm">
                    </div>

                    {{-- Tombol Submit --}}
                    <div>
                        <button type="submit"
                                class="group relative w-[241px] h-[55px] mx-auto flex justify-center items-center px-4 border-0 text-[20px] font-bold rounded-[20px] text-white bg-[#242E49] shadow-md hover:brightness-110 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                            Sign In
                        </button>
                    </div>
                </form>
            </div>

        </div>
    </div>

</body>
</html>
