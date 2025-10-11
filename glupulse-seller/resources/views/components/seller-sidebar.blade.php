{{-- 
    Komponen ini akan menampilkan sidebar navigasi untuk panel seller.
    Komponen ini juga secara otomatis akan menandai link yang aktif
    berdasarkan route yang sedang diakses.
--}}
<aside 
    @mouseenter="isHovering = true"
    @mouseleave="isHovering = false"
    class="bg-gray-800 text-white h-screen p-4 fixed top-0 left-0 flex flex-col transition-all duration-300 ease-in-out z-20"
    :class="(isLocked || isHovering) ? 'w-[250px]' : 'w-[72px]'">

    <div class="flex items-center mb-6" :class="(isLocked || isHovering) ? 'justify-between' : 'justify-center'">
        <h1 x-show="isLocked || isHovering" class="text-xl font-bold transition-opacity duration-300 whitespace-nowrap">Glupulse Seller</h1>
        <button @click="isLocked = !isLocked" class="p-1 rounded-full hover:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-gray-500">
            {{-- Ikon untuk mengunci (pin) atau membuka kunci (unpin) --}}
            {{-- Tampilkan ikon 'unpin' jika terkunci --}}
            <svg x-show="isLocked" class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path></svg>
            {{-- Tampilkan ikon 'pin' jika tidak terkunci --}}
            <svg x-show="!isLocked" class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path></svg>
        </button>
    </div>
    
    {{-- Navigasi utama --}}
    <nav class="flex-grow">
        <ul class="space-y-2">
            <li>
                <a href="{{ route('seller.dashboard') }}" class="flex items-center p-2 rounded-lg hover:bg-gray-700 {{ request()->routeIs('seller.dashboard') ? 'bg-gray-900 font-bold' : '' }}" :class="!(isLocked || isHovering) && 'justify-center'">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>
                    <span x-show="isLocked || isHovering" class="ml-3 whitespace-nowrap">Dashboard</span>
                </a>
            </li>
            <li>
                <a href="{{ route('seller.menu') }}" class="flex items-center p-2 rounded-lg hover:bg-gray-700 {{ request()->routeIs('seller.menu') ? 'bg-gray-900 font-bold' : '' }}" :class="!(isLocked || isHovering) && 'justify-center'">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path></svg>
                    <span x-show="isLocked || isHovering" class="ml-3 whitespace-nowrap">Menu</span>
                </a>
            </li>
            <li>
                <a href="{{ route('seller.orders') }}" class="flex items-center p-2 rounded-lg hover:bg-gray-700 {{ request()->routeIs('seller.orders') ? 'bg-gray-900 font-bold' : '' }}" :class="!(isLocked || isHovering) && 'justify-center'">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"></path></svg>
                    <span x-show="isLocked || isHovering" class="ml-3 whitespace-nowrap">Orders</span>
                </a>
            </li>
            <li>
                <a href="{{ route('seller.finance') }}" class="flex items-center p-2 rounded-lg hover:bg-gray-700 {{ request()->routeIs('seller.finance') ? 'bg-gray-900 font-bold' : '' }}" :class="!(isLocked || isHovering) && 'justify-center'">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 17h8m0 0V9m0 8l-8-8-4 4-6-6"></path></svg>
                    <span x-show="isLocked || isHovering" class="ml-3 whitespace-nowrap">Finance</span>
                </a>
            </li>
            <li>
                <a href="{{ route('seller.settings') }}" class="flex items-center p-2 rounded-lg hover:bg-gray-700 {{ request()->routeIs('seller.settings') ? 'bg-gray-900 font-bold' : '' }}" :class="!(isLocked || isHovering) && 'justify-center'">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path></svg>
                    <span x-show="isLocked || isHovering" class="ml-3 whitespace-nowrap">Profile</span>
                </a>
            </li>
        </ul>
    </nav>

    {{-- Tombol Logout di bagian bawah --}}
    <div>
        <a href="#" class="flex items-center p-2 rounded-lg text-red-400 hover:bg-red-500 hover:text-white transition-colors duration-200" :class="!(isLocked || isHovering) && 'justify-center'">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path></svg>
            <span x-show="isLocked || isHovering" class="ml-3 whitespace-nowrap">Logout</span>
        </a>
    </div>
</aside>