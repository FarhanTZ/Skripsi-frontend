<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Halaman Registrasi</title>
    {{-- Ini akan memuat Tailwind CSS dari CDN --}}
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-[#242E49]">

    {{-- Kontainer Utama --}}
    <div class="min-h-screen flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
        <div class="max-w-md w-full space-y-8">
            
            {{-- Card Form Register --}}
            {{-- Tinggi card disesuaikan otomatis (h-auto) karena input lebih banyak --}}
            <div class="bg-white rounded-[30px] shadow-xl p-8 w-[411px] h-auto pb-10">
                {{-- Judul --}}
                <div class="mb-[40px]">
                    <h2 class="text-center text-3xl font-extrabold text-[#242E49]">
                        GluPulse Register
                    </h2>
                </div>

                {{-- Pesan Error Global --}}
                @if ($errors->any())
                    <div class="mb-4 bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative" role="alert">
                        <strong class="font-bold">Oops!</strong>
                        <span class="block sm:inline">{{ $errors->first() }}</span>
                    </div>
                @endif
                
                <form class="space-y-[30px]" action="{{ route('register.perform') }}" method="POST" novalidate>
                    @csrf
                    
                    {{-- Input Nama --}}
                    <div>
                        <input id="name" name="name" type="text" required placeholder="Full Name" value="{{ old('name') }}"
                               class="appearance-none block w-[331px] h-[55px] mx-auto px-4 border-0 rounded-[20px] shadow-md bg-[#E0E0E0] text-gray-900 placeholder-[#808B9B] focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:text-sm">
                    </div>

                    {{-- Input Email --}}
                    <div>
                        <input id="email" name="email" type="email" autocomplete="email" required placeholder="Email" value="{{ old('email') }}"
                               class="appearance-none block w-[331px] h-[55px] mx-auto px-4 border-0 rounded-[20px] shadow-md bg-[#E0E0E0] text-gray-900 placeholder-[#808B9B] focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:text-sm">
                    </div>

                    {{-- Input Password --}}
                    <div>
                        <input id="password" name="password" type="password" autocomplete="new-password" required placeholder="Password" 
                               class="appearance-none block w-[331px] h-[55px] mx-auto px-4 border-0 rounded-[20px] shadow-md bg-[#E0E0E0] text-gray-900 placeholder-[#808B9B] focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:text-sm">
                    </div>

                    {{-- Input Konfirmasi Password --}}
                    <div>
                        <input id="password_confirmation" name="password_confirmation" type="password" autocomplete="new-password" required placeholder="Confirm Password" 
                               class="appearance-none block w-[331px] h-[55px] mx-auto px-4 border-0 rounded-[20px] shadow-md bg-[#E0E0E0] text-gray-900 placeholder-[#808B9B] focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:text-sm">
                    </div>

                    {{-- Tombol Submit --}}
                    <div>
                        <button type="submit"
                                class="group relative w-[241px] h-[55px] mx-auto flex justify-center items-center px-4 border-0 text-[20px] font-bold rounded-[20px] text-white bg-[#242E49] shadow-md hover:brightness-110 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                            Sign Up
                        </button>
                    </div>

                    {{-- Link ke Login --}}
                    <div class="text-center text-sm">
                        <a href="{{ route('login') }}" class="font-medium text-indigo-600 hover:text-indigo-500">
                            Already have an account? Sign In
                        </a>
                    </div>
                </form>
            </div>

        </div>
    </div>

</body>
</html>
