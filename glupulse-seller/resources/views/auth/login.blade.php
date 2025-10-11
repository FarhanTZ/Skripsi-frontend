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
            
            {{-- Judul Form --}}
            <div>
                <h2 class="mt-6 text-center text-3xl font-extrabold text-white">
                    Masuk ke akun Anda
                </h2>
            </div>

            {{-- Card Form Login --}}
            <div class="bg-white max-w-md w-full rounded-lg shadow-md p-8">
                <form class="space-y-6" action="{{ route('seller.dashboard') }}" method="GET">
                    {{-- Input untuk Email --}}
                    <div>
                        <label for="email" class="block text-sm font-medium text-gray-700">
                            Alamat Email
                        </label>
                        <div class="mt-1">
                            <input id="email" name="email" type="email" autocomplete="email" required
                                   class="appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                                   placeholder="anda@contoh.com">
                        </div>
                    </div>

                    {{-- Input untuk Password --}}
                    <div>
                        <label for="password" class="block text-sm font-medium text-gray-700">
                            Password
                        </label>
                        <div class="mt-1">
                            <input id="password" name="password" type="password" autocomplete="current-password" required
                                   class="appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                                   placeholder="••••••••">
                        </div>
                    </div>

                    {{-- Tombol Submit --}}
                    <div>
                        <button type="submit"
                                class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                            Masuk
                        </button>
                    </div>
                </form>
            </div>

        </div>
    </div>

</body>
</html>
